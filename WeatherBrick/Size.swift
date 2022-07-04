//
//  Size.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 14.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

public enum Size: Int, Comparable {
    case unknownSize = 0
    
    /// iPhone 6, 6s, 7, 8
    case screen4x7Inch
    /// iPhone 6+, 6s+, 7+, 8+, 12 mini, 13mini
    case screen5x5Inch
    /// iPhone X, Xs, 11 Pro
    case screen5x8Inch
    /// iPhone 12, 12 Pro, 13, 13 Pro
    case screen6x06Inch
    /// iPhone Xr, 11
    case screen6x1Inch
    /// iPhone Xs Max, 11 Pro Max
    case screen6x5Inch
    /// iPhone 12 Pro Max, 13 Pro Max
    case screen6x7Inch
}

public func < (lhs: Size, rhs: Size) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

public func == (lhs: Size, rhs: Size) -> Bool {
    return lhs.rawValue == rhs.rawValue
}
