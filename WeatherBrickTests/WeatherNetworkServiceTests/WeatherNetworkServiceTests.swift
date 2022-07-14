//
//  WeatherNetworkServiceTests.swift
//  WeatherBrickTests
//
//  Created by Artem Shcherban on 07.07.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import XCTest
@testable import WeatherBrick

final class WeatherNetworkServiceTests: XCTestCase {
    private var sut: WeatherNetworkService!
    private var url: URL!
    private var mockURLSession: MockURLSession!
    private let timeout = 1.0
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = WeatherNetworkService()
        mockURLSession = MockURLSession()
        guard let url = UnitTestsConstants.testURL else {
            throw XCTSkip("Cannot create URL")
        }
        self.url = url
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_successResponse() throws {
        sut.urlSession = mockURLSession.bytDefault()
        let expectation = XCTestExpectation(description: "Data received")
        
        sut.getWeather(with: url) { result in
            switch result {
            case .success(let weatherIn):
                XCTAssertEqual(weatherIn.cityName, "Tivat")
            default:
                XCTFail("Error: Data did not received")
            }
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_failureResponse() throws {
        sut.urlSession = try mockURLSession.withStatusCode(code: 404)
        let expectation = XCTestExpectation(description: "Response received")
        
        sut.getWeather(with: url) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, NetworkServiceError.httpRequestFailed)
            default:
                XCTFail("We should received result with error")
            }
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_failureResponseWithNoData() throws {
        sut.urlSession = mockURLSession.withNoData()
        let expectation = XCTestExpectation(description: "Response received")
        
        sut.getWeather(with: url) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, NetworkServiceError.didNotRecieveData)
            default:
                XCTFail("We should received result with error")
            }
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: timeout)
    }
}
