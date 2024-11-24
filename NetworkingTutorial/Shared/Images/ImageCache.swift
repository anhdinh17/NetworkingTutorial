//
//  ImageCache.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/24/24.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    // Optional because we may or may not have image in Cache
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
