//
//  ContentView.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/22/24.
//

import SwiftUI

struct ContentView: View {
    let service: CoinDataService
    @StateObject var viewModel: CoinsViewModel
    
    init(service: CoinDataService) {
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
                            
                            VStack(alignment: .leading) {
                                Text(coin.name)
                                    .fontWeight(.semibold)
                                
                                Text(coin.symbol.uppercased())
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
    }
}

#Preview {
    ContentView(service: CoinDataService())
}
