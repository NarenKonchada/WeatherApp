//
//  Constants.swift
//  weatherApp
//
//  Created by Naren kumar Konchada on 3/3/23.
//

import Foundation

enum Constants {

  static let backgroundImage = "WeatherAppBackgroundImage"
  static let cityName = "City Name"
  static let error = "Error"
  static let ok = "OK"
  static let noCityMessage = "Please enter a city Name and try again"
  static let previousCityName = "prevCityName"

  enum Network {
    static let baseUrl = "api.openweathermap.org"
    static let apiKey = "bb63f0ffe6e645dbbcf08d423fc1313a"
    static let defaultPath = "/data/2.5/weather"
    static let weatherIconSuffixPath = "@2x.png"
    static let weatherIconUrlString = "https://openweathermap.org/img/wn/"

    static let https = "https"
    static let q = "q"
    static let units = "units"
    static let appId = "appid"
    static let latitude = "lat"
    static let longitude = "lon"
  }


}
