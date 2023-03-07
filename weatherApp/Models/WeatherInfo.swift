//
//  WeatherInfo.swift
//  weatherApp
//
//  Created by Naren kumar Konchada on 2/26/23.
//

import Foundation

struct WeatherInfo {
  let main: WeatherInfoMain
  let cityName: String
  let weather: [Weather]
}

extension WeatherInfo: Codable {
  private enum CodingKeys: String, CodingKey {
    case main
    case cityName = "name"
    case weather
  }
}

extension WeatherInfo {
  var temp: Double {
    main.temp
  }
}

extension WeatherInfo {
  var iconName: String {
    weather.first?.iconName ?? ""
  }
}


