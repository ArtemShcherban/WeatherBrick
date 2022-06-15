//
//  Size.swift
//  Device
//
//  Created by Lucas Ortis on 30/10/2015.
//  Copyright © 2015 Ekhoo. All rights reserved.
//

public enum Size: Int, Comparable {
    case unknownSize = 0
//    #if os(iOS)
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
//    #endif
}

public func < (lhs: Size, rhs: Size) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

public func == (lhs: Size, rhs: Size) -> Bool {
    return lhs.rawValue == rhs.rawValue
}
