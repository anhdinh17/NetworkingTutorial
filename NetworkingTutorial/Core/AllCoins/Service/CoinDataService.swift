//
//  CoinDataService.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/22/24.
//

import Foundation

class CoinDataService {
    
    let BASE_URL = "https://api.coingecko.com/api/v3/coins/"
    
    var urlString: String {
        return  "\(BASE_URL)markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&price_change_percentage=24h&lockable=en"
    }
    
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
}

//MARK: - Completion Handler
extension CoinDataService {
    func fetchCoinsWithResult(completion: @escaping (Result<[Coin], CoinAPIError>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
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
