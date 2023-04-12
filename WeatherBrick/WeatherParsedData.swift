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
//    var weatherConditionString: String {
//        switch conditionCode {
//        case 200...232: return "Thunderstorm"
//        case 300...321: return "Drizzle"
//        case 500...531: return "Rainy"
//        case 600...622: return "Snowy"
//        case 701...781: return "Mist"
//        case 800: return "Sunny"
//        case 801...804: return "Cloudy"
//        default: return ""
//        }
//    }
//
    init?(weatherData: WeatherData) {
        city = weatherData.name
        country = weatherData.sys.country
        temperature = weatherData.main.temp
        conditionCode = weatherData.weather.first!.id
        weatherConditionString = weatherData.weather.first!.main
    }
}
