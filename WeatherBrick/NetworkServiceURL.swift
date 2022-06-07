//
//  NetworkService.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 23.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import UIKit

class NetworkServiceURL {
    static let shared = NetworkServiceURL()
   
    func getDataFromOpenWeather(with link: String, completion: @escaping(Result<ResultOfRequest, NetworkServiceError>) -> Void) {
        guard let url = URL(string: link) else {
            completion(.failure(NetworkServiceError.cannotCreateURL))
            return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(NetworkServiceError.errorCallingGET))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkServiceError.didNotRecieveData))
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                completion(.failure(NetworkServiceError.httpRequestFailed))
                return
            }
            
            if let dataFromOpenWeather = try? JSONDecoder().decode(ResultOfRequest.self, from: data) {
                completion(.success(dataFromOpenWeather))
            }
        }
        .resume()
    }
    
    func getDataFromCoutriesJson(completion: @escaping(([Any]) -> Void) ) {
        guard let url = Bundle.main.url(forResource: "CountriesWithFlags", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(
            with: data,
            options: JSONSerialization.ReadingOptions.fragmentsAllowed) as? [Any] else { return }
        completion(json)
    }
}
