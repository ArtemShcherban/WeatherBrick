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
    
    static let weatherIn = "https://api.openweathermap.org/data/2.5/weather?q="
    static let weatherBy = "https://api.openweathermap.org/data/2.5/weather?lat="
    static let and = "&lon="
    static let apiKey = "&APPID=59a2b233df10c0b64ce48ebeb844ddf2"
    static let metricUnits = "&units=metric"
    
    static let alphabetletters = NSCharacterSet.letters
    
    static let myWeather = "myWeather"
    
    enum Precipitation {
        static let rain = ["Thunderstorm", "Drizzle", "Rain"]
        static let snow = "Snow"
        static let clouds = "Clouds"
        static let clearSky = "Clear"
        static let atmosphere = ["Mist", "Smoke", "Haze", "Dust", "Fog", "Sand", "Ash", "Squal", "Tornado"]
    }
    
    enum Indent {
        static let left: CGFloat = 16
        static let right: CGFloat = -16
    }
    
    enum Image {
        static let background = "image_background"
    }
    
    enum StoneImage {
        static let normal = "image_stone_normal"
        static let wet = "image_stone_wet"
        static let withSnow = "image_stone_snow"
        static let withCracks = "image_stone_cracks"
        static let noStone = "image_NO_stone"
    }
    
    enum TitleFor {
        static let popUpWindow = "INFO"
        static let hideButton = "Hide"
        static let locationButton = "Choose your location"
        static let backButtonTitle = "Back"
        static let searchBarPlaceHolder = "Search for a city or coordinates"
        static let userLocationButton = "Use your location"
    }
    
    enum Font {
        static let ubuntuRegular = "Ubuntu-Regular"
        static let ubuntuMedium = "Ubuntu-Medium"
        static let ubuntuLight = "Ubuntu-Light"
        static let ubuntuBold = "Ubuntu-Bold"
    }
    
    enum Color {
        static let graphite = UIColor(red: 0.175, green: 0.175, blue: 0.175, alpha: 1)
        static let lightGraphite = UIColor(red: 0.342, green: 0.342, blue: 0.342, alpha: 1)
        static let orange = UIColor(red: 1, green: 0.6, blue: 0.375, alpha: 1)
        static let darkOrange = UIColor(red: 0.984, green: 0.373, blue: 0.161, alpha: 1)
        static let brightOrange = UIColor(red: 0.977, green: 0.315, blue: 0.106, alpha: 1)
        static let skyBlue = UIColor(red: 0.635, green: 0.866, blue: 1, alpha: 1)
    }
    
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
