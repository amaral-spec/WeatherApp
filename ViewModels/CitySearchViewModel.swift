//
//  CitySearchViewModel.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 16/07/26.
//

import Foundation
import Combine

@MainActor
class CitySearchViewModel: ObservableObject {

    @Published var results: [CityResult] = []
    @Published var isSearching = false
    @Published var errorMessage: String?

    let service: WeatherServiceProtocol

    init(service: WeatherServiceProtocol = WeatherService()) {
        self.service = service
    }

    func search(_ query: String) async {
        guard !query.isEmpty else {
            results = []
            errorMessage = nil
            return
        }

        isSearching = true
        errorMessage = nil

        do {
            results = try await service.searchCitiesWithName(query)
        } catch {
            results = []
            errorMessage = error.localizedDescription
        }

        isSearching = false
    }

    func clear() {
        results = []
        errorMessage = nil
    }
}
