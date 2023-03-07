//
//  TemperatureUnitType.swift
//  weatherApp
//
//  Created by Naren kumar Konchada on 3/3/23.
//

import Foundation

enum TemperatureUnitType: String {
  case celcius = "metric"
  case fahrenheit = "imperial"

  var temperatureUnitScale: String {
    switch self {
    case .celcius:
      return "°C"
    case .fahrenheit:
      return "°F"
    }
  }
}
