//
//  WeatherData.swift
//  WeatherBrick
//
//  Created by Vladyslav Petrenko on 11/04/2023.
//  Copyright © 2023 VAndrJ. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    
    let main: Main
    let weather: [Weather]
    let sys: Sys
    let name: String
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
}

struct Sys: Codable {
    let country: String
}
