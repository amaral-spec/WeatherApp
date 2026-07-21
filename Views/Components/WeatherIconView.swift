//
//  WeatherIconView.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 16/07/26.
//

import SwiftUI

struct WeatherIconView: View {
    let weatherCode: Int

    @ScaledMetric(relativeTo: .largeTitle) private var iconSize: CGFloat = 80

    var body: some View {
        Image(systemName: weatherAnimation(weatherCode))
            .symbolRenderingMode(.multicolor)
            .font(.system(size: iconSize))
            .accessibilityHidden(true)
    }
}

#Preview {
    WeatherIconView(weatherCode: 0)
}
