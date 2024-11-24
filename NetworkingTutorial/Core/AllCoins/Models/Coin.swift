//
//  Coin.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/22/24.
//

import Foundation

struct Coin: Codable, Identifiable, Hashable {
    let name: String
    let id: String
    let symbol: String
    let currentPrice: Double
    let marketCapRank: Int
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image // No need to fix these cause they match what on JSON.
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
    }
}
