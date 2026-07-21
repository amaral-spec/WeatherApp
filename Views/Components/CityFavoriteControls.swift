//
//  CityFavoriteControls.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 21/07/26.
//

import SwiftUI
import SwiftData
struct CityFavoriteControls: View {
    let city: CityResult

    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteCity]

    private var favorite: FavoriteCity? {
        favoritesViewModel.favorite(name: city.name, country: city.country, in: favorites)
    }

    private var isNotifying: Bool {
        favorite?.notificate ?? false
    }

    var body: some View {
        HStack(spacing: 16) {
            Button(action: toggleFavorite) {
                Label(favorite != nil ? "Favoritado" : "Favoritar", systemImage: favorite != nil ? "star.fill" : "star")
            }
            .foregroundStyle(favorite != nil ? .yellow : .white)

            Divider()
                .frame(height: 20)

            Button(action: toggleNotifications) {
                Label(isNotifying ? "Notificações Ativadas" : "Notificações", systemImage: isNotifying ? "bell.fill" : "bell")
            }
            .foregroundStyle(isNotifying ? .yellow : .white)
        }
        .font(.subheadline.bold())
        .padding()
        .frame(maxWidth: .infinity)
        .background(WeatherTheme.cardBackground)
        .clipShape(.rect(cornerRadius: WeatherTheme.cardCornerRadius))
    }

    private func toggleFavorite() {
        favoritesViewModel.toggleFavorite(
            name: city.name,
            country: city.country,
            latitude: city.latitude,
            longitude: city.longitude,
            favorites: favorites,
            context: modelContext
        )
    }

    private func toggleNotifications() {
        Task {
            await favoritesViewModel.setNotifications(
                enabled: !isNotifying,
                name: city.name,
                country: city.country,
                latitude: city.latitude,
                longitude: city.longitude,
                favorites: favorites,
                context: modelContext
            )
        }
    }
}

//#Preview {
//    ZStack {
//        LinearGradient(colors: WeatherTheme.gradientColors, startPoint: .top, endPoint: .bottom)
//            .ignoresSafeArea()
//        CityFavoriteControls(city: CityResult(name: "Campinas", latitude: -22.9, longitude: -47.0, country: "Brazil"))
//            .padding()
//    }
//    .environmentObject(FavoritesViewModel())
//    .modelContainer(for: [FavoriteCity.self], inMemory: true)
//}
