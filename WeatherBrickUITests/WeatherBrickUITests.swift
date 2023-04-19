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
        XCUIApplication().launch()

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
}
