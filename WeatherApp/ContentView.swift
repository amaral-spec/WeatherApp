//
//  ContentView.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 14/07/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .cyan]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Clima Agora")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .foregroundColor(.white)
                    
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 10) {
                        Text("Erro")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            Task {
                                await viewModel.fetchWeather(
                                    latitude: -22.9,
                                    longitude: -47.0
                                )
                            }
                        }) {
                            Text("Tentar Novamente")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.white)
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    
                } else if let weather = viewModel.weather {
                    VStack(spacing: 20) {
                        Text("\(Int(weather.current.temperature))°")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(describeWeather(weather.current.weatherCode))
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 20) {
                            VStack(spacing: 5) {
                                Text("Umidade")
                                    .font(.caption)
                                Text("\(weather.current.humidity)%")
                                    .font(.headline)
                            }
                            
                            Divider()
                                .frame(height: 40)
                            
                            VStack(spacing: 5) {
                                Text("Vento")
                                    .font(.caption)
                                Text("\(Int(weather.current.windSpeed)) km/h")
                                    .font(.headline)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }
                    
                } else {
                    VStack(spacing: 10) {
                        Text("Toque abaixo para carregar clima")
                            .foregroundColor(.white)
                        
                        Button(action: {
                            Task {
                                await viewModel.fetchWeather(
                                    latitude: -22.9,
                                    longitude: -47.0
                                )
                            }
                        }) {
                            Text("Carregar Clima")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.white)
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    func describeWeather(_ code: Int) -> String {
        switch code {
        case 0: return "Céu Limpo"
        case 1, 2: return "Parcialmente Nublado"
        case 3: return "Nublado"
        case 45, 48: return "Névoa"
        case 51...67: return "Chuva"
        case 71...77: return "Neve"
        default: return "Desconhecido"
        }
    }
}


#Preview {
    ContentView()
}
