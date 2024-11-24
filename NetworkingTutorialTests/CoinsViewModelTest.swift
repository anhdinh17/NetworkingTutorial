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
        
    }
    
    func testCoinFetchWithInvalidJSON() async {
        
    }
    
    func throwsInvalidDataError() async {
        
    }
}
