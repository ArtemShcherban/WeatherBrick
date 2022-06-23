//
//  NetworkServiceModel.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 11.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import CoreLocation

final class URLModel {
    static let shared = URLModel()
    
    private lazy var components: URLComponents = {
        var tempComponents = URLComponents()
        tempComponents.scheme = URLConstants.scheme
        tempComponents.host = URLConstants.baseURL
        tempComponents.path = URLConstants.path
        return tempComponents
    }()
    let queryItemAppId = URLQueryItem(name: URLConstants.appId, value: URLConstants.apiKey)
    let queryItemUnits = URLQueryItem(name: URLConstants.units, value: URLConstants.metric)
    
    func prepareLinkFor<T: Locatable>(location: T) -> Result<URL, NetworkServiceError> {
        if let location = location as? String {
            let queryItemQuery = URLQueryItem(name: URLConstants.query, value: location)
            components.queryItems = [queryItemQuery, queryItemAppId, queryItemUnits]
        }
        if let location = location as? CLLocation {
            let queryItemLat = URLQueryItem(
                name: URLConstants.latitude,
                value: location.coordinate.latitude.description)
            let queryItemLon = URLQueryItem(
                name: URLConstants.longitude,
                value: location.coordinate.longitude.description)
            components.queryItems = [queryItemLat, queryItemLon, queryItemAppId, queryItemUnits]
        }
        if let url = components.url {
            return .success(url)
        } else {
            return .failure(NetworkServiceError.cannotCreateURL)
        }
    }
}
