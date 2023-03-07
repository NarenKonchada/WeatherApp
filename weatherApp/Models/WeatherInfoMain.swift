//
//  WeatherInfoMain.swift
//  weatherApp
//
//  Created by Naren kumar Konchada on 2/26/23.
//

import Foundation

struct WeatherInfoMain {
  let temp: Double
  let feelsLike: Double
  let tempMin: Double
  let tempMax: Double
  let pressure: Double
  let humidity: Double
}

extension WeatherInfoMain: Codable {
  private enum CodingKeys: String, CodingKey {
    case temp = "temp"
    case feelsLike = "feels_like"
    case tempMin = "temp_min"
    case tempMax = "temp_max"
    case pressure
    case humidity
  }
}
