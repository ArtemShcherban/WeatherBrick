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
            text.prefix(4).contains(".") &&
            text.contains(" ") &&
            text.last != " " {
            return true
        }
        return false
    }
    
    func location(from string: String) -> CLLocation? {
        let firstIndex = string.firstIndex(of: ",") ?? string.endIndex
        let secondIndex = string.firstIndex(of: " ") ?? string.endIndex
        let firstString = String(string[..<firstIndex])
        let secondString = String(string[string.index(after: secondIndex)...string.index(
            before: string.endIndex)])
        
        if let latitude = Double(firstString),
            let longitude = Double(secondString) {
            let location = CLLocation(latitude: latitude, longitude: longitude)
            return location
        }
        return nil
    }
}
