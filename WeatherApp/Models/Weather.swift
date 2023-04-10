//
//  Weather.swift
//  WeatherApp
//
//  Created by Panchami Shenoy on 02/02/22.
//

import Foundation

struct WeatherResults: Codable {
    let coord: CoordDetails
    let weather: [WeatherDetails]
    let main: MainDetails
    let visibility: Int
    let wind: WindDetails
    let clouds: CloudDetails
    let name: String
    let timezone: Int
}

struct CoordDetails: Codable {
    let lon: Float
    let lat: Float
}

struct WeatherDetails: Codable {
    let main: String
}
struct MainDetails: Codable {
    let temp: Float
    let feelsLike: Float
    let pressure: Int
    let humidity: Int
}

struct WindDetails: Codable {
    let speed: Float
}

struct CloudDetails: Codable {
    let all: Int
}
