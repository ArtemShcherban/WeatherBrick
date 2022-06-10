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

final class WeatherMainModel {
    static let shared = WeatherMainModel()
    private lazy var networkServiceManager = NetworkServiceManager.shared
    private lazy var countriesWithFlags: [String: Country] = [:]
    private lazy var geocoder = CLGeocoder()
    
    func prepareLinkFor<T>(location: T, completion: @escaping(String) -> Void) {
        if let location = location as? String {
            let link = "\(AppConstants.weatherIn)\(location)\(AppConstants.apiKey)\(AppConstants.metricUnits)"
            
            completion(link)
        }
        
        if let location = location as? CLLocation {
            let latitude = location.coordinate.latitude.description
            let longtitude = location.coordinate.longitude.description
            let link = "\(AppConstants.weatherBy)\(latitude)\(AppConstants.and)\(longtitude)\(AppConstants.apiKey)\(AppConstants.metricUnits)"
            
            completion(link)
        }
    }
        
    func createMyWeather(with link: String, completion: @escaping((Result<MyWeather, NetworkServiceError>) -> Void)) {
        networkServiceManager.getDataFromOpenWeather(with: link) { resultOrError in
            switch resultOrError {
            case .failure(let error):
                completion(.failure(error))
            case .success(let weather):
                var myWeather = MyWeather(
                    city: weather.cityName ?? "",
                    country: self.countriesWithFlags[weather.countryISO ?? ""]?.name ?? "",
                    flag: self.countriesWithFlags[weather.countryISO ?? ""]?.flag ?? "",
                    temperature: String(Int(weather.temperature ?? 0.0)) + "°",
                    conditionDetails: weather.conditionDetails ?? "",
                    conditionMain: weather.conditionMain ?? "",
                    wind: String(Int(weather.wind?.speed ?? 0.0)),
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
    
    func getCountries() {
        networkServiceManager.getDataFromCoutriesJson { jsonArray in
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
    
    func getStoneImage(dependingOn weather: ResultOfRequest) -> String {
        guard let condition = weather.conditionMain,
            let temperature = weather.temperature else {
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
    
    func convertToGeo(coordinates: (Double, Double)) -> (String, String) {
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
