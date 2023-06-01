//
//  Weather.swift
//  WeatherBrick
//
//  Created by Vladyslav Petrenko on 11/04/2023.
//  Copyright © 2023 VAndrJ. All rights reserved.
//

import Foundation
import UIKit

struct WeatherParsedData {
    let city: String
    let country: String
    
    let temperature: Double
    var temperatureString: String {
        String(format: "%.0f", temperature.rounded(.toNearestOrAwayFromZero))
    }
    
    let conditionCode: Int
    var brickImage: UIImage? {
        switch conditionCode {
        case 200...232, 300...321, 500...531: return UIImage(named: "image_stone_wet")
        case 600...622: return UIImage(named: "image_stone_snow")
            
        case 701...762 where temperature.rounded(.toNearestOrAwayFromZero) >= 30.0,
            800...804 where temperature.rounded(.toNearestOrAwayFromZero) >= 30.0:
            return UIImage(named: "image_stone_cracks")
            
        case 701...762, 800...804: return UIImage(named: "image_stone_normal")
        case 771...781: return UIImage(named: "image_stone_deflected")
        default: return nil
        }
    }
    let weatherConditionString: String
    
    init?(weatherData: WeatherData) {
        guard let weatherDataWeather = weatherData.weather.first else { return nil }
        city = weatherData.name
        country = weatherData.sys.country
        temperature = weatherData.main.temp
        conditionCode = weatherDataWeather.id
        weatherConditionString = weatherDataWeather.main
    }
}
