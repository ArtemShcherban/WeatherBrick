//
//  ErrorResponseTests.swift
//  WeatherBrickTests
//
//  Created by Artem Shcherban on 14.07.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import XCTest
@testable import WeatherBrick

final class ErrorResponseTests: XCTestCase {
    private var sut: WeatherNetworkService!
    private var url: URL!
    private var mockURLSession: MockURLSession!
    private var error: NSError!
    private var expectedResult: NetworkServiceError!
    
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
    override class var defaultTestSuite: XCTestSuite {
        let testSuite = XCTestSuite(name: NSStringFromClass(self))
        addNewTest(
            error: NSError(domain: "", code: -1001),
            expectedResult: NetworkServiceError.badNetworkQuality,
            testSuite: testSuite)
        addNewTest(
            error: NSError(domain: "", code: -1004),
            expectedResult: NetworkServiceError.couldNotConnect,
            testSuite: testSuite)
        addNewTest(
            error: NSError(domain: "", code: -1200),
            expectedResult: NetworkServiceError.sslConectError,
            testSuite: testSuite)
        addNewTest(
            error: NSError(domain: "", code: 0),
            expectedResult: NetworkServiceError.errorCallingGET,
            testSuite: testSuite)
        return testSuite
    }
    
    class func addNewTest(error: NSError, expectedResult: NetworkServiceError, testSuite: XCTestSuite) {
        for invocation in ErrorResponseTests.testInvocations {
            let newTestCase = ErrorResponseTests(invocation: invocation)
            newTestCase.error = error
            newTestCase.expectedResult = expectedResult
            testSuite.addTest(newTestCase)
        }
    }
    
    func test_failureResponseWithErrors() throws {
        sut.urlSession = mockURLSession.withError(error: error)
        let expectation = XCTestExpectation(description: "Error received")
        
        sut.getWeather(with: url) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, self.expectedResult)
            default:
                XCTFail("We should received result with error")
            }
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 1)
    }
}
