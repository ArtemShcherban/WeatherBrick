//
//  NetworkServiceErrors.swift
//  WeatherBrick
//
//  Created by Artem Shcherban on 30.05.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

enum NetworkServiceError: String, Error, Equatable {
    case cannotCreateURL = "We cannot create URL"
    case errorCallingGET = "Network access error, please check your wi-fi connection or network coverage and try again"
    case didNotRecieveData = "Error: did not receive data"
    case httpRequestFailed =
        "Error: We could not find your location, check your spelling or coordinates, please try again."
    case badNetworkQuality =
        "Unfortunately, the time for the request has expired. There is a problem with the quality of the network."
    case couldNotConnect = "Unfortunately, we could not connect to the server."
    case sslConectError = "An SSL error has occurred and a secure connection to the server cannot be made."
    
    static func == (lhs: NetworkServiceError, rhs: NetworkServiceError) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
