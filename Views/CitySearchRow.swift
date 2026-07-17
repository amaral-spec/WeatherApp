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
    
    @Query var favoriteCities: [FavoriteCity]
    @Environment(\.modelContext) var modelContext

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

            Spacer()
            
            Button {
                toggleFavorite()
            } label: {
                Image(systemName: isFavorite() ? "star.fill" : "star")
                    .foregroundStyle(isFavorite() ? .yellow : .white.opacity(0.5))
            }

            Image(systemName: "chevron.right")
                .font(.footnote.bold())
                .foregroundStyle(.white.opacity(0.5))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(WeatherTheme.cardBackground)
        .clipShape(.rect(cornerRadius: WeatherTheme.cardCornerRadius))
    }
    
    
    private func isFavorite() -> Bool {
        favoriteCities.contains {
            $0.cityName == city.name && $0.cityCountry == city.country
        }
    }
    
    private func toggleFavorite() {
        if isFavorite() {
            if let favorite = favoriteCities.first(where: {
                $0.cityName == city.name && $0.cityCountry == city.country
            }) {
                modelContext.delete(favorite)
            }
        } else {
            let newFavorite = FavoriteCity(
                cityName: city.name,
                cityCountry: city.country,
                latitude: city.latitude,
                longitude: city.longitude
            )
            modelContext.insert(newFavorite)
        }
        
        try? modelContext.save()
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: WeatherTheme.gradientColors, startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        CitySearchRow(city: CityResult(name: "Campinas", latitude: -22.9, longitude: -47.0, country: "Brazil"))
            .padding()
    }
}
