//
//  WeatherErrorView.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 16/07/26.
//

import SwiftUI

struct WeatherErrorView: View {
    let message: String
    let retryAction: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label("Erro ao Carregar", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("Tentar Novamente", systemImage: "arrow.clockwise", action: retryAction)
        }
        .foregroundStyle(.white)
    }
}

//#Preview {
//    WeatherErrorView(message: "Não foi possível obter sua localização.") {}
//        .padding()
//        .background(LinearGradient(colors: WeatherTheme.gradientColors, startPoint: .top, endPoint: .bottom))
//}
