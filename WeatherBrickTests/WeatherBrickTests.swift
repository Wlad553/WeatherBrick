//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import XCTest
@testable import WeatherBrick

final class WeatherBrickTests: XCTestCase {
    
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "main") as? ViewController
        viewController.loadView()
        viewController.viewDidLoad()
    }

    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func testFakeDataParsing() {
        let stubbedJSONData = #"{"coord":{"lon":0,"lat":50},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}],"base":"stations","main":{"temp":9.3,"feels_like":6.37,"temp_min":9.3,"temp_max":9.3,"pressure":1006,"humidity":76,"sea_level":1006,"grnd_level":1006},"visibility":10000,"wind":{"speed":5.95,"deg":250,"gust":8.4},"clouds":{"all":20},"dt":1681404964,"sys":{"country":"FR","sunrise":1681362712,"sunset":1681411736},"timezone":0,"id":3019355,"name":"Étretat","cod":200}"#.data(using: .utf8)
        
        guard let data = stubbedJSONData else {
            XCTFail("No data in stubbedJSONData")
            return
        }
        
        let parsedData = viewController.networkWeatherManager.parseJSON(withData: data)
        
        guard let parsedData = parsedData else {
            XCTFail("Failed to parse data")
            return
        }
        
        viewController.updateInterface(with: parsedData)
        
        let expectation = expectation(description: "UIElements texts and image update")
        let result = XCTWaiter.wait(for: [expectation], timeout: 1)
        
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewController.cityLabel.text, "Étretat,")
            XCTAssertEqual(viewController.countryLabel.text, "France")
            XCTAssertEqual(viewController.temperatureLabel.text, "9")
            XCTAssertEqual(viewController.weatherConditionLabel.text, "Clouds")
            XCTAssertEqual(viewController.brickImageView.image, UIImage(named: "image_stone_normal"))
        } else {
            XCTFail("Delay interrupted")
        }
    }
}
