//
//  NetworkService.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 23.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import UIKit

final class WeatherNetworkService {
    func getWeather(with link: URL, completion: @escaping(Result<WeatherParameters, NetworkServiceError>) -> Void) {   let request = URLRequest(url: link)
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForResource = 10.0
        let urlSession = URLSession(configuration: sessionConfig)
        
        urlSession.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                completion(.failure(NetworkServiceError.httpRequestFailed))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkServiceError.didNotRecieveData))
                return
            }
            if let dataFromOpenWeather = try? JSONDecoder().decode(WeatherParameters.self, from: data) {
                completion(.success(dataFromOpenWeather))
            }
            guard error == nil else {
                if let error = error {
                    completion(.failure( self.checkErrorCode(error: error)))
                }
                return
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
