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
    
    func testSnapshotMainScreen() {
        let controller = WeatherMainViewController(nibName: "WeatherMainViewController", bundle: nil)
        FBSnapshotVerifyViewController(controller)
    }
    
    func testSnapshotPopUpWindow() {
        let controller = WeatherMainViewController(nibName: "WeatherMainViewController", bundle: nil)
        controller.loadViewIfNeeded()
        controller.popWindowPush()
        FBSnapshotVerifyViewController(controller)
    }
    
    func testSnapshotSearchLocationScreen() {
        let controller = SearchLocationViewController(nibName: "SearchLocationViewController", bundle: nil)
        FBSnapshotVerifyViewController(controller)
    }
    
    func testLocationButtonView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(
            withIdentifier: WeatherMainViewController.reuseIdentifier) as? WeatherMainViewController else { return }
        _ = controller.view
        FBSnapshotVerifyView(controller.weatherMainView.locationButton)
    }
}
