//
//  NetworkService.swift
//  weatherApp
//
//  Created by Naren kumar Konchada on 3/1/23.
//

import Foundation
import CoreLocation

final class NetworkService: NSObject {

  static let shared = NetworkService()
  private override init() {}

  private typealias Network = Constants.Network

  var completionHandler: ((Result<WeatherInfo,WeatherInfoError>) -> Void)?

  enum Endpoint {
    case city(path: String = Network.defaultPath,
              city: String)
    case coordinates(path: String = Network.defaultPath,
                     lat: Double,
                     lon: Double)

    var url: URL? {
      var components = URLComponents()
      components.scheme = Network.https
      components.host = Network.baseUrl
      components.path = path
      components.queryItems = queryItems

      return components.url
    }

    private var path: String {
      switch self {
      case .city(path: let path, _):
        return path
      case .coordinates(path: let path, _, _):
        return path
      }
    }

    private var queryItems: [URLQueryItem] {
      var queryItems = [URLQueryItem]()
      switch self {
      case .city(_, let city):
        queryItems.append(URLQueryItem(name: Network.q, value: city))
      case .coordinates(_, let lat, let lon):
        queryItems.append(contentsOf: [URLQueryItem(name: Network.latitude, value: String(lat)),
                                       URLQueryItem(name: Network.longitude, value: String(lon))])
      }
      queryItems.append(URLQueryItem(name: Network.appId, value: Network.apiKey))
      // Defaulting the temperature to Fahrenheit becuase of time constraints
      queryItems.append(URLQueryItem(name: Network.units, value: TemperatureUnitType.fahrenheit.rawValue))
      return queryItems
    }
  }
}

//MARK: - API Calls

extension NetworkService {

  /// API for getting weather information by latitude and longitude coordinates of a place
  /// - Parameters:
  ///   - coordinates: latitude and longitude coordinates of a place for which we need weather information
  ///   - completionHandler: closure for getting weatherInfo or error back to the caller
  func getWeatherInfoForCurrentLocation(coordinates: CLLocationCoordinate2D, _ completionHandler: @escaping (Result<WeatherInfo, WeatherInfoError>)->Void) {
    self.completionHandler = completionHandler
    guard let url = Endpoint.coordinates(lat: coordinates.latitude, lon: coordinates.longitude).url else { return }

    let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      self?.handleDataTaskResponse(data: data, response: response, error: error)
    }
    task.resume()
  }

  /// API for getting weather information by city name
  /// - Parameters:
  ///   - city: name of the city for which we need weather information
  ///   - completionHandler: closure for getting weatherInfo or error back to the caller
  func getWeatherInfo(for city: String,
                      _ completionHandler: @escaping (Result<WeatherInfo, WeatherInfoError>) -> Void) {
    self.completionHandler = completionHandler
    guard let url = Endpoint.city(city: city).url else { return }
    let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      self?.handleDataTaskResponse(data: data, response: response, error: error)
    }
    task.resume()
  }

  /// API for getting weather icon for a particular place
  /// - Parameters:
  ///   - iconName: name of the icon we get from weather info response
  ///   - completionHandler: closure for getting image data required to render the weather icon to the user
  func getWeatherIcon(with iconName: String?,
                      _ completionHandler: @escaping (Data?) -> Void) {
    guard let iconName = iconName,
          let url = URL(string: Network.weatherIconUrlString + iconName + Network.weatherIconSuffixPath) else { return }
    let task = URLSession.shared.dataTask(with: url) { data, response, error in

      guard let data = data else {
        completionHandler(nil)
        return
      }
      completionHandler(data)
    }
    task.resume()
  }

  /// Private method to handle the data task reponse
  /// - Parameters:
  ///   - data: data received from the data task response
  ///   - response: response of the data task
  ///   - error: error from the data task
  private func handleDataTaskResponse(data: Data?, response: URLResponse?, error: Error?) {
    guard error == nil else{
      completionHandler?(.failure(.unknownError))
      return
    }

    guard let _ = response else {
      completionHandler?(.failure(.invalidResponseError))
      return
    }

    guard let data = data else {
      completionHandler?(.failure(.invalidDataError))
      return
    }

    guard let weatherInfo = try? JSONDecoder().decode(WeatherInfo.self, from: data) else {
      completionHandler?(.failure(.decodingError))
      return
    }
    completionHandler?(.success(weatherInfo))
  }
}


