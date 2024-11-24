//
//  MockCoinService.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/23/24.
//

import Foundation

class MockCoinService: CoinServiceProtocol {
    // Set the mockData we want
    var mockData: Data?
    // Set the error (Unit Test)
    var mockError: CoinAPIError?
    
    func fetchCoins() async throws -> [Coin] {
        if let mockError { throw mockError }
        
        do {
            // If there's no mockData, we use mockCoinData_marketCapDesc
            let coins = try JSONDecoder().decode([Coin].self, from: mockData ?? mockCoinData_marketCapDesc)
            return coins
        } catch {
            // We have to throw a CoinAPIError
            // because in CoinViewModel, when call fetchCoins(),
            // we catch an error as CoinAPIError. If we just throw error without casting it down,
            // it will fail when we do Unit Testing.
            throw error as? CoinAPIError ?? .unknownError(error: error)
        }
    }
    
    func fetchCoinDetails(id: String) async throws -> CoinDetails? {
        let detail = CoinDetails(id: "BTC", name: "BITCOIN", symbol: "BTC", description: Description(text: "Test Description"))
        return detail
    }
}
