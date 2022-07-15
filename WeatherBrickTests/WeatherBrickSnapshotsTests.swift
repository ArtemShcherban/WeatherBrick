//
//  WeatherBrickSnapshotsTests.swift
//  WeatherBrickTests
//
//  Created by Artem Shcherban on 09.07.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import Foundation
import FBSnapshotTestCase
@testable import WeatherBrick

final class WeatherBrickSnapshotsTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        self.recordMode = false
        self.fileNameOptions = [.device, .OS, .screenSize]
    }
    
    func testMainScreen() {
        let controller = WeatherMainViewController(nibName: "WeatherMainViewController", bundle: nil)
        FBSnapshotVerifyViewController(controller)
    }
    
    func testPopUpWindow() {
        let controller = WeatherMainViewController(nibName: "WeatherMainViewController", bundle: nil)
        controller.popWindowPush()
        FBSnapshotVerifyViewController(controller)
    }
    
    func testSearchLocationScreen() {
        let controller = SearchLocationViewController(nibName: "SearchLocationViewController", bundle: nil)
        FBSnapshotVerifyViewController(controller)
    }
    
    func testUserLocationButton() {
        let view = SearchLocationView()
        FBSnapshotVerifyView(view.userLocationButton)
    }
    
    func testLocationButtonView() {
        let controller = WeatherMainViewController(nibName: "WeatherMainViewController", bundle: nil)
        FBSnapshotVerifyView(controller.weatherMainView.locationButton)
    }
}
