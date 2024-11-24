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
            // Injection starts here
            ContentView(service: MockCoinService())
        }
    }
}
