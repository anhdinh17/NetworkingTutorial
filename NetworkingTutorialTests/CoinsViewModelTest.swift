//
//  CoinsViewModelTest.swift
//  NetworkingTutorialTests
//
//  Created by Anh Dinh on 11/24/24.
//

import XCTest
@testable import NetworkingTutorial

/* NOTES */
// We gonna test view models and its functions.
class CoinsViewModelTest: XCTestCase {
    
    // Test initialization of viewModel
    // We want to see if we can init a viewModel
    func testInit() {
        let service = MockCoinService()
        let viewModel = CoinsViewModel(service: service)
        
        // if this fails, the text will show.
        XCTAssertNotNil(viewModel, "The view model should not be nil")
    }
    
    func testSuccessFullCoinsFetch() async {
        // We don't want to use the service that fetches real API
        let service = MockCoinService()
        let viewModel = CoinsViewModel(service: service)
        
        await viewModel.fetchCoins()
        XCTAssertTrue(viewModel.coins.count > 0)
        XCTAssertEqual(viewModel.coins.count, 20)
        XCTAssertEqual(viewModel.coins, viewModel.coins.sorted(by: { $0.marketCapRank < $1.marketCapRank }))
    }
    
    // Test with invalid data to see if we can catch errors.
    func testCoinFetchWithInvalidJSON() async {
        let service = MockCoinService()
        service.mockData = mockCoins_invalidJSON
        
        let viewModel = CoinsViewModel(service: service)
        await viewModel.fetchCoins()
        
        // errorMessage is not Nil meaning there's an error,
        // and that's what we want.
        XCTAssertTrue(viewModel.coins.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func testThrowsInvalidDataError() async {
        let service = MockCoinService()
        // Set error
        service.mockError = CoinAPIError.invalidStatusCode(statusCode: 404)
        
        let viewModel = CoinsViewModel(service: service)
        await viewModel.fetchCoins()
        
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, CoinAPIError.invalidStatusCode(statusCode: 404).customDescription)
    }
}
