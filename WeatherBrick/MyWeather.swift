//
//  MyWeather.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 23.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import UIKit

struct MyWeather {
    var city: String
    var country: String
    var flag: String
    var temperature: String
    var conditionDetails: String
    var conditionMain: String
    var stoneImage: String
      
    init(
        city: String = "",
        country: String = "",
        flag: String = "",
        temperature: String = "N/A",
        conditionDetails: String = "",
        conditionMain: String = "",
        stoneImage: String = ""
    ) { self.city = city
        self.country = country
        self.flag = flag
        self.temperature = temperature
        self.conditionDetails = conditionDetails
        self.conditionMain = conditionMain
        self.stoneImage = stoneImage
    }
}
