//
//  WeatherInfoError.swift
//  weatherApp
//
//  Created by Naren kumar Konchada on 3/1/23.
//

import Foundation

enum WeatherInfoError: String, Error {
  case invalidResponseError = "Invalid response from Server. Please try again"
  case decodingError = "Invalid city entered. Please try again"
  case invalidDataError = "The data received from the Server was invalid. Please try again"
  case unknownError
}
