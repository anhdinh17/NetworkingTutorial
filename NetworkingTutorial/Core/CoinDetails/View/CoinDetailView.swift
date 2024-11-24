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
                    HStack {
                        VStack {
                            Text(details.name)
                                .fontWeight(.semibold)
                                .font(.subheadline)
                            
                            Text(details.symbol.uppercased())
                                .font(.footnote)
                        }
                        
                        Spacer()
                        
                        // If we already fetch image in List
                        // when we go this screen, the image is fetched from Cache
                        // Leave a print in ImageLoader and we'll see it.
                        CoinImageView(url: coin.image)
                            .frame(width: 32, height: 32)
                    }
                    
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
    CoinDetailView(service: MockCoinService(),
                   coin: Coin(name: "Bitcoin", id: "Bitcoin", symbol: "BTC", currentPrice: 123456, marketCapRank: 1, image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400"))
}
