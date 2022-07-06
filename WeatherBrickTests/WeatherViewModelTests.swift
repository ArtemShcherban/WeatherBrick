//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import XCTest
@testable import WeatherBrick

final class WeatherViewModelTests: XCTestCase {
    private var sut: WeatherViewModel?
    
    override func setUp() {
        super.setUp()
        sut = WeatherViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testCreatingCoutriesDictionaryDuringInit() {
        let ukraine = Country(
            codeISO: "UA",
            name: "Ukraine",
            flag: "🇺🇦",
            unicode: "U+1F1FA U+1F1E6")
        
        guard let sut = sut else { return }

        XCTAssertEqual(sut.countriesWithFlags["UA"], ukraine)
    }
}
