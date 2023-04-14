//
//  NetworkWeatherManager.swift
//  WeatherBrick
//
//  Created by Vladyslav Petrenko on 10/04/2023.
//  Copyright © 2023 VAndrJ. All rights reserved.
//

import Foundation
import UIKit

final class NetworkWeatherManager {
    var onCompletion: ((WeatherParsedData) -> Void)?
    var dataFetchingFailed: (() -> Void)?
    
    func fetchWeatherData(_ target: UIViewController, withCoordinateLatitude latitude: Double, longitude: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        session.configuration.waitsForConnectivity = true
        let task = session.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }
            guard let data = data,
                  let weatherParsedData = try? self.parseJSON(withData: data)
            else {
                presentAlertController(toViewController: target)
                self.dataFetchingFailed?()
                return
            }
            self.onCompletion?(weatherParsedData)
        }
        task.resume()
    }
    
    func parseJSON(withData data: Data) throws -> WeatherParsedData? {
        let decoder = JSONDecoder()
        let weatherData = try decoder.decode(WeatherData.self, from: data)
        
        guard let weatherParsedData = WeatherParsedData(weatherData: weatherData) else { return nil }
        return weatherParsedData
    }
    
    private func presentAlertController(toViewController target: UIViewController) {
        DispatchQueue.main.async {
        let alertController = UIAlertController(
            title:"Unable to get weather data",
            message: "Please, try again later",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
            action.accessibilityIdentifier = "alertOKAction"
        alertController.addAction(action)
            target.present(alertController, animated: true)
        }
    }
}
