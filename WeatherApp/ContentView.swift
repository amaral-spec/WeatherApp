//
//  ContentView.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 14/07/26.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var weatherViewModel = WeatherViewModel()
    @StateObject var locationViewModel = LocationViewModel()
    @State private var cameraPosition: MapCameraPosition = .automatic
    
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
                
                if let cityName = locationViewModel.cityName {
                    Text(cityName)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                if weatherViewModel.isLoading || locationViewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .foregroundColor(.white)
                    
                } else if let errorMessage = weatherViewModel.errorMessage ?? locationViewModel.errorMessage {
                    VStack(spacing: 10) {
                        Text("Erro")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    
                } else if let weather = weatherViewModel.weather {
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
                }
                
                Spacer()
                
                if locationViewModel.latitude != 0 && locationViewModel.longitude != 0 {
                    Map(position: $cameraPosition)
                        .frame(height: 350)
                        .cornerRadius(10)
                } else {
                    ProgressView()
                        .frame(height: 350)
                }
            }
            .padding()
        }
        .onAppear {
            locationViewModel.requestLocation()
        }
        .onChange(of: locationViewModel.latitude) { _, newLatitude in
            guard newLatitude != 0,
                  locationViewModel.longitude != 0 else { return }
            
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: newLatitude,
                        longitude: locationViewModel.longitude
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.05,
                        longitudeDelta: 0.05
                    )
                )
            )
            
            Task {
                await weatherViewModel.fetchWeather(
                    latitude: newLatitude,
                    longitude: locationViewModel.longitude
                )
                
                await locationViewModel.fetchCity(
                    latitude: newLatitude,
                    longitude: locationViewModel.longitude
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
