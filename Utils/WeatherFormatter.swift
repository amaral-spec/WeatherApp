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
