//
//  HTTPDataDownloader.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/23/24.
//

import Foundation

protocol HTTPDataDownloader {
    func fetchData<T: Decodable>(as type: T.Type, endpoint: String) async throws -> T
}

// Default implementation of fetchData() of Protocol
extension HTTPDataDownloader {
    func fetchData<T: Decodable>(as type: T.Type, endpoint: String) async throws -> T {
        guard let url = URL(string: endpoint) else {
            throw CoinAPIError.requestFailed(description: "Invalid URL")
        }
        
        let (data, response) =  try await URLSession.shared.data(from: url)
        
        // Throw is like return
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CoinAPIError.requestFailed(description: "Request Failed")
        }
        
        guard httpResponse.statusCode == 200 else {
            throw CoinAPIError.invalidStatusCode(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(type.self, from: data)
        } catch {
            print("DEBUG: Error in fetCoins in Service: \(error.localizedDescription)")
            // Cach nay cung hay
            // danh cho other errors that are not thrown above.
            throw error as? CoinAPIError ?? .unknownError(error: error)
        }
    }
}
