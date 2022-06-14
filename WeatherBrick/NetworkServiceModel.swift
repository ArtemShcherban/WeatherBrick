//
//  NetworkServiceModel.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 11.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import CoreLocation

final class NetworkServiceModel {
    static let shared = NetworkServiceModel()
    
    func prepareLinkFor<T>(location: T, completion: @escaping(String) -> Void) {
        if let location = location as? String {
            let link = "\(AppConstants.weatherIn)\(location)\(AppConstants.apiKey)\(AppConstants.metricUnits)"
            
            completion(link)
        }
        
        if let location = location as? CLLocation {
            let latitude = location.coordinate.latitude.description
            let longtitude = location.coordinate.longitude.description
            let coordinates = "\(latitude)\(AppConstants.and)\(longtitude)"
            let link = "\(AppConstants.weatherBy)\(coordinates)\(AppConstants.apiKey)\(AppConstants.metricUnits)"
            
            completion(link)
        }
    }
}
