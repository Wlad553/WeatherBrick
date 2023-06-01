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
        let interfaceUpdateExpectation = expectation(description: "Interface updated with api data")
        let interfaceUpdateResult = XCTWaiter.wait(for: [interfaceUpdateExpectation], timeout: 1)
        
        guard interfaceUpdateResult == XCTWaiter.Result.timedOut
        else {
            XCTFail("Delay interrupted")
            return
        }
        guard let url = Bundle.main.url(forResource: "stubbedWeatherJSONData", withExtension: "json") else {
            XCTFail("No data in stubbedWeatherJSONData")
            return
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let parsedData = try? self.viewController.networkWeatherManager.parseJSON(withData: data) else {
                XCTFail("Failed to parse data")
                return
            }
            DispatchQueue.main.async {
                self.viewController.updateInterface(with: parsedData)
            }
        }.resume()
        
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
