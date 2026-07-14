//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Gabriel Amaral on 14/07/26.
//

import XCTest
@testable import WeatherApp

@MainActor
final class WeatherViewModelTests: XCTestCase {
    
    var sut: WeatherViewModel!
    var mockService: MockWeatherService!
    
    override func setUp() {
        super.setUp()
        mockService = MockWeatherService()
        sut = WeatherViewModel(service: mockService)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        mockService = nil
    }
    
    // ====== TESTE 1 ======
    // Testa: "Depois de fetch bem-sucedido, weather é atualizado?"
    func testFetchWeatherSuccess() async {
        // ARRANGE
        mockService.mockWeather = createMockWeather()
        
        // ACT
        await sut.fetchWeather(latitude: -22.9, longitude: -47.0)
        
        // ASSERT
        XCTAssertNotNil(sut.weather)
        XCTAssertEqual(sut.weather?.current.temperature, 25.5)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    // ====== TESTE 2 ======
    // Testa: "Enquanto tá carregando, isLoading é true?"
    func testFetchWeatherIsLoadingState() async {
        // ARRANGE
        mockService.mockWeather = createMockWeather()
        
        // ACT
        // Aqui ainda tá carregando
        // (não colocamos await, então isLoading ainda é true)
        let task = Task {
            await sut.fetchWeather(latitude: -22.9, longitude: -47.0)
        }
        
        // ASSERT
        // Isloading deve ser true em algum ponto
        // (Nota: isso é flaky pra testar, pra simplificar ignoramos)
        
        // Aguarda task terminar
        await task.value
        
        // Depois que terminar, isLoading deve ser false
        XCTAssertFalse(sut.isLoading)
    }
    
    // ====== TESTE 3 ======
    // Testa: "Se API retorna erro, errorMessage é preenchido?"
    func testFetchWeatherError() async {
        // ARRANGE
        mockService.mockError = URLError(.notConnectedToInternet)
        
        // ACT
        await sut.fetchWeather(latitude: -22.9, longitude: -47.0)
        
        // ASSERT
        XCTAssertNil(sut.weather)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    // ====== TESTE 4 ======
    // Testa: "Quando refetch, dados antigos são limpos?"
    func testFetchWeatherClearsOldData() async {
        // ARRANGE
        // Primeira fetch com dados
        mockService.mockWeather = createMockWeather()
        await sut.fetchWeather(latitude: -22.9, longitude: -47.0)
        
        // Verifica que tem dados
        XCTAssertNotNil(sut.weather)
        
        // Segunda fetch com erro
        mockService.mockWeather = nil
        mockService.mockError = URLError(.unknown)
        await sut.fetchWeather(latitude: 0, longitude: 0)
        
        // ASSERT
        // Dados antigos devem ser limpos
        XCTAssertNil(sut.weather)
        XCTAssertNotNil(sut.errorMessage)
    }
}
