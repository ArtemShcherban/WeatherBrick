//
//  WeatherMainModel.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 23.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

final class WeatherViewModel {
    static let shared = WeatherViewModel()
    
    private lazy var weatherNetworkService = WeatherNetworkService()
    private lazy var additionalServiceModels = AdditionalServiceModels()
    private lazy var countriesWithFlags: [String: Country] = [:]
    
    init() {
        createCountries()
    }
    
    private func createCountries() {
        additionalServiceModels.getCountries { jsonArray in
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
    
    func createWeatherInfo(with link: URL, completion: @escaping((Result<WeatherInfo, NetworkServiceError>) -> Void)) {
        weatherNetworkService.getWeather(with: link) { resultOrError in
            switch resultOrError {
            case .failure(let error):
                completion(.failure(error))
            case .success(let weather):
                var myWeather = WeatherInfo(
                    city: weather.cityName ?? "",
                    country: self.countriesWithFlags[weather.countryISO ?? ""]?.name ?? "",
                    flag: self.countriesWithFlags[weather.countryISO ?? ""]?.flag ?? "",
                    temperature: String(Int(weather.temperature ?? 0.0)) + "°",
                    conditionDetails: weather.conditionDetails ?? "",
                    conditionMain: weather.conditionMain ?? "",
                    wind: String(Int(weather.windParameters?.speed ?? 0.0)),
                    stoneImage: self.getStoneImage(dependingOn: weather),
                    latitude: weather.coordinates?.latitude ?? 0.0,
                    longitude: weather.coordinates?.longitude ?? 0.0)
                if myWeather.country.isEmpty || myWeather.city.isEmpty {
                    let geoCoordinates = self.convertToGeo(coordinates: ((
                        weather.coordinates?.latitude ?? 0.0,
                        weather.coordinates?.longitude ?? 0.0)))
                    myWeather.city = geoCoordinates.0
                    myWeather.country = geoCoordinates.1
                }
                completion(.success(myWeather))
            }
        }
    }
    
    private func getStoneImage(dependingOn weather: WeatherParameters) -> String {
        guard let condition = weather.conditionMain,
            let temperature = weather.temperature else {
            return String()
        }
        
        let checkedValue = true
        
        if temperature >= 33.0 {
            return ImagesConstants.StoneImage.withCracks
        } else {
            switch checkedValue {
            case PrecipitationConstants.rain.contains(condition) :
                return ImagesConstants.StoneImage.wet
                
            case PrecipitationConstants.atmosphere.contains(condition):
                return ImagesConstants.StoneImage.normal
                
            case PrecipitationConstants.snow == condition:
                return ImagesConstants.StoneImage.withSnow
                
            case PrecipitationConstants.clearSky == condition:
                return ImagesConstants.StoneImage.normal
                
            case PrecipitationConstants.clouds == condition:
                return ImagesConstants.StoneImage.normal
                
            default:
                return ImagesConstants.StoneImage.normal
            }
        }
    }
    
    private func convertToGeo(coordinates: (Double, Double)) -> (String, String) {
        var latitude = ""
        var longtitude = ""
        var doubleCoordinate = 0.0
        for _ in 0...1 {
            if latitude.isEmpty {
                doubleCoordinate = coordinates.0
            } else {
                doubleCoordinate = coordinates.1
            }
            let degrees = abs(Int(doubleCoordinate))
            let seconds = 3600 * (abs(doubleCoordinate) - abs(Double(degrees)))
            let minutes = Int(seconds / 60)
            let reminderInSeconds = Int(((seconds / 60) - Double(minutes)) * 60)
            let geoCoordinate = "\(degrees)°\(minutes)'\(reminderInSeconds)\""
            
            if latitude.isEmpty && coordinates.0 >= 0 {
                latitude = geoCoordinate + "N"
            } else if latitude.isEmpty && coordinates.0 < 0 {
                latitude = geoCoordinate + "S"
            } else if longtitude.isEmpty && coordinates.1 >= 0 {
                longtitude = geoCoordinate + "E"
            } else if longtitude.isEmpty && coordinates.1 < 0 {
                longtitude = geoCoordinate + "W"
            }
        }
        return (latitude, longtitude)
    }
}
