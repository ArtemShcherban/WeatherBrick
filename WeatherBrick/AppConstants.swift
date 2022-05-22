//
//  AppConstants.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 20.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import UIKit

enum AppConstants {
    enum Image {
        static let background = "image_background"
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
}
