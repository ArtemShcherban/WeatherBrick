//
//  SnapshotTestingTests.swift
//  WeatherBrickTests
//
//  Created by Artem Shcherban on 10.07.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import WeatherBrick

final class SnapshotTestingTests: XCTestCase {
    private var sut: WeatherMainViewController!
    private var image: Snapshotting<UIViewController, UIImage>!
    
    override func setUp() {
        super.setUp()
        isRecording = false
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
            withIdentifier: WeatherMainViewController.reuseIdentifier) as? WeatherMainViewController
        image = .image(size: .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testViewController() {
        assertSnapshot(matching: sut, as: image)
    }
    
    func testLocationButton() {
        assertSnapshot(matching: sut.weatherMainView.locationButton, as: .image )
    }
    
    func testPopUpWindowIn() {
        sut.weatherMainView.animatePopUpWindowIn()
        assertSnapshot(matching: sut, as: .image)
    }
    
    func testPopUpWindowOut() {
        sut.weatherMainView.animatePopUpWindowIn()
        sut.weatherMainView.animatePopUpWindowOut()
        assertSnapshot(matching: sut, as: image)
    }
    
    func testSearchLocationViewController() {
        let sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
            withIdentifier: SearchLocationViewController.reuseIdentifier)
        
        assertSnapshot(matching: sut, as: image)
    }
}
