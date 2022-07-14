//
//  AppConstants.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 20.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import UIKit
import DeviceKit

enum AppConstants {
    static let bigScreenSize = Device.screenSize() > Size.screen5x8Inch
    static let allowedСharacters = "0123456789-., "
    static let myWeather = "myWeather"
    static let monitor = "Monitor"
    static let main = "Main"
         
    static let conditions = [
        "Brick is wet - raining",
        "Brick is dry - sunny",
        "Brick is hardto see - fog",
        "Brick is cracks - very hot",
        "Brick is snow - snow",
        "Brick is swinging - windy",
        "Brick is gone - No Internet"
    ]
    
    static let inputFormats = """
    Try use the following formats, for cities:
    New York
    New York, US
    10153, US
    for coordinates:
    40.7638157, -73.9729552
    """
}
