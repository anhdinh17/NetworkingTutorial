//
//  ContentViewModel.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/22/24.
//

import Foundation

class CoinsViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    @Published var errorMessage: String?
    
    private let service = CoinDataService()
    
    init() {
        Task { await fetchCoins() }
    }
    
    @MainActor
    func fetchCoins() async {
        // We don't mark this func "throws" because
        // we already handle error in do-catch.
        // This func itself doesn't throw any errors.
        do {
            self.coins = try await service.fetchCoins()
        } catch {
            // I think error thrown from fetchCoins() are CoinAPIError
            // so we can cast it as CoinAPIError
            guard let error = error as? CoinAPIError else { return }
            self.errorMessage = error.customDescription
        }
    }
}

//MARK: - COMPLETION HANDLER
extension CoinsViewModel {
    func fetchCoinsWithCompletionHandler() {
        service.fetchCoinsWithResult(completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let coins):
                    self.coins = coins
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        })
    }
}
