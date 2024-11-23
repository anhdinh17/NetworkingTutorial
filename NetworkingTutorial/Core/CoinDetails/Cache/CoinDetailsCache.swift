//
//  CoinDetailsCache.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/23/24.
//

import Foundation

class CoinDetailsCache {
    static let shared = CoinDetailsCache()
    
    // Initialize a cache
    // this guy uses NSString and NSData
    private let cache = NSCache<NSString, NSData>()
    
    private init() {}
    
    // Set data into Cache
    func set(_ coinDetails: CoinDetails, forKey key: String) {
        guard let data = try? JSONEncoder().encode(coinDetails) else { return }
        cache.setObject(data as NSData, forKey: key as NSString)
    }
    
    // Get data from Cache
    func get(forKey key: String) -> CoinDetails? {
        // Cast down to Data cause cache uses NSData and NSString
        guard let data = cache.object(forKey: key as NSString) as? Data else { return nil }
        // Decode data into CoinDetails.
        return try? JSONDecoder().decode(CoinDetails.self, from: data)
    }
}
