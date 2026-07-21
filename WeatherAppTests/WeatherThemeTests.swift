//
//  WeatherThemeTests.swift
//  WeatherAppTests
//
//  Created by Gabriel Amaral on 21/07/26.
//

import XCTest
import SwiftUI
import UIKit
@testable import WeatherApp

final class WeatherThemeTests: XCTestCase {

    // Testa: "Temperaturas abaixo do menor stop usam a mesma cor do extremo, sem crash?"
    func testGradientClampsBelowColdestStop() {
        let veryCold = WeatherTheme.gradientColors(temperature: -40)
        let coldestStop = WeatherTheme.gradientColors(temperature: -15)
        XCTAssertEqual(veryCold, coldestStop)
    }

    // Testa: "Temperaturas acima do maior stop usam a mesma cor do extremo, sem crash?"
    func testGradientClampsAboveHottestStop() {
        let veryHot = WeatherTheme.gradientColors(temperature: 55)
        let hottestStop = WeatherTheme.gradientColors(temperature: 42)
        XCTAssertEqual(veryHot, hottestStop)
    }

    // Testa: "Uma pequena variação de temperatura nunca produz um salto brusco de cor?"
    func testGradientIsContinuousAcrossStopBoundaries() {
        for boundary in [-15.0, 0.0, 12.0, 20.0, 27.0, 34.0, 42.0] {
            let justBelow = WeatherTheme.gradientColors(temperature: boundary - 0.01)
            let justAbove = WeatherTheme.gradientColors(temperature: boundary + 0.01)
            for (below, above) in zip(justBelow, justAbove) {
                assertColorsClose(below, above, tolerance: 0.01, message: "Salto de cor detectado perto de \(boundary)°")
            }
        }
    }

    private func assertColorsClose(_ lhs: Color, _ rhs: Color, tolerance: CGFloat, message: String) {
        var lr: CGFloat = 0, lg: CGFloat = 0, lb: CGFloat = 0, la: CGFloat = 0
        var rr: CGFloat = 0, rg: CGFloat = 0, rb: CGFloat = 0, ra: CGFloat = 0
        UIColor(lhs).getRed(&lr, green: &lg, blue: &lb, alpha: &la)
        UIColor(rhs).getRed(&rr, green: &rg, blue: &rb, alpha: &ra)
        XCTAssertEqual(lr, rr, accuracy: tolerance, message)
        XCTAssertEqual(lg, rg, accuracy: tolerance, message)
        XCTAssertEqual(lb, rb, accuracy: tolerance, message)
    }

    // Testa: "Duas temperaturas iguais sempre produzem a mesma cor (função determinística)?"
    func testGradientIsDeterministic() {
        XCTAssertEqual(
            WeatherTheme.gradientColors(temperature: 23.5),
            WeatherTheme.gradientColors(temperature: 23.5)
        )
    }
}
