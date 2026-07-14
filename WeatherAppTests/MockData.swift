//
//  MockData.swift
//  WeatherAppTests
//
//  Created by Gabriel Amaral on 14/07/26.
//

import Foundation

struct MockData {
    
    static let validWeatherJSON = """
    {
        "latitude": -22.9,
        "longitude": -47.0,
        "timezone": "America/Sao_Paulo",
        "current": {
            "temperature_2m": 25.5,
            "weather_code": 0,
            "wind_speed_10m": 5.2,
            "relative_humidity_2m": 60
        }
    }
    """.data(using: .utf8)!
    
    static let invalidJSON = """
    {
        "invalid": "data"
    }
    """.data(using: .utf8)!
    
    static let emptyJSON = "{}".data(using: .utf8)!
}
