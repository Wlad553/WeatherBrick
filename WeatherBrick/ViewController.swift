//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    @IBOutlet weak var brickImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var infoView: InfoView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationIconImageView: UIImageView!
    @IBOutlet weak var searchIconImageView: UIImageView!
    
    var networkWeatherManager = NetworkWeatherManager()
    
    let gestureRecognizer = UIPanGestureRecognizer()
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInfoButtonDesign()
        setUpElementsInitialState()
        
        gestureRecognizer.addTarget(self, action: #selector(gestureAction(sender:)))
        gestureRecognizer.delegate = self
        scrollView.addGestureRecognizer(gestureRecognizer)
        
        infoButton.addTarget(self, action: #selector(showOrDismissInfoView), for: .touchUpInside)
        infoView.hideButton.addTarget(self, action: #selector(showOrDismissInfoView), for: .touchUpInside)
        
        networkWeatherManager.onCompletion = { [weak self] weather in
            guard let self = self else { return }
            updateInterface(with: weather)
        }
        
        networkWeatherManager.dataFetchingFailed = { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75 ) {
                UIView.animate(withDuration: 0.15, delay: 1) {
                    self.locationIconImageView.alpha = 0
                }
                self.setUpElementsInitialState()
            }
        }
        requestLocation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touchView = touches.first?.view else { return }
        
        if touchView != infoView.contentView && infoView.alpha == 1 {
            showOrDismissInfoView()
        }
    }
    
    @objc func showOrDismissInfoView() {
        if infoView.alpha == 0 {
            UIView.animate(withDuration: 0.15) {
                self.contentView.alpha = 0.5
                self.infoView.alpha = 1
                self.contentView.isUserInteractionEnabled = false
            }
        } else {
            UIView.animate(withDuration: 0.15) {
                self.infoView.alpha = 0
                self.contentView.alpha = 1
                self.contentView.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc func gestureAction(sender: UIGestureRecognizer) {
        if scrollView.contentOffset.y <= -130 && sender.state == .ended {
            requestLocation()
        }
    }
    
    func updateInterface(with weather: WeatherParsedData) {
        DispatchQueue.main.async {
            self.brickImageView.isHidden = false
            self.cityLabel.text = "\(weather.city),"
            self.temperatureLabel.text = weather.temperatureString
            self.countryLabel.text = NSLocalizedString(weather.country, comment: "country")
            self.weatherConditionLabel.text = weather.weatherConditionString
            self.brickImageView.image = weather.brickImage
            self.searchIconImageView.isHidden = false
            UIView.animate(withDuration: 0.15, delay: 1) {
                self.locationIconImageView.alpha = 0
            }
            
            if 701...762 ~= weather.conditionCode {
                self.brickImageView.alpha = 0.4
            } else {
                self.brickImageView.alpha = 1
            }
        }
    }
    
    func requestLocation() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.requestLocation()
                guard let lastLocation = self.locationManager.location else { return }
                self.locationManager(self.locationManager, didUpdateLocations: [lastLocation])
            }
        }
    }
    
    private func setUpElementsInitialState() {
        self.brickImageView.isHidden = true
        self.cityLabel.text = ""
        self.countryLabel.text = ""
        self.weatherConditionLabel.text = "-"
        self.temperatureLabel.text = "--"
        self.searchIconImageView.isHidden = true
    }
    
    private func setUpInfoButtonDesign() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = infoButton.bounds
        gradientLayer.colors = [
            UIColor(red: 255/255, green: 153/255, blue: 96/255, alpha: 1).cgColor,
            UIColor(red: 249/255, green: 80/255, blue: 27/255, alpha: 1).cgColor
        ]
        gradientLayer.shouldRasterize = true
        gradientLayer.cornerRadius = 10
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        infoButton.layer.addSublayer(gradientLayer)
        infoButton.layer.shadowOpacity = 0.5
        infoButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        if #available(iOS 15.0, *) {
            infoButton.configuration?.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 0,
                bottom: 20,
                trailing: 0)
        } else {
            infoButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        }
    }
}

// MARK: CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        networkWeatherManager.fetchWeatherData(self, withCoordinateLatitude: latitude, longitude: longitude)
        
        DispatchQueue.main.sync {
            UIView.animate(withDuration: 0.2) {
                self.locationIconImageView.alpha = 1
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alertController = UIAlertController(
            title:"Unable to locate you",
            message: "Please, try again later",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

// MARK: UIGestureRecognizerDelegate
extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
