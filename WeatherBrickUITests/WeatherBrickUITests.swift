//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import XCTest

final class WeatherBrickUITests: XCTestCase {
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
    
    func testViewControllerElementsAfterLocationRequest() {
        let expectation = expectation(description: "Interface updated with api data")
        let result = XCTWaiter.wait(for: [expectation], timeout: 1)
        
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(app.images["searchIcon"].exists)
            XCTAssertTrue(app.staticTexts["cityLabel"].exists)
            XCTAssertTrue(app.staticTexts["countryLabel"].exists)
            XCTAssertTrue(app.images["brickImage"].exists)
            XCTAssertTrue(app.staticTexts["weatherConditionLabel"].exists)
            XCTAssertTrue(app.staticTexts["temperatureLabel"].exists)
            XCTAssertTrue(app.staticTexts["celsiusLabel"].exists)
            XCTAssertTrue(app.images["backgroundGradientImage"].exists)
            XCTAssertTrue(app.buttons["infoButton"].exists)
            
            XCTAssertFalse(app.images["locationIcon"].exists)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testInfoView() {
        func initialState() {
            XCTAssertFalse(app.buttons["hideButton"].exists)
            XCTAssertFalse(app.staticTexts["infoBottomLabel"].exists)
            XCTAssertFalse(app.staticTexts["infoTopLabel"].exists)
        }
        
        initialState()
        
        app.buttons["infoButton"].tap()
        
        XCTAssertTrue(app.buttons["hideButton"].exists)
        XCTAssertTrue(app.staticTexts["infoBottomLabel"].exists)
        XCTAssertTrue(app.staticTexts["infoTopLabel"].exists)
        
        app.buttons["hideButton"].tap()
        initialState()
    }
}
