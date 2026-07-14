//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Gabriel Amaral on 14/07/26.
//

import XCTest
@testable import WeatherApp

@MainActor
final class WeatherServiceTests: XCTestCase {
    
    var sut: WeatherService!
    
    var mockSession: MockURLSession!
    
    // Roda ANTES de cada teste (setup)
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        sut = WeatherService(session: mockSession as URLSessionProtocol)
    }
    
    // Roda DEPOIS de cada teste (cleanup)
    override func tearDown() {
        super.tearDown()
        sut = nil
        mockSession = nil
    }
    
    // ====== TESTE 1 ======
    // Testa: "Se API retorna JSON válido, conseguimos decodificar?"
    func testFetchWeatherSuccess() async throws {
        // ARRANGE (preparar)
        // Programamos o mock pra retornar JSON válido
        mockSession.mockData = MockData.validWeatherJSON
        
        // ACT (agir/executar)
        // Chamamos a função que estamos testando
        let result = try await sut.fetchWeather(latitude: -22.9, longitude: -47.0)
        
        // ASSERT (validar resultado)
        // Verificamos que temos os dados esperados
        XCTAssertEqual(result.latitude, -22.9)
        XCTAssertEqual(result.longitude, -47.0)
        XCTAssertEqual(result.current.temperature, 25.5)
        XCTAssertEqual(result.current.humidity, 60)
        
        // Verificamos que o mock foi realmente chamado
        XCTAssertEqual(mockSession.callCount, 1)
    }
    
    // ====== TESTE 2 ======
    // Testa: "Se API retorna JSON inválido, lança erro?"
    func testFetchWeatherDecodingError() async {
        // ARRANGE
        mockSession.mockData = MockData.invalidJSON
        
        // ACT & ASSERT
        // Esperamos que lance erro
        do {
            _ = try await sut.fetchWeather(latitude: -22.9, longitude: -47.0)
            
            // Se chegou aqui, significado que NÃO lançou erro
            // Isso é ruim! O teste falha
            XCTFail("Deveria ter lançado erro ao decodificar JSON inválido")
            
        } catch {
            // Se lançou erro, é o esperado ✅
            XCTAssertNotNil(error)
        }
    }
    
    // ====== TESTE 3 ======
    // Testa: "Se internet cai, lança erro?"
    func testFetchWeatherNetworkError() async {
        // ARRANGE
        // Programamos o mock pra lançar erro de rede
        mockSession.mockError = URLError(.notConnectedToInternet)
        
        // ACT & ASSERT
        do {
            _ = try await sut.fetchWeather(latitude: -22.9, longitude: -47.0)
            XCTFail("Deveria ter lançado erro de rede")
        } catch let error as URLError {
            // Verificamos que é um erro de URL
            XCTAssertEqual(error.code, .notConnectedToInternet)
        } catch {
            XCTFail("Erro tipo errado: \(error)")
        }
    }
    
    // ====== TESTE 4 ======
    // Testa: "Método fetchWeatherByCity funciona com cidades conhecidas?"
    func testFetchWeatherByCitySuccess() async throws {
        // ARRANGE
        mockSession.mockData = MockData.validWeatherJSON
        
        // ACT
        let result = try await sut.fetchWeatherByCity("campinas")
        
        // ASSERT
        XCTAssertEqual(result.latitude, -22.9)
        XCTAssertEqual(mockSession.callCount, 1)
    }
    
    // ====== TESTE 5 ======
    // Testa: "Método fetchWeatherByCity lança erro pra cidades desconhecidas?"
    func testFetchWeatherByCityNotFound() async {
        // ARRANGE
        mockSession.mockData = MockData.validWeatherJSON
        
        // ACT & ASSERT
        do {
            _ = try await sut.fetchWeatherByCity("narnia")
            XCTFail("Deveria ter lançado cityNotFound")
        } catch let error as WeatherError {
            XCTAssertEqual(error as? WeatherError, .cityNotFound)
        } catch {
            XCTFail("Erro tipo errado")
        }
    }
}
