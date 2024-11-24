//
//  CoinDataService.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/22/24.
//

import Foundation

/** ---NOTE---
 - Use this protocol for Dependency Injection
 - Any class conforms to this protocol can be injected.
 */
protocol CoinServiceProtocol {
    func fetchCoins() async throws -> [Coin]
    func fetchCoinDetails(id: String) async throws -> CoinDetails?
}

class CoinDataService: CoinServiceProtocol, HTTPDataDownloader {
    
    // These 2 for pagination
    // when we finish scrolling to page 1, tell API that
    // "Hey, go to page 2 and get another 20 coins"
    private var page = 0
    private let fetchLimit = 30
    
    func fetchCoins() async throws -> [Coin] {
        page += 1
        
        guard let endpoint = allCoinsURLString else {
            throw CoinAPIError.requestFailed(description: "Invalid URL")
        }
        
        // Access protocol HTTPDataDownloader default implementation.
        // fetchData() throws error but we don't catch them here,
        // we propagate them to the func who calls this fetchCoins() to catch.
        // In this case, it's CoisViewModel.fetchCoins()
        return try await fetchData(as: [Coin].self, endpoint: endpoint)
    }
    
    func fetchCoinDetails(id: String) async throws -> CoinDetails? {
        // Check if we have data in cache
        if let cached = CoinDetailsCache.shared.get(forKey: id) {
            // If there's already data in cache, then return it
            // and stop this function
            print("Got details from CACHE")
            return cached
        }
        
        // Keep going to fetch data if there's nothing in cache
        guard let endpoint = coinDetailsURLString(id: id) else {
            throw CoinAPIError.requestFailed(description: "Invalid URL")
        }
        
        // Store CoinDetails in cache so we can reuse it next time we come to Detail screen
        let details = try await fetchData(as: CoinDetails.self, endpoint: endpoint)
        print("Got details from API")
        CoinDetailsCache.shared.set(details, forKey: id)
        
        return details
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
            .init(name: "per_page", value: "\(fetchLimit)"),
            .init(name: "page", value: "\(page)"),
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
