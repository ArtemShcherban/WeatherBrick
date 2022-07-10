//
//  WeatherMainViewTests.swift
//  WeatherBrickTests
//
//  Created by Artem Shcherban on 09.07.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import XCTest
@testable import WeatherBrick

final class WeatherMainViewTests: XCTestCase {
    private var sut: WeatherMainView!
    private var controller: SearchLocationViewController!
    override func setUp() {
        super.setUp()
        sut = WeatherMainView()
        controller = SearchLocationViewController()
    }
    
    override func tearDown() {
        sut = nil
        controller = nil
        super.tearDown()
    }
    func testSearchController() {
        let searchLocationView = SearchLocationView()
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        searchBar.text = "50.555, 25.999$"
        controller.searchBarSearchButtonClicked(searchBar)
       
        XCTAssertEqual(
            searchLocationView.messageTextLabel.retrieveError,
            NetworkServiceError.httpRequestFailed.rawValue)
    }
    
//    func test_setIconForLocationButton() {
//        let controller = WeatherMainViewController(nibName: "WeatherMainViewController", bundle: nil)
//        controller.loadViewIfNeeded()
//        sut.setIcon(isGeo: true)
//        let someView = sut.geoLocationImageView.superview
//        XCTAssertEqual(someView, sut)
//    }
}
