//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 14/07/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class WeatherViewModel: ObservableObject {
    
    @Published var weather: WeatherResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hourlyForecast: [HourlyForecast] = []
    
    let service: WeatherServiceProtocol
    
    init(service: WeatherServiceProtocol = WeatherService()) {
        self.service = service
    }
    
    func fetchWeather(latitude: Double, longitude: Double) async {
        isLoading = true
        errorMessage = nil
        weather = nil
        hourlyForecast = []

        do {
            let weather = try await service.fetchWeather(latitude: latitude, longitude: longitude)
            self.weather = weather
            hourlyForecast = nextHours(from: weather.hourly, timezone: weather.timezone)

            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
