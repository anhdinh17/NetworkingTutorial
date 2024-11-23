//
//  NetworkingTutorialApp.swift
//  NetworkingTutorial
//
//  Created by Anh Dinh on 11/22/24.
//

import SwiftUI

@main
struct NetworkingTutorialApp: App {
    var body: some Scene {
        WindowGroup {
            let service = CoinDataService()
            ContentView(service: service)
        }
    }
}
