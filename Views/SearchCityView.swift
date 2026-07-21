//
//  SearchCityView.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 16/07/26.
//

import SwiftUI
import SwiftData

struct SearchCityView: View {
    @StateObject private var searchViewModel = CitySearchViewModel()
    @State private var searchText = ""
    @State private var selectedCity: CityResult?

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: WeatherTheme.gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                if let selectedCity {
                    selectedCityContent(selectedCity)
                } else {
                    searchContent
                }
            }
            .navigationTitle("Buscar Clima")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Digite uma cidade"
            )
            .textInputAutocapitalization(.words)
            .autocorrectionDisabled()
            .task(id: searchText) {
                guard !searchText.isEmpty else {
                    searchViewModel.clear()
                    return
                }

                try? await Task.sleep(for: .milliseconds(300))
                guard !Task.isCancelled else { return }

                await searchViewModel.search(searchText)
            }
        }
    }

    private func selectedCityContent(_ city: CityResult) -> some View {
        CityWeatherDetailView(city: city) {
            VStack(spacing: 12) {
                CityFavoriteControls(city: city)

                Button("Nova Busca", systemImage: "magnifyingglass", action: resetSearch)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(WeatherTheme.cardBackground)
                    .clipShape(.rect(cornerRadius: WeatherTheme.cardCornerRadius))
            }
        }
    }

    @ViewBuilder
    private var searchContent: some View {
        if searchViewModel.isSearching {
            ProgressView()
                .tint(.white)
        } else if let errorMessage = searchViewModel.errorMessage {
            WeatherErrorView(message: errorMessage) {
                Task { await searchViewModel.search(searchText) }
            }
        } else if searchText.isEmpty {
            ContentUnavailableView(
                "Buscar Cidade",
                systemImage: "magnifyingglass",
                description: Text("Digite o nome de uma cidade para ver o clima.")
            )
            .foregroundStyle(.white)
        } else if searchViewModel.results.isEmpty {
            ContentUnavailableView.search(text: searchText)
                .foregroundStyle(.white)
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(searchViewModel.results) { city in
                        CitySearchRow(city: city, onSelect: { selectCity(city) })
                    }
                }
                .padding()
            }
        }
    }

    private func selectCity(_ city: CityResult) {
        selectedCity = city
    }

    private func resetSearch() {
        selectedCity = nil
    }
}

#Preview {
    SearchCityView()
        .environmentObject(FavoritesViewModel())
        .modelContainer(for: [FavoriteCity.self], inMemory: true)
}
