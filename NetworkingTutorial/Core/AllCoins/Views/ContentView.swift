//
//  ContentView.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/22/24.
//

import SwiftUI

struct ContentView: View {
    let service: CoinServiceProtocol
    @StateObject var viewModel: CoinsViewModel
    
    init(service: CoinServiceProtocol) {
        self.service = service
        self._viewModel = StateObject(wrappedValue: CoinsViewModel(service: service))
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.coins) { coin in
                    NavigationLink(value: coin) {
                        HStack(spacing: 12) {
                            Text("\(coin.marketCapRank)")
                                .foregroundStyle(.gray)
                            
                            CoinImageView(url: coin.image)
                                .frame(width: 32, height: 32)

                            VStack(alignment: .leading) {
                                Text(coin.name)
                                    .fontWeight(.semibold)
                                
                                Text(coin.symbol.uppercased())
                            }
                        }
                        // Pagination
                        .onAppear {
                            // When this HStack(cell/row) appears AND it's the last element of
                            // array, then we want to fetch another junks of coins
                            if coin == viewModel.coins.last {
                                // Trigger pagination
                                print("DEBUG: Trigger pagination")
                                Task { await viewModel.fetchCoins() }
                            }
                        }
                        .font(.footnote)
                    }
                }
            }
            .navigationDestination(for: Coin.self) { coin in
                CoinDetailView(service: service, coin: coin)
            }
            .overlay {
                if let errorText = viewModel.errorMessage {
                    Text("Error: \(errorText)")
                }
            }
        }
        
        /** IMPORTANT */
        // At first, we call this fetchCoins() inside ContentVM's init
        // But for better performance, we should put it here to avoid complex inside an init
        // and sometimes it may run twice inside of viewModel's init (which hasn't happened to me yet).
        //
        // And we HAVE TO put it under NavStack, if we put it under List, it will keep fetching data every time
        // List appear. For example, if we go to next screen and go back, List will run this .task again.
        .task {
            Task { await viewModel.fetchCoins() }
        }
    }
}

#Preview {
    ContentView(service: MockCoinService())
}
