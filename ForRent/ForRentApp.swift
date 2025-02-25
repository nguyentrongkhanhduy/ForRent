//
//  ForRentApp.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-21.
//

import SwiftUI
import FirebaseCore

@main
struct ForRentApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(AuthenticationVM.shared)
        }
    }
}
