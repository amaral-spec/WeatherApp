//
//  MockWeatherService.swift
//  WeatherAppTests
//
//  Created by Gabriel Amaral on 14/07/26.
//

import Foundation
@testable import WeatherApp

class MockWeatherService: WeatherServiceProtocol {
    
    var mockWeather: WeatherResponse?
    var mockError: Error?
    
    func fetchWeather(
        latitude: Double,
        longitude: Double
    ) async throws -> WeatherResponse {
        
        if let error = mockError {
            throw error
        }
        
        guard let weather = mockWeather else {
            throw URLError(.unknown)
        }
        
        return weather
    }
    
    func fetchWeatherByCity(_ city: String) async throws -> WeatherResponse {
        
        if let error = mockError {
            throw error
        }
        
        guard let weather = mockWeather else {
            throw URLError(.unknown)
        }
        
        return weather
    }
}

func createMockWeather() -> WeatherResponse {
    WeatherResponse(
        latitude: -22.9,
        longitude: -47.0,
        timezone: "America/Sao_Paulo",
        current: CurrentWeather(
            temperature: 25.5,
            weatherCode: 0,
            windSpeed: 5.2,
            humidity: 60
        )
    )
}
