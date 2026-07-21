//
//  FavoritesViewModel.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 21/07/26.
//

import Foundation
import Combine
import SwiftData

@MainActor
class FavoritesViewModel: ObservableObject {

    @Published var notificationError: String?

    func isFavorite(name: String, country: String, in favorites: [FavoriteCity]) -> Bool {
        favorite(name: name, country: country, in: favorites) != nil
    }

    func favorite(name: String, country: String, in favorites: [FavoriteCity]) -> FavoriteCity? {
        favorites.first { $0.cityName == name && $0.cityCountry == country }
    }

    @discardableResult
    func toggleFavorite(
        name: String,
        country: String,
        latitude: Double,
        longitude: Double,
        favorites: [FavoriteCity],
        context: ModelContext
    ) -> FavoriteCity? {
        if let existing = favorite(name: name, country: country, in: favorites) {
            if existing.notificate {
                WeatherNotificationScheduler.cancelNotification(for: existing)
            }
            context.delete(existing)
            saveContext(context)
            return nil
        } else {
            let newFavorite = FavoriteCity(
                cityName: name,
                cityCountry: country,
                latitude: latitude,
                longitude: longitude,
                notificate: false
            )
            context.insert(newFavorite)
            saveContext(context)
            return newFavorite
        }
    }

    private func saveContext(_ context: ModelContext) {
        do {
            try context.save()
        } catch {
            notificationError = "Não foi possível salvar: \(error.localizedDescription)"
        }
    }

    func setNotifications(
        enabled: Bool,
        name: String,
        country: String,
        latitude: Double,
        longitude: Double,
        favorites: [FavoriteCity],
        context: ModelContext
    ) async {
        notificationError = nil

        let favorite = favorite(name: name, country: country, in: favorites) ?? {
            let newFavorite = FavoriteCity(
                cityName: name,
                cityCountry: country,
                latitude: latitude,
                longitude: longitude,
                notificate: false
            )
            context.insert(newFavorite)
            return newFavorite
        }()

        if enabled {
            do {
                try await WeatherNotificationScheduler.scheduleDailyNotification(for: favorite)
                favorite.notificate = true
            } catch {
                favorite.notificate = false
                notificationError = error.localizedDescription
            }
        } else {
            WeatherNotificationScheduler.cancelNotification(for: favorite)
            favorite.notificate = false
        }

        saveContext(context)
    }
}
