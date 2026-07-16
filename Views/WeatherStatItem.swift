//
//  WeatherStatItem.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 16/07/26.
//

import SwiftUI

struct WeatherStatItem: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.subheadline)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    WeatherStatItem(title: "Umidade", value: "80%")
        .padding()
        .background(.blue)
}
