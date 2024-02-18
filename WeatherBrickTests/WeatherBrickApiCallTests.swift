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
    let apiURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=50.0&lon=0.0&appid=\(apiKey)&units=metric")!
    var networkManager: NetworkWeatherManager!
    var urlSession: URLSession!
    var expectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        
        urlSession = URLSession.init(configuration: configuration)
        networkManager = NetworkWeatherManager()
        expectation = expectation(description: "Expectation")
    }
    
    override func tearDown() {
        urlSession = nil
        expectation = nil
        networkManager = nil
        super.tearDown()
    }
    
    func testWeatherAPISuccessfulResponse() {
        let dataUrl = Bundle.main.url(forResource: "stubbedWeatherJSONData", withExtension: "json")!
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == self.apiURL else {
                XCTFail("Request error")
                throw WeatherAPIResponseError.request
            }
            let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = try! Data(contentsOf: dataUrl)
            return (response, data)
        }
        
        networkManager.onCompletion = { weatherData in
            XCTAssertEqual(weatherData.city, "Étretat")
            XCTAssertEqual(weatherData.temperatureString, "9")
            XCTAssertEqual(weatherData.country, "FR")
            XCTAssertEqual(weatherData.weatherConditionString, "Clouds")
            XCTAssertEqual(weatherData.brickImage, UIImage(named: "image_stone_normal"))
            XCTAssertEqual(weatherData.conditionCode, 801)
            self.expectation.fulfill()
        }
        
        networkManager.fetchWeatherData(withCoordinateLatitude: 50, longitude: 0, urlSession: urlSession)
        wait(for: [expectation], timeout: 2)
    }
    
    func testWeatherAPIDataParsingFailure() {
        let data = Data()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        networkManager.dataFetchingFailed = { error in
            guard let error = error as? WeatherAPIResponseError else {
                XCTFail("Incorrect error received")
                self.expectation.fulfill()
                return
            }
            XCTAssertEqual(error, WeatherAPIResponseError.parsing)
            self.expectation.fulfill()
        }
        
        networkManager.fetchWeatherData(withCoordinateLatitude: 50, longitude: 0, urlSession: urlSession)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
