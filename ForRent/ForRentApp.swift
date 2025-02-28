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
    @State private var authenticationVM = AuthenticationVM.shared
    @State private var userVM = UserVM.shared
    
    init() {
        FirebaseApp.configure()
//        authenticationVM.signOut {}
        userVM.fetchUserInfo { _ in }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authenticationVM)
                .environment(userVM)
        }
    }
}
