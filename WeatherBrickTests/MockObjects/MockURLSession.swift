//
//  MockURLSession.swift
//  WeatherBrickTests
//
//  Created by Artem Shcherban on 14.07.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
@testable import WeatherBrick

final class MockURLSession {
    private var error: NSError?
    private lazy var response: HTTPURLResponse? = {
        guard let url = UnitTestsConstants.testURL else { return nil }
        let tempResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        return tempResponse
    }()
    
    private lazy var data: Data? = {
        let dataURL = Bundle.main.url(forResource: "testData", withExtension: "txt")
        guard let dataURL = dataURL else { return nil }
        let data = try? Data(contentsOf: dataURL)
        return data
    }()
    
    private lazy var sessionConfig: URLSessionConfiguration = {
        let tempSessionConfig = URLSessionConfiguration.ephemeral
        tempSessionConfig.protocolClasses = [MockURLProtocol.self]
        return tempSessionConfig
    }()
    
    func bytDefault() -> URLSession {
        MockURLProtocol.mockURLs = [response?.url: (data, response, error)]
        let session = URLSession(configuration: sessionConfig)
        return session
    }
    
    func withStatusCode(code: Int) throws -> URLSession {
        guard let url = UnitTestsConstants.testURL else { throw NetworkServiceError.cannotCreateURL }
        let response = HTTPURLResponse(
            url: url,
            statusCode: code,
            httpVersion: nil,
            headerFields: nil)
        MockURLProtocol.mockURLs = [response?.url: (data, response, error)]
        let session = URLSession(configuration: sessionConfig)
        return session
    }
    
    func withNoData() -> URLSession {
        let data: Data? = nil
        MockURLProtocol.mockURLs = [response?.url: (data, response, error)]
        let session = URLSession(configuration: sessionConfig)
        return session
    }
    
    func withError(error: NSError) -> URLSession {
        MockURLProtocol.mockURLs = [response?.url: (data, response, error)]
        let session = URLSession(configuration: sessionConfig)
        return session
    }
}
