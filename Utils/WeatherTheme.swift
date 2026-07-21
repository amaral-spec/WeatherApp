//
//  WeatherTheme.swift
//  WeatherApp
//
//  Created by Gabriel Amaral on 16/07/26.
//

import SwiftUI

enum WeatherTheme {
    static let contentSpacing: CGFloat = 20
    static let cardCornerRadius: CGFloat = 10
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBackgroundEmphasized = Color.white.opacity(0.25)
    static let backgroundTransition = Animation.easeInOut(duration: 0.8)
    static let minMapHeight: CGFloat = 220

    static let defaultTemperature: Double = 20

    private typealias HSB = (hue: Double, saturation: Double, brightness: Double)

    private static let stops: [(temperature: Double, top: HSB, bottom: HSB)] = [
        (-15, (235, 0.55, 0.30), (235, 0.50, 0.46)), // Congelante — indigo noturno
        (0,   (205, 0.90, 0.54), (200, 0.80, 0.65)), // Frio — azul gelado
        (12,  (190, 0.90, 0.56), (185, 0.80, 0.62)), // Fresco — azul-ciano
        (20,  (165, 0.85, 0.44), (150, 0.75, 0.56)), // Ameno — verde-azulado
        (27,  (40,  0.85, 0.48), (38,  0.80, 0.68)), // Quente — âmbar
        (34,  (18,  0.80, 0.62), (10,  0.80, 0.55)), // Muito quente — laranja avermelhado
        (42,  (-2,  0.75, 0.45), (-6,  0.80, 0.32)), // Extremo — vermelho profundo
    ]

    static func gradientColors(temperature: Double) -> [Color] {
        guard let first = stops.first, let last = stops.last else { return [.blue, .cyan] }

        if temperature <= first.temperature {
            return [Color(hsb: first.top), Color(hsb: first.bottom)]
        }
        if temperature >= last.temperature {
            return [Color(hsb: last.top), Color(hsb: last.bottom)]
        }

        for (lower, upper) in zip(stops, stops.dropFirst()) where temperature <= upper.temperature {
            let fraction = (temperature - lower.temperature) / (upper.temperature - lower.temperature)
            return [
                Color(hsb: lerp(lower.top, upper.top, fraction)),
                Color(hsb: lerp(lower.bottom, upper.bottom, fraction))
            ]
        }
        return [.blue, .cyan]
    }

    private static func lerp(_ a: HSB, _ b: HSB, _ t: Double) -> HSB {
        (a.hue + (b.hue - a.hue) * t, a.saturation + (b.saturation - a.saturation) * t, a.brightness + (b.brightness - a.brightness) * t)
    }
}

private extension Color {
    init(hsb: (hue: Double, saturation: Double, brightness: Double)) {
        var normalizedHue = hsb.hue.truncatingRemainder(dividingBy: 360)
        if normalizedHue < 0 { normalizedHue += 360 }
        self.init(hue: normalizedHue / 360, saturation: hsb.saturation, brightness: hsb.brightness)
    }
}
