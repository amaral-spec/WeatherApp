//
//  HourlyForecastRow.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 20/07/26.
//

import SwiftUI

struct HourlyForecastRow: View {
    let hourly: HourlyForecast
    let timezone: String
    var isNow: Bool = false

    private var timeLabel: String {
        isNow ? "Agora" : formatHourlyTime(hourly.time, timezone: timezone)
    }

    private var temperatureLabel: String {
        "\(Int(hourly.temperature.rounded()))°"
    }

    var body: some View {
        VStack(spacing: 6) {
            Text(timeLabel)
                .font(.subheadline.weight(isNow ? .semibold : .regular))

            Image(systemName: weatherAnimation(hourly.weatherCode))
                .symbolRenderingMode(.multicolor)
                .font(.title3)
                .accessibilityHidden(true)

            Text(temperatureLabel)
                .font(.headline)
        }
        .foregroundStyle(.white)
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .frame(minWidth: 64)
        .background(isNow ? WeatherTheme.cardBackgroundEmphasized : WeatherTheme.cardBackground)
        .clipShape(.rect(cornerRadius: WeatherTheme.cardCornerRadius))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(timeLabel), \(describeWeather(hourly.weatherCode)), \(temperatureLabel)")
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: WeatherTheme.gradientColors, startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        HStack {
            HourlyForecastRow(
                hourly: HourlyForecast(time: "2026-07-20T14:00", temperature: 22, weatherCode: 0, windSpeed: 10),
                timezone: "America/Sao_Paulo",
                isNow: true
            )
            HourlyForecastRow(
                hourly: HourlyForecast(time: "2026-07-20T15:00", temperature: 21, weatherCode: 3, windSpeed: 12),
                timezone: "America/Sao_Paulo"
            )
        }
    }
}
