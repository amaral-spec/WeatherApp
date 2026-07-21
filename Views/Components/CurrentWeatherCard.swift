//
//  CurrentWeatherCard.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 16/07/26.
//

import SwiftUI

struct CurrentWeatherCard: View {
    let weather: CurrentWeather

    @ScaledMetric(relativeTo: .largeTitle) private var temperatureSize: CGFloat = 72

    var body: some View {
        VStack(spacing: WeatherTheme.contentSpacing) {
            Text("\(Int(weather.temperature.rounded()))°")
                .font(.system(size: temperatureSize, weight: .bold))
                .foregroundStyle(.white)

            Text(describeWeather(weather.weatherCode))
                .font(.headline)
                .foregroundStyle(.white)

            HStack(spacing: WeatherTheme.contentSpacing) {
                WeatherStatItem(title: "Umidade", value: "\(weather.humidity)%")

                Divider()
                    .frame(height: 40)

                WeatherStatItem(title: "Vento", value: "\(Int(weather.windSpeed.rounded())) km/h")
            }
            .padding()
            .background(WeatherTheme.cardBackground)
            .clipShape(.rect(cornerRadius: WeatherTheme.cardCornerRadius))
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    CurrentWeatherCard(
        weather: CurrentWeather(temperature: 24.6, weatherCode: 1, windSpeed: 12, humidity: 65)
    )
    .padding()
    .background(LinearGradient(colors: WeatherTheme.gradientColors, startPoint: .top, endPoint: .bottom))
}
