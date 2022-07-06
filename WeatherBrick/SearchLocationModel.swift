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
    
    func hasValidCoordinates(_ text: String) -> Bool {
        if (text.rangeOfCharacter(from: AppConstants.alphabetLetters) == nil) &&
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
