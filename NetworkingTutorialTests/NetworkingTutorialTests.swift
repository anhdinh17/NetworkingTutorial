//
//  NetworkingTutorialTests.swift
//  NetworkingTutorialTests
//
//  Created by Anh Dinh on 11/23/24.
//

/** NOTES */
// NetworkingTutorialTests and NetworkingTutorial are 2 seperate targets.
// They run seperately.
// We need to import NetworkingTutorial if we want to use anything from it.

import XCTest
@testable import NetworkingTutorial // import

final class NetworkingTutorialTests: XCTestCase {
    
    // This an example of how we want to test something.
    // This func tests if we can decode JSON into an array of [Coin]
    func test_DecodeCoinsIntoArray_marketCapDesc() throws {
        do {
            // Use mock JSON to test
            let coins = try JSONDecoder().decode([Coin].self, from: mockCoinData_marketCapDesc)
            XCTAssertTrue(coins.count > 0)
            XCTAssertEqual(coins.count, 20)
            XCTAssertEqual(coins, coins.sorted(by: { $0.marketCapRank < $1.marketCapRank }))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
}
