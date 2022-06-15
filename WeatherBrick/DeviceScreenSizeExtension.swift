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
        let width = Double(UIScreen.main.bounds.width)
        let height = Double(UIScreen.main.bounds.height)
        let screenHeight: Double = max(width, height)
        
        switch screenHeight {
        case 667:
            return UIScreen.main.scale == 3.0 ? .screen5x5Inch : .screen4x7Inch
        case 736:
            return .screen5x5Inch
        case 812:
            switch Device.current {
            case .simulator(.iPhone11Pro):
                return .screen5x8Inch
            case .simulator(.iPhone12Mini), .simulator(.iPhone13Mini):
                return .screen5x5Inch
            default:
                return .unknownSize
            }
        case 844:
            return .screen6x06Inch
        case 896:
            return UIScreen.main.scale == 3 ? .screen6x5Inch : .screen6x1Inch
        case 926:
            return .screen6x7Inch
            
        default:
            return .unknownSize
        }
    }
}
