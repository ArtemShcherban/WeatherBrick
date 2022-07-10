//
//  WeatherMainViewControllerTests.swift
//  WeatherBrickTests
//
//  Created by Artem Shcherban on 10.07.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import WeatherBrick

class WeatherMainViewControllerTests: FBSnapshotTestCase {
    var sut: WeatherMainViewController!
    
    override func setUp() {
        super.setUp()
        sut = WeatherMainViewController()
        sut.weatherMainModel = WeatherViewModel(weatherNetworkService: MockNetworkService())
        sut.getDataFromNetwork()
        sut.loadView()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
//    func test_something() {
//        self.recordMode = true
//        print(sut.weatherMainView.temperatureLabel.text)
//        FBSnapshotVerifyViewController(sut)
//    }
}
