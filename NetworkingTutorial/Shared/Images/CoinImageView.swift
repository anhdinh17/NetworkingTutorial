//
//  CoinImageView.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/24/24.
//

import SwiftUI

struct CoinImageView: View {
    @StateObject var imageLoader: ImageLoader
    
    init(url: String) {
        self._imageLoader = StateObject(wrappedValue: ImageLoader(urlString: url))
    }
    
    var body: some View {
        if let image = imageLoader.image {
            image
                .resizable()
        }
    }
}

//#Preview {
//    CoinImageView()
//}
