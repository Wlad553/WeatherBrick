//
//  NetworkWeatherManager.swift
//  WeatherBrick
//
//  Created by Vladyslav Petrenko on 10/04/2023.
//  Copyright © 2023 VAndrJ. All rights reserved.
//

import Foundation
import UIKit

enum WeatherAPIResponseError: Error {
    case network
    case parsing
    case request
}

final class NetworkWeatherManager {
    var onCompletion: ((WeatherParsedData) -> Void)?
    var dataFetchingFailed: ((Error) -> Void)?
    
    func fetchWeatherData(_ target: UIViewController, withCoordinateLatitude latitude: Double, longitude: Double, urlSession: URLSession = URLSession(configuration: .default)) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { return }
        urlSession.configuration.waitsForConnectivity = true
        urlSession.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            do {
                if let error = error {
                    throw error
                }
                guard let response = response else {
                    throw WeatherAPIResponseError.network
                }
                guard let data = data,
                      let weatherParsedData = try? self.parseJSON(withData: data)
                else {
                    throw WeatherAPIResponseError.parsing
                }
                self.onCompletion?(weatherParsedData)
            } catch {
                presentAlertController(toViewController: target)
                dataFetchingFailed?(error)
            }
        }.resume()
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
