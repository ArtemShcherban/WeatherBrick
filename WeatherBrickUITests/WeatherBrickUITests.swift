//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import XCTest
@testable import WeatherBrick

final class WeatherBrickUITests: XCTestCase {
    private var app: XCUIApplication!
    private lazy var locationButton = app.buttons["locationButton"]
    private lazy var searchTextField = app.searchFields["searchTextField"]
    private lazy var backButton = app.buttons["backButton"]
    private lazy var messageTextLabel = app.staticTexts["messageTextLabel"]
    private lazy var userLocationButton = app.buttons["userLocationButton"]
    private lazy var popUpWindow = app.otherElements["popUpWindow"]
    private lazy var hideButton = app.buttons["hideButton"]
    private lazy var geoLocationImageView = app.images["geoLocationImageView"]
    private lazy var searchIconImageView = app.images["searchIconImageView"]
    private lazy var timeout = 1.0
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments.append("UITests")
        app.launch()
        
        continueAfterFailure = false
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_tapLocationButton_SearchLocationVCAppear() {
        locationButton.tap()
        
        XCTAssertTrue(messageTextLabel.exists)
        XCTAssertTrue(userLocationButton.isHittable)
    }
    
    func test_tapSearchButton_WeatherVCAppear() {
        locationButton.tap()
        searchTextField.tap()
        searchTextField.typeText("51.500188, -0.142378 \n")
        
        XCTAssertTrue(popUpWindow.waitForExistence(timeout: timeout))
        XCTAssertTrue(searchIconImageView.exists)
        XCTAssertTrue(locationButton.isHittable)
    }
    
    func test_tapPopUpWindow_WindowFullyAppears() {
        popUpWindow.tap()
        
        XCTAssertTrue(hideButton.isHittable)
    }
    
    func test_tapPopUpWindow_WindowPartiallyHidden() {
        popUpWindow.tap()
        sleep(1)
        hideButton.tap()
        
        XCTAssertFalse(hideButton.isHittable)
    }
    
    func test_pressedBackButton_WeatherVCAppear() {
        locationButton.tap()
        backButton.tap()
        
        XCTAssertTrue(popUpWindow.waitForExistence(timeout: timeout))
        XCTAssertTrue(locationButton.isHittable)
    }
    
    func test_tapUserLocationButton_WeatherVCAppear() {
        locationButton.tap()
        userLocationButton.tap()
        
        XCTAssertTrue(popUpWindow.waitForExistence(timeout: timeout))
        XCTAssertTrue(geoLocationImageView.exists)
        XCTAssertTrue(locationButton.isHittable)
    }
}
