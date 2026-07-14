//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 14/07/26.
//

import Foundation
import Combine

@MainActor
class WeatherViewModel: ObservableObject {
    
    @Published var weather: WeatherResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let service: WeatherServiceProtocol
    
    init(service: WeatherServiceProtocol = WeatherService()) {
        self.service = service
    }
    
    func fetchWeather(latitude: Double, longitude: Double) async {
        // Prepara estado
        isLoading = true
        errorMessage = nil
        weather = nil
        
        do {
            weather = try await service.fetchWeather(
                latitude: latitude,
                longitude: longitude
            )
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
