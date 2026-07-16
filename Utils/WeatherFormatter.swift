//
//  WeatherFormatter.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 15/07/26.
//

import Foundation

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

func weatherAnimation(_ code: Int) -> String {
    switch code {
    case 0: return "sun.max.fill"           // Céu limpo
    case 1, 2: return "cloud.sun.fill"      // Parcialmente nublado
    case 3: return "cloud.fill"             // Nublado
    case 45, 48: return "cloud.fog.fill"    // Névoa
    case 51...67: return "cloud.rain.fill"  // Chuva
    case 71...77: return "cloud.snow.fill"  // Neve
    default: return "cloud.fill"
    }
}
