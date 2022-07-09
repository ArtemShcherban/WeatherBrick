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
    var sut: WeatherNetworkService!
    var url: URL!
    var expectation: XCTestExpectation!
    var error: Error!
    var expectedResult: NetworkServiceError!
    let timeout = 0.1
    
    override class var defaultTestSuite: XCTestSuite {
        let testSuite = XCTestSuite(name: NSStringFromClass(self))
        addNewTests(
            error: NSError(domain: "", code: -1001),
            expectedResult: NetworkServiceError.badNetworkQuality,
            testSuite: testSuite)
        addNewTests(
            error: NSError(domain: "", code: -1004),
            expectedResult: NetworkServiceError.couldNotConnect,
            testSuite: testSuite)
        addNewTests(
            error: NSError(domain: "", code: -1200),
            expectedResult: NetworkServiceError.sslConectError,
            testSuite: testSuite)
        addNewTests(
            error: NSError(domain: "", code: 0),
            expectedResult: NetworkServiceError.errorCallingGET,
            testSuite: testSuite)
        return testSuite
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = WeatherNetworkService()
        guard let url = UnitTestsConstants.testURL else {
            throw XCTSkip("Cannot create URL")
        }
        self.url = url
        expectation = expectation(description: "Data received")
    }
    
    override func tearDown() {
        sut = nil
        error = nil
        expectedResult = nil
        super.tearDown()
    }
    
    func test_successResponse() throws {
        let testData = try getData()
        sut.urlSession = mockURLSession(data: testData, statusCode: 200, error: nil)
        
        sut.getWeather(with: url) { result in
            self.expectation.fulfill()
            switch result {
            case .success(let weatherIn):
                XCTAssertEqual(weatherIn.cityName, "Tivat")
            default:
                XCTFail("Error: Data did not received")
            }
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_failureResponse() throws {
        sut.urlSession = mockURLSession(data: nil, statusCode: 404, error: nil)
        
        sut.getWeather(with: url) { result in
            self.expectation.fulfill()
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, NetworkServiceError.httpRequestFailed)
            default:
                XCTFail("We should received result with error")
            }
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_failureResponseWithNoData() throws {
        sut.urlSession = mockURLSession(data: nil, statusCode: 200, error: nil)
        
        sut.getWeather(with: url) { result in
            self.expectation.fulfill()
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, NetworkServiceError.didNotRecieveData)
            default:
                XCTFail("We should received result with error")
            }
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_failureResponseWithErrors() throws {
        sut.urlSession = mockURLSession(data: nil, statusCode: 0, error: error)

        sut.getWeather(with: url) { result in
            self.expectation.fulfill()
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, self.expectedResult)
            default:
                XCTFail("We should received result with error")
            }
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    class func addNewTests(error: Error, expectedResult: NetworkServiceError, testSuite: XCTestSuite) {
        for invocation in WeatherNetworkServiceTests.testInvocations {
            let newTestCase = WeatherNetworkServiceTests(invocation: invocation)
            newTestCase.error = error
            newTestCase.expectedResult = expectedResult
            testSuite.addTest(newTestCase)
        }
    }
    
    func mockURLSession(data: Data? = nil, statusCode: Int = 0, error: Error? = nil) -> URLSession {
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockURLs = [url: (data, response, error)]
        
        let sessionConfig = URLSessionConfiguration.ephemeral
        sessionConfig.protocolClasses = [MockURLProtocol.self]
        let mockURLSession = URLSession(configuration: sessionConfig)
        return mockURLSession
    }
    
    func getData() throws -> Data {
        let dataURL = Bundle.main.url(forResource: "testData", withExtension: "txt")
        guard let dataURL = dataURL,
            let testData = try? Data(contentsOf: dataURL) else {
            throw XCTSkip("Cannot read or find data file")
        }
        return testData
    }
}
