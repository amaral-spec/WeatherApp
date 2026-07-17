//
//  SearchCityView.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 16/07/26.
//

import SwiftUI
import MapKit

struct SearchCityView: View {
    @StateObject private var searchViewModel = CitySearchViewModel()
    @StateObject private var weatherViewModel = WeatherViewModel()
    @State private var searchText = ""
    @State private var selectedCity: CityResult?
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: WeatherTheme.gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                if let selectedCity {
                    selectedCityContent(selectedCity)
                } else {
                    searchContent
                }
            }
            .navigationTitle("Buscar Clima")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Digite uma cidade"
            )
            .textInputAutocapitalization(.words)
            .autocorrectionDisabled()
            .task(id: searchText) {
                guard !searchText.isEmpty else {
                    searchViewModel.clear()
                    return
                }

                try? await Task.sleep(for: .milliseconds(300))
                guard !Task.isCancelled else { return }

                await searchViewModel.search(searchText)
            }
        }
    }

    private func selectedCityContent(_ city: CityResult) -> some View {
        ScrollView {
            VStack(spacing: WeatherTheme.contentSpacing) {
                if let weather = weatherViewModel.weather {
                    WeatherIconView(weatherCode: weather.current.weatherCode)
                }

                Text(city.name)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                Text(city.country)
                    .font(.headline)
                    .foregroundStyle(.white)

                if weatherViewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                } else if let errorMessage = weatherViewModel.errorMessage {
                    WeatherErrorView(message: errorMessage) {
                        Task { await fetchWeather(for: city) }
                    }
                } else if let weather = weatherViewModel.weather {
                    CurrentWeatherCard(weather: weather.current)
                }

                LocationMapView(
                    cameraPosition: $cameraPosition,
                    latitude: city.latitude,
                    longitude: city.longitude,
                    markerTitle: city.name
                )

                Button("Nova Busca", systemImage: "magnifyingglass", action: resetSearch)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(WeatherTheme.cardBackground)
                    .clipShape(.rect(cornerRadius: WeatherTheme.cardCornerRadius))
            }
            .padding()
        }
        .task(id: city) {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            )
            await fetchWeather(for: city)
        }
    }

    @ViewBuilder
    private var searchContent: some View {
        if searchViewModel.isSearching {
            ProgressView()
                .tint(.white)
        } else if let errorMessage = searchViewModel.errorMessage {
            WeatherErrorView(message: errorMessage) {
                Task { await searchViewModel.search(searchText) }
            }
        } else if searchText.isEmpty {
            ContentUnavailableView(
                "Buscar Cidade",
                systemImage: "magnifyingglass",
                description: Text("Digite o nome de uma cidade para ver o clima.")
            )
            .foregroundStyle(.white)
        } else if searchViewModel.results.isEmpty {
            ContentUnavailableView.search(text: searchText)
                .foregroundStyle(.white)
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(searchViewModel.results) { city in
                        Button {
                            selectCity(city)
                        } label: {
                            CitySearchRow(city: city)
                        }
                    }
                }
                .padding()
            }
        }
    }

    private func selectCity(_ city: CityResult) {
        selectedCity = city
    }

    private func fetchWeather(for city: CityResult) async {
        await weatherViewModel.fetchWeather(latitude: city.latitude, longitude: city.longitude)
    }

    private func resetSearch() {
        selectedCity = nil
        weatherViewModel.weather = nil
        weatherViewModel.errorMessage = nil
    }
}

#Preview {
    SearchCityView()
}
