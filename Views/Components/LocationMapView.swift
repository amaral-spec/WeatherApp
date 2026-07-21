//
//  LocationMapView.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 16/07/26.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    @Binding var cameraPosition: MapCameraPosition
    let latitude: Double
    let longitude: Double
    var markerTitle: String = "Você"

    var body: some View {
        Map(position: $cameraPosition) {
            Marker(markerTitle, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        }
        .containerRelativeFrame(.vertical) { height, _ in
            max(WeatherTheme.minMapHeight, height * 0.35)
        }
        .clipShape(.rect(cornerRadius: WeatherTheme.cardCornerRadius))
    }
}

#Preview {
    LocationMapView(cameraPosition: .constant(.automatic), latitude: -22.9, longitude: -47.0)
}
