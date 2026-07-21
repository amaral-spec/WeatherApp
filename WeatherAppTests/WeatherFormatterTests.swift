//
//  WeatherFormatterTests.swift
//  WeatherAppTests
//
//  Created by Gabriel Amaral on 20/07/26.
//

import XCTest
@testable import WeatherApp

final class WeatherFormatterTests: XCTestCase {

    // Testa: "nextHours usa o fuso da cidade pesquisada, não o do dispositivo?"
    func testNextHoursUsesCityTimezoneNotDeviceTimezone() {
        // ARRANGE
        // now = 2026-07-20 12:00 UTC = 21:00 em Tóquio (UTC+9)
        let isoFormatter = ISO8601DateFormatter()
        let now = isoFormatter.date(from: "2026-07-20T12:00:00Z")!

        let hourlyData = HourlyData(
            time: ["2026-07-20T20:00", "2026-07-20T21:00", "2026-07-20T22:00", "2026-07-20T23:00"],
            temperature: [18, 17, 16, 15],
            weatherCode: [0, 0, 0, 0],
            windSpeed: [1, 2, 3, 4]
        )

        // ACT
        let result = nextHours(from: hourlyData, timezone: "Asia/Tokyo", count: 2, now: now)

        // ASSERT
        // Deveria começar às 21:00 (hora local de Tóquio), não em outro índice
        // calculado a partir da hora do dispositivo rodando o teste.
        XCTAssertEqual(result.map(\.time), ["2026-07-20T21:00", "2026-07-20T22:00"])
    }

    func testNextHoursReturnsEmptyWhenAllHoursAreInThePast() {
        let isoFormatter = ISO8601DateFormatter()
        let now = isoFormatter.date(from: "2026-07-21T00:00:00Z")!

        let hourlyData = HourlyData(
            time: ["2026-07-20T20:00", "2026-07-20T21:00"],
            temperature: [18, 17],
            weatherCode: [0, 0],
            windSpeed: [1, 2]
        )

        let result = nextHours(from: hourlyData, timezone: "Asia/Tokyo", count: 12, now: now)

        XCTAssertTrue(result.isEmpty)
    }
}
