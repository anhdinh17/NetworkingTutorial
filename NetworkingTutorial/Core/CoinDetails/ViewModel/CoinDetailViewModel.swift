//
//  CoinDetailViewModel.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/22/24.
//

import Foundation

class CoinDetailViewModel: ObservableObject {
    @Published var coinDetail: CoinDetails?
    
    private let coinId: String
    private let service: CoinServiceProtocol
    
    init(service: CoinServiceProtocol, coinId: String) {
        self.service = service
        self.coinId = coinId
        
        /// Important:
        /// if we do Task here, when we move away from CoinDeailView screen
        /// this Task still happening meaning it still fetches data.
        /// We should use .task in CoinDetailView
        //Task { await fetchCoinDetails() }
    }
    
    @MainActor
    func fetchCoinDetails() async {
        do {
            let details = try await service.fetchCoinDetails(id: coinId)
            self.coinDetail = details
        } catch {
            print("DEBUG: Fail to fetch coin details \(error.localizedDescription)")
        }
    }
}
