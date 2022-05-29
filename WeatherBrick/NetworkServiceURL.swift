//
//  NetworkService.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 23.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

class NetworkServiceURL {
    static let shared = NetworkServiceURL()
    var coutriesDictionary: [String: String] = [:]
    
    func getDataFromOpenWeather(location: String, completion: @escaping(ResultOfRequest) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(location)&APPID=\(AppConstants.apiKey)&units=metric") else {
            print("Error: Cannot create URL")
            return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                return
            }
            guard let data = data else {
                print("Error: did not recieve data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            if let dataFromOpenWeather = try? JSONDecoder().decode(ResultOfRequest.self, from: data) {
                completion(dataFromOpenWeather)
            }
        }
        .resume()
    }
    
    func getDataMethod() {
//        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=ljubljana,slo&APPID=\(AppConstants.apiKey)&units=metric") else {
//            print("Error: Cannot create URL")
//            return
//        }
//        
//        let request = URLRequest(url: url)
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard  let data = data else {
//                print("Error: did not receive data")
//                return
//            }
//            
//            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
//                print("Error: HTTP request failed")
//                return
//            }
//            
//            guard error == nil else {
//                print("Error: error calling GET")
//                return
//            }
//            do {
//                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
//                    print("Error: cannot convert data from JSON object")
//                    return
//                }
//                
//                guard let prettyJsonData = try? JSONSerialization.data(
//                    withJSONObject: jsonObject,
//                    options: .prettyPrinted)
//                        
//                else { print("Error: Cannot convert JSON object to Pretty JSON data")
//                    return
//                }
//                
//                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8 ) else {
//                    print("Error: Could print JSON in String")
//                    return
//                }
//                
//                print(prettyPrintedJson)
//            } catch {
//                print("Error: Trying to convert JSON data to string")
//                return
//            }
//        }
//        .resume()
    }
    
    func getDataFromCoutriesJson(completion: @escaping(([Any]) -> Void) ) {
        guard let url = Bundle.main.url(forResource: "CountriesWithFlags", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(
            with: data,
            options: JSONSerialization.ReadingOptions.fragmentsAllowed) as? [Any] else { return }
        completion(json)
    }
    
    func getDataFromCitiesJson(completion: @escaping(([Any]) -> Void) ) {
        guard let url = Bundle.main.url(forResource: "CitiesWithPopulation", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any]
        else { return }
        completion(json)
    }
}
