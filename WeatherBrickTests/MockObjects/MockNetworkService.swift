//
//  MockNetworkService.swift
//  WeatherBrickTests
//
//  Created by Artem Shcherban on 07.07.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
@testable import WeatherBrick

class MockNetworkService: WeatherNetworking {
    var isWeatherRequestTriggered = false
    
    let mockWeather = WeatherParameters(
        coordinates: LocationCoordinate(longitude: 4.8982, latitude: 52.3712),
        conditionMain: "Clouds",
        conditionDetails: "Scattered clouds",
        temperature: 16.0,
        countryISO: "NL",
        cityName: "",
        windParameters: WindParameters(speed: 10, degrees: 240)
    )
    
    func getWeather(with link: URL, completion: @escaping (Result<WeatherParameters, NetworkServiceError>) -> Void) {
        isWeatherRequestTriggered = true
        completion(.success(mockWeather))
    }
}
