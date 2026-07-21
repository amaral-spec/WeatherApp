//
//  FavoritesView.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 21/07/26.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Query(sort: \FavoriteCity.addedDate, order: .reverse) private var favorites: [FavoriteCity]
    @State private var selectedCity: CityResult?
    @State private var displayedTemperature: Double = WeatherTheme.defaultTemperature

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: WeatherTheme.gradientColors(temperature: displayedTemperature),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .animation(WeatherTheme.backgroundTransition, value: displayedTemperature)

                if let selectedCity {
                    CityWeatherDetailView(city: selectedCity, onTemperatureChange: { temperature in
                        displayedTemperature = temperature ?? WeatherTheme.defaultTemperature
                    }) {
                        CityFavoriteControls(city: selectedCity)
                    }
                } else {
                    favoritesList
                }
            }
            .navigationTitle(selectedCity?.name ?? "Favoritos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                if selectedCity != nil {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Favoritos", systemImage: "chevron.left") {
                            selectedCity = nil
                            displayedTemperature = WeatherTheme.defaultTemperature
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var favoritesList: some View {
        if favorites.isEmpty {
            ContentUnavailableView(
                "Nenhuma Cidade Favorita",
                systemImage: "star",
                description: Text("Toque na estrela ao buscar uma cidade para adicioná-la aqui.")
            )
            .foregroundStyle(.white)
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(favorites) { favorite in
                        FavoriteCityRow(favorite: favorite, onSelect: { selectedCity = favorite.asCityResult })
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesViewModel())
        .modelContainer(for: [FavoriteCity.self], inMemory: true)
}
