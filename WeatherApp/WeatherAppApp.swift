//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 14/07/26.
//

import SwiftUI
import SwiftData

@main
struct WeatherAppApp: App {
    @StateObject private var favoritesViewModel = FavoritesViewModel()

    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Clima", systemImage: "cloud.sun.fill") {
                    ContentView()
                }
                Tab("Buscar", systemImage: "magnifyingglass") {
                    SearchCityView()
                }
                Tab("Favoritos", systemImage: "star.fill") {
                    FavoritesView()
                }
            }
            .environmentObject(favoritesViewModel)
            .preferredColorScheme(.dark)
            .alert(
                "Não foi possível concluir",
                isPresented: Binding(
                    get: { favoritesViewModel.notificationError != nil },
                    set: { isPresented in
                        if !isPresented { favoritesViewModel.notificationError = nil }
                    }
                )
            ) {
                Button("OK") {}
            } message: {
                Text(favoritesViewModel.notificationError ?? "")
            }
        }
        .modelContainer(for: [FavoriteCity.self])
    }
}
