//
//  MockCoinService.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/23/24.
//

import Foundation

class MockCoinService: CoinServiceProtocol {
    func fetchCoins() async throws -> [Coin] {
        let bitcoin = Coin(name: "BITCOIN", id: "Bitcoin", symbol: "BTC", currentPrice: 123456, marketCapRank: 1)
        return [bitcoin]
    }
    
    func fetchCoinDetails(id: String) async throws -> CoinDetails? {
        let detail = CoinDetails(id: "BTC", name: "BITCOIN", symbol: "BTC", description: Description(text: "Test Description"))
        return detail
    }
}
