//
//  HourlyForecastView.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 20/07/26.
//

import SwiftUI

struct HourlyForecastView: View {
    let forecast: [HourlyForecast]
    let timezone: String

    var body: some View {
        if !forecast.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Próximas Horas")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(forecast.enumerated(), id: \.element.id) { index, hourly in
                            HourlyForecastRow(hourly: hourly, timezone: timezone, isNow: index == 0)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

//#Preview {
//    ZStack {
//        LinearGradient(colors: WeatherTheme.gradientColors, startPoint: .top, endPoint: .bottom)
//            .ignoresSafeArea()
//        HourlyForecastView(
//            forecast: [
//                HourlyForecast(time: "2026-07-20T14:00", temperature: 22, weatherCode: 0, windSpeed: 10),
//                HourlyForecast(time: "2026-07-20T15:00", temperature: 21, weatherCode: 3, windSpeed: 12),
//                HourlyForecast(time: "2026-07-20T16:00", temperature: 20, weatherCode: 61, windSpeed: 14)
//            ],
//            timezone: "America/Sao_Paulo"
//        )
//        .padding()
//    }
//}
