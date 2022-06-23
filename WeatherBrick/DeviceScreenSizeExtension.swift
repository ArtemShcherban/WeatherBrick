//
//  Device.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 14.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit
import DeviceKit

extension Device {
    static public func screenSize() -> Size {
        switch self.current {
        case
        .iPhone8,
        .simulator(.iPhone8):
            return .screen4x7Inch
        case
        .iPhone8Plus,
        .iPhone12Mini,
        .iPhone13Mini,
        .simulator(.iPhone8Plus),
        .simulator(.iPhone12Mini),
        .simulator(.iPhone13Mini):
            return .screen5x5Inch
        case
        .iPhone11,
        .simulator(.iPhone11) :
            return .screen6x1Inch
        case
        .iPhone11Pro,
        .simulator(.iPhone11Pro):
            return .screen5x8Inch
        case
        .iPhone11ProMax,
        .simulator(.iPhone11ProMax):
            return .screen6x5Inch
        case
        .iPhone12,
        .iPhone13,
        .iPhone12Pro,
        .iPhone13Pro,
        .simulator(.iPhone12),
        .simulator(.iPhone13),
        .simulator(.iPhone12Pro),
        .simulator(.iPhone13Pro):
            return .screen6x06Inch
        case
        .iPhone12ProMax,
        .iPhone13ProMax,
        .simulator(.iPhone12ProMax),
        .simulator(.iPhone13ProMax):
            return .screen6x7Inch
        default:
            return .unknownSize
        }
    }
}
