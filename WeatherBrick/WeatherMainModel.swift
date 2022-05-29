//
//  WeatherMainModel.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 23.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import UIKit

final class WeatherMainModel {
    static let shared = WeatherMainModel()
    private lazy var networkServiceUrl = NetworkServiceURL.shared
    private lazy var countriesWithFlags: [String: Country] = [:]
    lazy var cities: [City] = []
    
    private func sendRequestToOpenWeatherFor(_ location: String, completion: @escaping((ResultOfRequest) -> Void)) {
        networkServiceUrl.getDataFromOpenWeather(location: location) { resultOfrequest in
            completion(resultOfrequest)
        }
    }
    
    func getMyWeather(in location: String, completion: @escaping((MyWeather) -> Void)) {
        sendRequestToOpenWeatherFor(location) { resultOfRequest in
            let myWeather = MyWeather(
                city: resultOfRequest.name ?? "",
                country: self.countriesWithFlags[resultOfRequest.sys?.country ?? ""]?.name ?? "",
                flag: self.countriesWithFlags[resultOfRequest.sys?.country ?? ""]?.flag ?? "",
                temperature: String(Int(resultOfRequest.main?.temp ?? 0.0)) + "°",
                condition: resultOfRequest.weather?.first?.description ?? "",
                mainCondition: resultOfRequest.weather?.first?.main ?? "",
                stoneImage: self.getStoneImage(dependingOn: resultOfRequest))
            completion(myWeather)
        }
    }
    
    func getCountries() {
        networkServiceUrl.getDataFromCoutriesJson { jsonArray in
            for item in jsonArray {
                if let object = item as? [String: String] {
                    let codeIso = object["ISO"] ?? ""
                    let countryName = object["Name"] ?? ""
                    let countryFlag = object["Emoji"] ?? ""
                    let unicode = object["Unicode"] ?? ""
                    let country = Country(codeISO: codeIso, name: countryName, flag: countryFlag, unicode: unicode)
                    self.countriesWithFlags.updateValue(country, forKey: codeIso)
                }
            }
        }
    }
    
    func getCities() {
        DispatchQueue.global(qos: .default).async {
            var tempCities = self.cities
            self.networkServiceUrl.getDataFromCitiesJson { json in
                for item in json {
                    if let object = item as? [String: Any] {
                        let key = object["id"]
                        let name = object["name"]
                        let country = object["country"]
                        
                        let stat = object["stat"] as? [String: Any]
                        let population = stat?["population"]
                      
                        guard let id = key as? Double,
                        let cityName = name as? String,
                        let countryName = country as? String,
                        let citiPopulation = population as? Int else { return }
                        let city = City(name: cityName, id: Int(id), country: countryName, population: citiPopulation)
                        tempCities.append(city)
                    }
                }
            }
            self.cities = tempCities
            print("Population of city \(self.cities[10100].name) is \(self.cities[10100].population) peoples")
        }
    }
    
    func getStoneImage(dependingOn weather: ResultOfRequest) -> String {
        guard let condition = weather.weather?.first?.main,
            let temperature = weather.main?.temp else {
            return String()
        }
        let checkedValue = true
        
        if temperature >= 33.0 {
            return AppConstants.StoneImage.withCracks
        } else {
            switch checkedValue {
            case AppConstants.Precipitation.rain.contains(condition) :
                return AppConstants.StoneImage.wet
                
            case AppConstants.Precipitation.atmosphere.contains(condition):
                return AppConstants.StoneImage.normal
                
            case AppConstants.Precipitation.snow == condition:
                return AppConstants.StoneImage.withSnow
                
            case AppConstants.Precipitation.clearSky == condition:
                return AppConstants.StoneImage.normal
                
            case AppConstants.Precipitation.clouds == condition:
                return AppConstants.StoneImage.normal
                
            default:
                return AppConstants.StoneImage.normal
            }
        }
    }
}
