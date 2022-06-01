//
//  NetworkServiceErrors.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 30.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

enum NetworkServiceError: String, Error {
    case cannotCreateURL = "Error: Cannot create URL"
    case errorCallingGET = "Network access error, please check your wi-fi connection or network coverage and try again"
    case didNotRecieveData = "Error: did not recieve data"
    case httpRequestFailed =
        "Error: We could not find your location, check spelling, coordinates, etc. and please try again."
}
