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
    
    private var toolBarTitle: String {
        switch selectedTab {
        case 0:
            ""
        case 1:
            "Wishlist"
        case 2:
            "Messages"
        case 3:
            "Profile"
        default:
            ""
        }
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                ListPropertyView(tab: self.$selectedTab)
                    .tabItem {
                        Label("Explore", systemImage: "magnifyingglass")
                    }
                    .tag(0)
                
                WishlistView(tab: self.$selectedTab)
                    .tabItem {
                        Label("Wishlist", systemImage: "heart")
                    }
                    .tag(1)
                
                MessageView(tab: self.$selectedTab)
                    .tabItem {
                        Label("Messages", systemImage: "message")
                    }
                    .tag(2)
                
                ProfileView(tab: self.$selectedTab)
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                    .tag(3)
            }//End of TabView
            .background(.white)
            .tint(Color(Constant.Color.primaryColor))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(self.toolBarTitle)
                        .font(.custom(Constant.Font.semiBold, size: 30))
                        .foregroundStyle(Color(Constant.Color.primaryText))
                }
            }
        }//End of NavStack
        .accentColor(Color(Constant.Color.primaryText))
    }//End of body
}

#Preview {
    ContentView()
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
        .environment(PropertyVM.shared)
        .environment(LocationVM.shared)
}
