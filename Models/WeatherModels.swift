//
//  WeatherModels.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 14/07/26.
//

import Foundation

struct WeatherResponse: Codable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let current: CurrentWeather
    let hourly: HourlyData
}

struct CurrentWeather: Codable {
    let temperature: Double
    let weatherCode: Int
    let windSpeed: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temperature_2m"
        case weatherCode = "weather_code"
        case windSpeed = "wind_speed_10m"
        case humidity = "relative_humidity_2m"
    }
}

struct HourlyForecast: Codable, Identifiable, Equatable {
    let time: String
    let temperature: Double
    let weatherCode: Int
    let windSpeed: Double

    var id: String { time }

    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case weatherCode = "weather_code"
        case windSpeed = "wind_speed_10m"
    }
}

struct HourlyData: Codable {
    let time: [String]
    let temperature: [Double]
    let weatherCode: [Int]
    let windSpeed: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case weatherCode = "weather_code"
        case windSpeed = "wind_speed_10m"
    }
}
