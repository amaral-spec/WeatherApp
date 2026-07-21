//
//  WeatherNotificationScheduler.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 21/07/26.
//

import Foundation
import UserNotifications

enum NotificationSchedulingError: LocalizedError {
    case authorizationDenied

    var errorDescription: String? {
        switch self {
        case .authorizationDenied:
            return "Permita notificações nos Ajustes do iOS para receber atualizações do clima."
        }
    }
}

@MainActor
enum WeatherNotificationScheduler {

    private static func identifier(for city: FavoriteCity) -> String {
        "weather-\(city.id)"
    }

    private static func requestAuthorization() async throws {
        let center = UNUserNotificationCenter.current()
        let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])

        guard granted else {
            throw NotificationSchedulingError.authorizationDenied
        }
    }

    static func scheduleDailyNotification(
        for city: FavoriteCity,
        service: WeatherServiceProtocol = WeatherService()
    ) async throws {
        try await requestAuthorization()

        let weather = try await service.fetchWeather(latitude: city.latitude, longitude: city.longitude)

        let content = UNMutableNotificationContent()
        content.title = "Clima em \(city.cityName)"
        content.body = "\(Int(weather.current.temperature.rounded()))° e \(describeWeather(weather.current.weatherCode).lowercased()) agora."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: identifier(for: city),
            content: content,
            trigger: trigger
        )

        try await UNUserNotificationCenter.current().add(request)
    }

    static func cancelNotification(for city: FavoriteCity) {
        let id = identifier(for: city)
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id])
        center.removeDeliveredNotifications(withIdentifiers: [id])
    }
}
