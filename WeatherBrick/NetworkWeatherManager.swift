//
//  NetworkWeatherManager.swift
//  WeatherBrick
//
//  Created by Vladyslav Petrenko on 10/04/2023.
//  Copyright © 2023 VAndrJ. All rights reserved.
//

import Foundation

final class NetworkWeatherManager {
    
    var onCompletion: ((WeatherParsedData) -> Void)?
    
    func fetchWeatherData(withCoordinateLatitude latitude: Double, longitude: Double) {
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let weatherParsedData = self.parseJSON(withData: data)
            else { return }
            self.onCompletion?(weatherParsedData)
        }
        task.resume()
    }
    
    private func parseJSON(withData data: Data) -> WeatherParsedData? {
        let decoder = JSONDecoder()
        do {
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            guard let weatherParsedData = WeatherParsedData(weatherData: weatherData) else { return nil }
                    return weatherParsedData
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
