//
//  SearchLocationModelTests.swift
//  WeatherBrickTests
//
//  Created by Artem Shcherban on 04.07.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import XCTest
@testable import WeatherBrick
import CoreLocation

class SearchLocationModelTests: XCTestCase {
    private var sut: SearchLocationModel!
    
    override func setUp() {
        super.setUp()
        sut = SearchLocationModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testStringHasValidCoordinates() {
        XCTAssertTrue(sut.hasValidCoordinates("55.345, 25.766"))
        XCTAssertTrue(sut.hasValidCoordinates("55.345,25.766"))
        XCTAssertTrue(sut.hasValidCoordinates("55.345,  25.766"))
        XCTAssertTrue(sut.hasValidCoordinates("55.,  25.766"))
        XCTAssertTrue(sut.hasValidCoordinates("55.345    ,  25.     "))
    }
    
    func testStringHasInvalidCoordinates() {
        XCTAssertFalse(sut.hasValidCoordinates("55,345, 25.766"))
        XCTAssertFalse(sut.hasValidCoordinates("55.345, 25,766"))
        XCTAssertFalse(sut.hasValidCoordinates("N55.345, E25.766"))
        XCTAssertFalse(sut.hasValidCoordinates("555.345, 25.766"))
        XCTAssertFalse(sut.hasValidCoordinates("55.,  25."))
    }
    
    func testCreatingCLLocationInstance() {
        var coordinates: [String] = []
        coordinates.append("55.345, 25.766")
        coordinates.append("55.345,25.766")
        coordinates.append("55.345,  25.766")
        coordinates.append("55. 345   ,  25.766")
        coordinates.append("55.345    ,  25.     766")
        runTest(coordinates)
    }
    
    func runTest(_ coordinates: [String], file: StaticString = #file, line: UInt = #line) {
        let expectedLat = 55.345
        let expectedLong = 25.766
        
        for coordinate in coordinates {
            XCTAssertEqual(sut.location(from: coordinate)?.coordinate.latitude, expectedLat, file: file, line: line)
            XCTAssertEqual(sut.location(from: coordinate)?.coordinate.longitude, expectedLong, file: file, line: line)
        }
    }
}
