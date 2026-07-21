//
//  CitySearchRow.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 16/07/26.
//

import SwiftUI
import SwiftData

struct CitySearchRow: View {
    let city: CityResult
    var onSelect: () -> Void = {}

    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteCity]

    private var isFavorite: Bool {
        favoritesViewModel.isFavorite(name: city.name, country: city.country, in: favorites)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(city.name)
                    .font(.headline)
                    .foregroundStyle(.white)

                Text(city.country)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: onSelect)

            Spacer()

            Button {
                favoritesViewModel.toggleFavorite(
                    name: city.name,
                    country: city.country,
                    latitude: city.latitude,
                    longitude: city.longitude,
                    favorites: favorites,
                    context: modelContext
                )
            } label: {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundStyle(isFavorite ? .yellow : .white.opacity(0.5))
            }
            .buttonStyle(.plain)
            .frame(minWidth: 44, minHeight: 44)

            Image(systemName: "chevron.right")
                .font(.footnote.bold())
                .foregroundStyle(.white.opacity(0.5))
                .contentShape(Rectangle())
                .onTapGesture(perform: onSelect)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(WeatherTheme.cardBackground)
        .clipShape(.rect(cornerRadius: WeatherTheme.cardCornerRadius))
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: WeatherTheme.gradientColors, startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        CitySearchRow(city: CityResult(name: "Campinas", latitude: -22.9, longitude: -47.0, country: "Brazil"))
            .padding()
    }
    .environmentObject(FavoritesViewModel())
    .modelContainer(for: [FavoriteCity.self], inMemory: true)
}
