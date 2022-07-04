//
//  ImagesConstants.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 22.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

enum ImagesConstants {
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
    
    enum Icon {
        static let location = UIImage(named: "icon_location")
        static let search = UIImage(named: "icon_search")
    }
}
