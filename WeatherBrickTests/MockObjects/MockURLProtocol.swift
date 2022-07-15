//
//  MockURLProtocol.swift
//  WeatherBrickTests
//
//  Created by Artem Shcherban on 08.07.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    static var mockURLs: [URL?: (data: Data?, response: HTTPURLResponse?, error: Error?)] = [:]
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let url = request.url {
            if let (data, response, error) = MockURLProtocol.mockURLs[url] {
                if let responseStrong = response {
                    self.client?.urlProtocol(self, didReceive: responseStrong, cacheStoragePolicy: .notAllowed)
                }
                if let dataStrong = data {
                    self.client?.urlProtocol(self, didLoad: dataStrong)
                }
                if let errorStrong = error {
                    self.client?.urlProtocol(self, didFailWithError: errorStrong)
                }
            }
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
    }
}
