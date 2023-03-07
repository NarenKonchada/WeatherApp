//
//  WeatherInfoViewModel.swift
//  weatherApp
//
//  Created by Naren kumar Konchada on 3/3/23.
//

import Foundation
import CoreLocation

final class WeatherInfoViewModel {
  private var weatherInfo: WeatherInfo?
  private var weatherInfoError: String?
  private var weatherIconInfoData: Data?

  var cityNameString: String {
    weatherInfo?.cityName ?? ""
  }

  // Defaulting the temperature to Fahrenheit becuase of time constraints

  var temperatureString: String {
    String(weatherInfo?.temp ?? 0.0) + TemperatureUnitType.fahrenheit.temperatureUnitScale
  }

  var minTemperatureString: String {
    return "L:" + String(weatherInfo?.main.tempMin ?? 0.0) + TemperatureUnitType.fahrenheit.temperatureUnitScale
  }

  var maxTemperatureString: String {
    return "H:" + String(weatherInfo?.main.tempMax ?? 0.0) + TemperatureUnitType.fahrenheit.temperatureUnitScale
  }

  var errorInfoString: String {
    weatherInfoError ?? ""
  }

  var weatherIconData: Data {
    weatherIconInfoData ?? Data()
  }


  func fetchWeatherInfo(for city: String, _ completionHandler: @escaping (Bool)->Void) {
    NetworkService.shared.getWeatherInfo(for: city) {[weak self] result in
      switch result {
      case .success(let weatherInfo):
        self?.weatherInfo = weatherInfo
        NetworkService.shared.getWeatherIcon(with: self?.weatherInfo?.iconName) { [weak self] data in
          self?.weatherIconInfoData = data
          completionHandler(true)
        }
      case .failure(let weatherInfoError):
        self?.weatherInfoError = weatherInfoError.rawValue
        completionHandler(false)
      }
    }
  }

  func getWeatherInfoForCurrentLocation(coordinates: CLLocationCoordinate2D, _ completionHandler: @escaping (Bool)->Void) {
    NetworkService.shared.getWeatherInfoForCurrentLocation(coordinates: coordinates) { [weak self] result in
      switch result {
      case .success(let weatherInfo):
        self?.weatherInfo = weatherInfo
        NetworkService.shared.getWeatherIcon(with: self?.weatherInfo?.iconName) { [weak self] data in
          self?.weatherIconInfoData = data
          completionHandler(true)
        }
      case .failure(let weatherInfoError):
        self?.weatherInfoError = weatherInfoError.rawValue
        completionHandler(false)
      }
    }
  }

  /// Used to check whether user has provided permission for location access
  /// - Returns: Bool value whether location permission is given or not
  func isLocationAccessEnabled() -> Bool {
    var result : Bool = false
    let locationManager = CLLocationManager()
    DispatchQueue.global().async {
      if CLLocationManager.locationServicesEnabled() {
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
          result = false
        case .authorizedAlways, .authorizedWhenInUse:
          result =  true
        @unknown default:
          fatalError()
        }
      } else {
        result = false
      }
    }
    return result
  }
}
