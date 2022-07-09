//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import XCTest
@testable import WeatherBrick

final class WeatherViewModelTests: XCTestCase {
    private var sut: WeatherViewModel!
    private var weatherNetworkService: MockNetworkService!
    private var expectation: XCTestExpectation!
    private var coordinates = (0.0, 0.0)
    private var expectedResult = ("", "")
    
    override class var defaultTestSuite: XCTestSuite {
        let testSuite = XCTestSuite(name: NSStringFromClass(self))
        addNewTest(coordinates: (55.345, 15.280), expectedResult: ("55°20'41\"N", "15°16'47\"E"), testSuite: testSuite)
        addNewTest(coordinates: (-55.345, 15.280), expectedResult: ("55°20'41\"S", "15°16'47\"E"), testSuite: testSuite)
        addNewTest(coordinates: (-55.345, -15.28), expectedResult: ("55°20'41\"S", "15°16'47\"W"), testSuite: testSuite)
        addNewTest(coordinates: (55.345, -15.280), expectedResult: ("55°20'41\"N", "15°16'47\"W"), testSuite: testSuite)
        return testSuite
    }
    
    override func setUp() {
        super.setUp()
        weatherNetworkService = MockNetworkService()
        sut = WeatherViewModel(weatherNetworkService: weatherNetworkService)
    }
    
    override func tearDown() {
        sut = nil
        weatherNetworkService = nil
        super.tearDown()
    }
    
    func testCreatingCoutriesDictionaryDuringInit() {
        let ukraine = Country(
            codeISO: "UA",
            name: "Ukraine",
            flag: "🇺🇦",
            unicode: "U+1F1FA U+1F1E6")
        
        XCTAssertEqual(sut.countriesWithFlags["UA"], ukraine)
    }
    
    func test_creatingWeatherInfo() throws {
        let expectedLat = 52.3712
        let expectedLon = 4.8982
        let expectedMainCond = "Clouds"
        let expectedDetailsCond = "Scattered clouds"
        let expectedTemperature = "16°"
        let expectedCountry = "4°53'53\"E"
        let expectedCity = "52°22'16\"N"
        let expectedWind = "10"
        
        guard let weatherInfo = getWeatherInfo() else {
            throw XCTSkip("Cannot create URL")
        }
        
        XCTAssertEqual(weatherInfo.latitude, expectedLat)
        XCTAssertEqual(weatherInfo.longitude, expectedLon)
        XCTAssertEqual(weatherInfo.conditionMain, expectedMainCond)
        XCTAssertEqual(weatherInfo.conditionDetails, expectedDetailsCond)
        XCTAssertEqual(weatherInfo.temperature, expectedTemperature)
        XCTAssertEqual(weatherInfo.country, expectedCountry)
        XCTAssertEqual(weatherInfo.city, expectedCity)
        XCTAssertEqual(weatherInfo.wind, expectedWind)
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_convertToGeoCoordinates() {
        XCTAssertEqual(sut.convertToGeo(coordinates: coordinates).0, expectedResult.0)
        XCTAssertEqual(sut.convertToGeo(coordinates: coordinates).1, expectedResult.1)
    }
    
    class func addNewTest(coordinates: (Double, Double), expectedResult: (String, String), testSuite: XCTestSuite) {
        for invocation in WeatherViewModelTests.testInvocations {
            let newTestCase = WeatherViewModelTests(invocation: invocation)
            newTestCase.coordinates = coordinates
            newTestCase.expectedResult = expectedResult
            testSuite.addTest(newTestCase)
        }
    }
    
    func getWeatherInfo() -> WeatherInfo? {
        var weatherInfo: WeatherInfo?
        guard let url = UnitTestsConstants.cityURL else { return nil }
        expectation = expectation(description: "Weather reicived")
        
        sut.createWeatherInfo(with: url) { result in
            switch result {
            case .success(let mockWeather):
                weatherInfo = mockWeather
                self.expectation.fulfill()
            default:
                weatherInfo = nil
            }
        }
        return weatherInfo
    }
}
