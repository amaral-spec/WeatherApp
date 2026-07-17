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
    @State private var loadingStarted = false

    private var errorMessage: String? {
        weatherViewModel.errorMessage ?? locationViewModel.errorMessage
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: WeatherTheme.gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: WeatherTheme.contentSpacing) {
                    if let weather = weatherViewModel.weather {
                        WeatherIconView(weatherCode: weather.current.weatherCode)
                    }

                    Text("Clima Agora")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)

                    if let cityName = locationViewModel.cityName {
                        Text(cityName)
                            .font(.headline)
                            .foregroundStyle(.white)
                    }

                    if weatherViewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)
                    } else if let errorMessage {
                        WeatherErrorView(message: errorMessage, retryAction: retryLoading)
                    } else if let weather = weatherViewModel.weather {
                        CurrentWeatherCard(weather: weather.current)
                    }

                    if locationViewModel.latitude != 0 && locationViewModel.longitude != 0 {
                        LocationMapView(
                            cameraPosition: $cameraPosition,
                            latitude: locationViewModel.latitude,
                            longitude: locationViewModel.longitude
                        )
                    } else {
                        ProgressView()
                            .tint(.white)
                            .frame(minHeight: WeatherTheme.minMapHeight)
                    }
                }
                .padding()
            }
        }
        .onAppear(perform: startLoadingIfNeeded)
        .onChange(of: locationViewModel.latitude) { _, newLatitude in
            guard newLatitude != 0, locationViewModel.longitude != 0 else { return }
            fetchWeatherAndCity(lat: newLatitude, lon: locationViewModel.longitude)
        }
        .refreshable {
            await weatherViewModel.fetchWeather(
                latitude: locationViewModel.latitude,
                longitude: locationViewModel.longitude
            )
            await locationViewModel.fetchCity(
                latitude: locationViewModel.latitude,
                longitude: locationViewModel.longitude
            )
        }
    }

    private func startLoadingIfNeeded() {
        guard !loadingStarted else { return }
        loadingStarted = true
        locationViewModel.requestLocation()

        Task {
            try? await Task.sleep(for: .seconds(3))
            if locationViewModel.latitude == 0 {
                loadWeatherWithFallback()
            }
        }
    }

    private func retryLoading() {
        loadingStarted = false
        weatherViewModel.errorMessage = nil
        locationViewModel.errorMessage = nil
        startLoadingIfNeeded()
    }

    private func loadWeatherWithFallback() {
        Task {
            await weatherViewModel.fetchWeather(latitude: -22.9, longitude: -47.0)
            await locationViewModel.fetchCity(latitude: -22.9, longitude: -47.0)
        }
    }

    private func fetchWeatherAndCity(lat: Double, lon: Double) {
        cameraPosition = .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        )

        Task {
            async let weather: () = weatherViewModel.fetchWeather(latitude: lat, longitude: lon)
            async let city: () = locationViewModel.fetchCity(latitude: lat, longitude: lon)

            _ = await (weather, city)
        }
    }
}

#Preview {
    ContentView()
}
