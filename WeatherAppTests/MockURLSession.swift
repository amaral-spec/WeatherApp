//
//  MockURLSession.swift
//  WeatherAppTests
//
//  Created by Gabriel Amaral on 14/07/26.
//

import Foundation
@testable import WeatherApp

class MockURLSession: URLSessionProtocol {
    
    var mockData: Data?
    var mockError: Error?
    var callCount = 0
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        callCount += 1
        
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData else {
            throw URLError(.unknown)
        }
        
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        return (data, response)
    }
}

