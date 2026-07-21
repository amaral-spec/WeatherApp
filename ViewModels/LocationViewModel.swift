//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 15/07/26.
//

import Foundation
import CoreLocation
import Combine

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var cityName: String?
    @Published var countryName: String?

    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        
        self.latitude = lastLocation.coordinate.latitude
        self.longitude = lastLocation.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to look up location: \(error.localizedDescription)")
    }
    
    func fetchCity(latitude: Double, longitude: Double) async {
        isLoading = true
        errorMessage = nil

        do {
            let service = WeatherService()
            let placemark = try await service.getPlacemarkLocation(latitude: latitude, longitude: longitude)
            cityName = placemark.city
            countryName = placemark.country

            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}

