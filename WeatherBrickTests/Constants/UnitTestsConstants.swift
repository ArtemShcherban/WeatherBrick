//
//  UnitTestsConstants.swift
//  WeatherBrickTests
//
//  Created by Artem Shcherban on 04.07.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

enum UnitTestsConstants {
    static let stubbedCityURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Lima&APPID=59a2b233df10c0b64ce48ebeb844ddf2&units=metric")
    
    static let stubbedCoordinatesURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=51.487098&lon=-0.123765&APPID=59a2b233df10c0b64ce48ebeb844ddf2&units=metric")
    
    static let nilURL: URL? = nil
    static let testURL = URL(string: "https://www.apple.com")
}
