//
//  WeatherBrickSlowTests.swift
//  WeatherBrickTests
//
//  Created by Vladyslav Petrenko on 13/04/2023.
//  Copyright © 2023 VAndrJ. All rights reserved.
//

import XCTest
@testable import WeatherBrick

final class WeatherBrickApiCallTests: XCTestCase {
    var urlSession: URLSession!
    
    override func setUp() {
        super.setUp()
        urlSession = URLSession(configuration: .default)
    }

    override func tearDown() {
        urlSession = nil
        super.tearDown()
    }
    
    func testValidApiCallGetsDataAndHTTPStatusCode200() {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=50&lon=0&appid=\(apiKey)&units=metric"
        let url = URL(string: urlString)!
        let expectation = expectation(description: "Status code: 200")
        
        let dataTask = urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 && data != nil {
                    expectation.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [expectation], timeout: 5)
    }
}
