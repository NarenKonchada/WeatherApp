//
//  Weather.swift
//  weatherApp
//
//  Created by Naren kumar Konchada on 3/4/23.
//

import Foundation

struct Weather {
  let id: Int
  let weatherDescription: String
  let weatherDetailDescription: String
  let iconName: String
}

extension Weather: Codable {
  private enum CodingKeys: String, CodingKey {
    case id
    case weatherDescription = "main"
    case weatherDetailDescription = "description"
    case iconName = "icon"
  }
}
