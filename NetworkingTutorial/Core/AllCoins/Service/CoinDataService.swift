//
//  CoinDataService.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/22/24.
//

import Foundation

class CoinDataService: HTTPDataDownloader {
    func fetchCoins() async throws -> [Coin] {
        guard let endpoint = allCoinsURLString else {
            throw CoinAPIError.requestFailed(description: "Invalid URL")
        }
        return try await fetchData(as: [Coin].self, endpoint: endpoint)
    }
    
    func fetchCoinDetails(id: String) async throws -> CoinDetails? {
        guard let endpoint = coinDetailsURLString(id: id) else {
            throw CoinAPIError.requestFailed(description: "Invalid URL")
        }
        return try await fetchData(as: CoinDetails.self, endpoint: endpoint)
    }
    
    // URL COMPONENTS
    private var baseUrlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coingecko.com"
        components.path = "/api/v3/coins/"
        return components
    }
    
    private var allCoinsURLString: String? {
        var components = baseUrlComponents
        components.path += "markets"
        // What comes after "?"
        components.queryItems = [
            .init(name: "vs_currency", value: "usd"),
            .init(name: "order", value: "market_cap_desc"),
            .init(name: "per_page", value: "20"),
            .init(name: "page", value: "1"),
            .init(name: "price_change_percentage", value: "24h")
        ]
        return components.url?.absoluteString
    }
    // Those 2 properties above will give this:
    // "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&price_change_percentage=24h"
    
    private func coinDetailsURLString(id: String) -> String? {
        var components = baseUrlComponents
        components.path += "\(id)"
        components.queryItems = [
            .init(name: "localization", value: "false")
        ]
        return components.url?.absoluteString
    }
    
    /* ORIGINAL NETWORKING FUNCS, we replace them by using protocol */
    /*
     
     func fetchCoins() async throws -> [Coin] {
         guard let url = URL(string: urlString) else {
             return []
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
             let coins = try JSONDecoder().decode([Coin].self, from: data)
             return coins
         } catch {
             print("DEBUG: Error in fetCoins in Service: \(error.localizedDescription)")
             // Cach nay cung hay
             // danh cho other errors that are not thrown above.
             throw error as? CoinAPIError ?? .unknownError(error: error)
         }
     }
     
     func fetchCoinDetails(id: String) async throws -> CoinDetails? {
         let detailUrlString = "https://api.coingecko.com/api/v3/coins/\(id)?localization=false"
         
         guard let url = URL(string: detailUrlString) else {
             return nil
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
             let coinDetails = try JSONDecoder().decode(CoinDetails.self, from: data)
             return coinDetails
         } catch {
             print("DEBUG: Error in fetCoins in Service: \(error.localizedDescription)")
             // Cach nay cung hay
             // danh cho other errors that are not thrown above.
             throw error as? CoinAPIError ?? .unknownError(error: error)
         }
     }
    
     */
    
}

//MARK: - Completion Handler
extension CoinDataService {
    func fetchCoinsWithResult(completion: @escaping (Result<[Coin], CoinAPIError>) -> Void) {
        guard let url = URL(string: allCoinsURLString ?? "") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(CoinAPIError.unknownError(error: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "Request Failed")))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                completion(.success(coins))
            } catch {
                print("DEBUG: Failed to decode with error: \(error.localizedDescription)")
                completion(.failure(.jsonParsingFailure))
            }
        }.resume()
    }
}
