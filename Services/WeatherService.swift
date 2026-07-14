//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 14/07/26.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

protocol WeatherServiceProtocol {
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse
    
    func fetchWeatherByCity(_ city: String) async throws -> WeatherResponse
}

actor WeatherService: WeatherServiceProtocol {
    
    let session: URLSessionProtocol
    private let baseURL = "https://api.open-meteo.com/v1"
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchWeather(
        latitude: Double,
        longitude: Double
    ) async throws -> WeatherResponse {
        
        let urlString = "\(baseURL)/forecast?" +
            "latitude=\(latitude)" +
            "&longitude=\(longitude)" +
            "&current=temperature_2m,weather_code,wind_speed_10m,relative_humidity_2m" +
            "&timezone=auto"
        
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw WeatherError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
        
        return weatherResponse
    }
    
    func fetchWeatherByCity(_ city: String) async throws -> WeatherResponse {
        
        switch city.lowercased() {
        case "campinas", "campinas, sp":
            return try await fetchWeather(latitude: -22.9, longitude: -47.0)
        case "são paulo", "sp":
            return try await fetchWeather(latitude: -23.55, longitude: -46.63)
        default:
            throw WeatherError.cityNotFound
        }
    }
}

enum WeatherError: Error {
    case invalidURL
    case invalidResponse
    case cityNotFound
    case decodingError
}
