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
    
    func textLooksLikeCoordinates(_ text: String) -> Bool {
        if (text.rangeOfCharacter(from: AppConstants.alphabetletters) == nil) &&
            text.prefix(4).contains(".") &&
            text.contains(" ") &&
            text.last != " " {
            return true
        }
        return false
    }
    
    func tryCreateLocationFrom(_ searchBarText: String) -> CLLocation? {
        let firstIndex = searchBarText.firstIndex(of: ",") ?? searchBarText.endIndex
        let secondIndex = searchBarText.firstIndex(of: " ") ?? searchBarText.endIndex
        let firstString = String(searchBarText[..<firstIndex])
        let secondString = String(searchBarText[searchBarText.index(after: secondIndex)...searchBarText.index(
            before: searchBarText.endIndex)])
        
        if let latitude = Double(firstString),
            let longitude = Double(secondString) {
            let location = CLLocation(latitude: latitude, longitude: longitude)
            return location
        }
        return nil
    }
}
