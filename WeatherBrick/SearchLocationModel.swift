//
//  SearchLocationModel.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 11.06.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import CoreLocation

final class SearchLocationModel {
    static let shared = SearchLocationModel()
    
    /// Check if the entered text can be the coordinates
    /// - Parameter text: String with entered text.
    /// - Returns: If the entered string can be the coordinates, returns true, otherwise returns false.
    ///
    /// - Notes:
    /// 1. If the entered string contains only valid characters,
    /// contains two dots and can be divided into three parts
    /// with these dots, also contains a comma which can be divided
    /// into two parts, the function will return true.
    /// 2. In other cases the return value will be false
    ///
    /// - Examples:
    /// ```
    /// // The return value is true
    /// "55.234, 12.456"
    /// "55.234, -12.456"
    /// "55.234,12.456"
    /// // The return value is false
    /// "55..234, 12.456"
    /// "N55.234, E12.456"
    /// "55234, 12456"
    /// ```
    func hasValidCoordinates(_ text: String) -> Bool {
        let allowedСharacters = CharacterSet(charactersIn: AppConstants.allowedСharacters)
        
        if allowedСharacters.isSuperset(of: CharacterSet(charactersIn: text)) &&
            text.prefix(3).contains(".") &&
            text.split(separator: ".").count == 3 &&
            text.split(separator: ",").count == 2 {
            return true
        }
        return false
    }
    
    func location(from string: String) -> CLLocation? {
        let updatedString = string.replacingOccurrences(of: " ", with: "")
        let firstIndex = updatedString.firstIndex(of: ",") ?? string.endIndex
        let firstString = String(updatedString[..<firstIndex])
        let secondString = String(updatedString[updatedString.index(after: firstIndex)...])
        if let latitude = Double(firstString), let longitude = Double(secondString) {
            let location = CLLocation(latitude: latitude, longitude: longitude)
            return location
        }
        return nil
    }
}
