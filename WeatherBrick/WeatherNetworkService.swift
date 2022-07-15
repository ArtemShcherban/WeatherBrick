//
//  NetworkService.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 23.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import UIKit

protocol WeatherNetworking: AnyObject {
    func getWeather(with link: URL, completion: @escaping(Result<WeatherParameters, NetworkServiceError>) -> Void)
}

final class WeatherNetworkService: WeatherNetworking {
    lazy var urlSession: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForResource = 30.0
        let session = URLSession(configuration: sessionConfig)
        return session
    }()
    
    func getWeather(with link: URL, completion: @escaping(Result<WeatherParameters, NetworkServiceError>) -> Void) {
        urlSession.dataTask(with: link) { data, response, error in
            guard error == nil else {
                if let error = error {
                    completion(.failure( self.checkErrorCode(error: error)))
                }
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                completion(.failure(NetworkServiceError.httpRequestFailed))
                return
            }
            guard let data = data, !data.isEmpty else {
                completion(.failure(NetworkServiceError.didNotRecieveData))
                return
            }
            if let dataFromOpenWeather = try? JSONDecoder().decode(WeatherParameters.self, from: data) {
                completion(.success(dataFromOpenWeather))
            }
        }
        .resume()
    }
    
    private func checkErrorCode(error: Error) -> NetworkServiceError {
        switch error._code {
        case -1001:
            return NetworkServiceError.badNetworkQuality
        case -1004:
            return NetworkServiceError.couldNotConnect
        case -1200:
            return NetworkServiceError.sslConectError
        default:
            return NetworkServiceError.errorCallingGET
        }
    }
}
