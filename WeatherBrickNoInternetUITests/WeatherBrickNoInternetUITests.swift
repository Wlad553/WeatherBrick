//
//  WeatherBrickNoInternetUITests.swift
//  WeatherBrickNoInternetUITests
//
//  Created by Vladyslav Petrenko on 14/04/2023.
//  Copyright © 2023 VAndrJ. All rights reserved.
//

import XCTest

final class WeatherBrickNoInternetUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
        app = nil
    }
    
    func testViewControllerInitialStateElements() {
        XCTAssertTrue(app.alerts.firstMatch.exists)
        app.alerts.buttons["alertOKAction"].tap()
        
        XCTAssertFalse(app.images["searchIcon"].exists)
        XCTAssertFalse(app.staticTexts["cityLabel"].exists)
        XCTAssertFalse(app.staticTexts["countryLabel"].exists)
        XCTAssertFalse(app.images["brickImage"].exists)
        
        XCTAssertTrue(app.staticTexts["weatherConditionLabel"].exists)
        XCTAssertTrue(app.staticTexts["temperatureLabel"].exists)
        XCTAssertTrue(app.staticTexts["celsiusLabel"].exists)
        XCTAssertTrue(app.images["backgroundGradientImage"].exists)
        XCTAssertTrue(app.buttons["infoButton"].exists)
        XCTAssertFalse(app.images["locationIcon"].exists)
        
        app.images["backgroundGradientImage"].swipeDown()
        
        XCTAssertTrue(app.alerts.firstMatch.exists)
        app.alerts.buttons["alertOKAction"].tap()                
    }
}
