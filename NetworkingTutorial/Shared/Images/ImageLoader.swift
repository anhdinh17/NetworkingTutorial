//
//  ImageLoader.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/24/24.
//

import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: Image?
    
    private let urlString: String
    
    init( urlString: String) {
        self.urlString = urlString
        Task { await loadImage() }
    }
    
    @MainActor
    private func loadImage() async {
        // Check if image is in Cache
        if let cached = ImageCache.shared.get(forKey: urlString) {
            self.image = Image(uiImage: cached)
            return // Stop the func, we don't fetch image anymore
        }
        
        // Keep going and fetch image
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let uiImage = UIImage(data: data) else { return }
            
            // Set the image into Cache for reuse
            ImageCache.shared.set(uiImage, forKey: urlString)
            
            self.image = Image(uiImage: uiImage)
        } catch {
            print("DEBUG: Failed to fetch image with error: \(error.localizedDescription)")
        }
    }
}
