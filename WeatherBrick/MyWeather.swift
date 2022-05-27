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
    var temperature: String
    var condition: String
    var mainCondition: String
    var stoneImage: String
      
    init(
        city: String = "",
        country: String = "",
        temperature: String = "N/A",
        condition: String = "",
        mainCondition: String = "",
        stoneImage: String = ""
    ) { self.city = city
        self.country = country
        self.temperature = temperature
        self.condition = condition
        self.mainCondition = mainCondition
        self.stoneImage = stoneImage
    }
}

struct City: Hashable {
    var name: String
    var id: Int
    var country: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.id == rhs.id
    }
}
