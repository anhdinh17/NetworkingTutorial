//
//  CoinDetailView.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/22/24.
//

import SwiftUI

struct CoinDetailView: View {
    @StateObject var viewModel: CoinDetailViewModel
    let coin: Coin
    
    // Dependency Injection
    init(service: CoinServiceProtocol, coin: Coin) {
        self.coin = coin
        self._viewModel = StateObject(wrappedValue: CoinDetailViewModel(service: service,
                                                                        coinId: coin.id))
    }
    
    var body: some View {
        ScrollView {
            if let details = viewModel.coinDetail {
                LazyVStack(alignment: .leading) {
                    Text(details.name)
                        .fontWeight(.semibold)
                        .font(.subheadline)
                    
                    Text(details.symbol.uppercased())
                        .font(.footnote)
                    
                    Text(details.description.text)
                }
                .padding()
            }
        }
        .task {
            await viewModel.fetchCoinDetails()
        }
    }
}

#Preview {
    CoinDetailView(service: CoinDataService(),
                   coin: Coin(name: "Bitcoin", id: "Bitcoin", symbol: "BTC", currentPrice: 123456, marketCapRank: 1))
}
