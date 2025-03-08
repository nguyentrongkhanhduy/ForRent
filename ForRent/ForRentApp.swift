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
    @State private var propertyVM = PropertyVM.shared
    @State private var locationVM = LocationVM.shared
    @State private var requestVM = RequestVM.shared
    
    init() {
        FirebaseApp.configure()
//        authenticationVM.signOut {}
        userVM.fetchUserInfo { _ in }
        propertyVM.fetchAllProperty()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authenticationVM)
                .environment(userVM)
                .environment(propertyVM)
                .environment(locationVM)
                .environment(requestVM)
        }
    }
}
