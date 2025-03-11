//
//  ContentView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-21.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthenticationVM.self) var authenticationVM
    @Environment(UserVM.self) var userVM
    @Environment(PropertyVM.self) var propertyVM
    @Environment(LocationVM.self) var locationVM
    
    @State private var selectedTab = 0
    @AppStorage("currentRole") private var currentRole = "Guest"
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                if !authenticationVM.isLoggedIn || currentRole == "Guest" {
                    ListPropertyView(tab: $selectedTab)
                        .tabItem {
                            Label("Explore", systemImage: "magnifyingglass")
                        }
                        .tag(0)
                    
                    
                    WishlistView(tab: $selectedTab)
                        .tabItem {
                            Label("Wishlist", systemImage: "heart")
                        }
                        .tag(1)
                } else {
                    ListingView(tab: $selectedTab)
                        .tabItem {
                            Label("Listing", systemImage: "house")
                        }
                        .tag(4)
                }
                
                MessageView(tab: $selectedTab)
                    .tabItem {
                        Label("Messages", systemImage: "message")
                    }
                    .tag(2)
                
                ProfileView(tab: $selectedTab)
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                    .tag(3)
            }
            .tint(Color(Constant.Color.primaryColor))
        }
        .accentColor(Color(Constant.Color.primaryText))
    }
}

#Preview {
    ContentView()
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
        .environment(PropertyVM.shared)
        .environment(LocationVM.shared)
        .environment(RequestVM.shared)
}
