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
            let allResults = try await service.searchCitiesWithName(query)
            results = removeDuplicates(allResults)
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

    private func removeDuplicates(_ cities: [CityResult]) -> [CityResult] {
        var seen = Set<String>()
        return cities.filter { city in
            let key = "\(city.name), \(city.country)"
            if seen.contains(key) {
                return false
            }
            seen.insert(key)
            return true
        }
    }
        
}
