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
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Clima", systemImage: "cloud.sun.fill") {
                    ContentView()
                }
                Tab("Buscar", systemImage: "magnifyingglass") {
                    SearchCityView()
                }
            }
            .preferredColorScheme(.dark)
        }
        .modelContainer(for: [FavoriteCity.self])
    }
}
