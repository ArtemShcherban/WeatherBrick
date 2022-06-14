//
//  UserDefaultManager.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 10.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import CoreLocation

final class UserDefaultsManager: UserDefaults {
    static let manager = UserDefaultsManager()
    
    func save(_ myWeather: MyWeather) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(myWeather)
            set(data, forKey: AppConstants.myWeather)
        } catch {
            print("\(AppConstants.UserDefaultsError.unableToEncode) \(error)")
        }
    }
    
    func getLocation() -> CLLocation? {
        if let data = object(forKey: AppConstants.myWeather) as? Data,
        let myWeather = try? JSONDecoder().decode(MyWeather.self, from: data) {
            let location = CLLocation(latitude: myWeather.latitude, longitude: myWeather.longitude)
            return location
        }
        return nil
    }
    
    func getMyWeather() -> MyWeather? {
        if let data = object(forKey: AppConstants.myWeather) as? Data,
        let myWeather = try? JSONDecoder().decode(MyWeather.self, from: data) {
            return myWeather
        }
        return nil
    }
}
