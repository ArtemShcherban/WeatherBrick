//
//  NetworkServiceModel.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 11.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import CoreLocation

final class WeatherNetworkServiceModel {
    static let shared = WeatherNetworkServiceModel()
    
    private lazy var components: URLComponents = {
        var tempComponents = URLComponents()
        tempComponents.scheme = AppConstants.scheme
        tempComponents.host = AppConstants.baseURL
        tempComponents.path = AppConstants.path
        return tempComponents
    }()
    let queryItemAppId = URLQueryItem(name: AppConstants.appId, value: AppConstants.apiKey)
    let queryItemUnits = URLQueryItem(name: AppConstants.units, value: AppConstants.metric)
    
    func prepareLinkFor<T: Locatable>(location: T, completion: @escaping(Result<URL, NetworkServiceError>) -> Void) {
        if let location = location as? String {
            let queryItemQuery = URLQueryItem(name: AppConstants.query, value: location)
            components.queryItems = [queryItemQuery, queryItemAppId, queryItemUnits]
        }
        if let location = location as? CLLocation {
            let queryItemLat = URLQueryItem(
                name: AppConstants.latitude,
                value: location.coordinate.latitude.description)
            let queryItemLon = URLQueryItem(
                name: AppConstants.longitude,
                value: location.coordinate.longitude.description)
            components.queryItems = [queryItemLat, queryItemLon, queryItemAppId, queryItemUnits]
        }
        if let url = components.url {
            completion(.success(url))
        } else {
            completion(.failure(NetworkServiceError.cannotCreateURL))
        }
    }
}
