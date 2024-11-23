//
//  CoinDetails.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/22/24.
//

import Foundation

struct CoinDetails: Codable {
    let id: String
    let name: String
    let symbol: String
    let description: Description
}

struct Description: Codable {
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case text = "en"
    }
}
