//
//  URLModelTests.swift
//  WeatherBrickTests
//
//  Created by Artem Shcherban on 04.07.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import XCTest
@testable import WeatherBrick
import CoreLocation

final class URLModelTests: XCTestCase {
    private var sut: URLModel!
    
    override func setUp() {
        super.setUp()
        sut = URLModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testCreatingURLFromString() {
        let cityName = "Lima"
        let expectedURL = UnitTestsConstants.stubbedCityURL
        
        guard let url = createUrlFor(location: cityName) else {
            XCTFail(NetworkServiceError.cannotCreateURL.localizedDescription)
            return
        }
        XCTAssertEqual(url, expectedURL)
    }
    
    func testCreatingURLFromCLLocation() {
        let coordinates = CLLocation(latitude: 51.487098, longitude: -0.123765)
        let expectedURL = UnitTestsConstants.stubbedCoordinatesURL
        
        guard let url = createUrlFor(location: coordinates) else {
            XCTFail(NetworkServiceError.cannotCreateURL.localizedDescription)
            return
        }
        XCTAssertEqual(url, expectedURL)
    }
    
    func createUrlFor<T: Locatable>(location: T) -> URL? {
        let result = sut.prepareLinkFor(location: location)
        switch result {
        case .success(let url):
            return url
        default:
            return nil
        }
    }
}
