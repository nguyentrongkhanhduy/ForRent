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
    @State private var showSearchTab = false
    
    @State private var desiredPrice = ""
    @State private var selectedArea = ""
    @State private var selectedBath = ""
    @State private var selectedBed = ""
    @State private var selectedGuest = ""
    @State private var selectedDate = Date()
    
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
    
    private func filterListProperty() {
        print(propertyVM
            .getFilteredProperties(
                price: desiredPrice,
                bath: String(selectedBath.prefix(1)),
                bed: String(selectedBed.prefix(1)),
                guest: String(selectedGuest.prefix(1)),
                date: selectedDate
            ))
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                ListPropertyView()
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
            .sheet(isPresented: $showSearchTab) {
                FilterView(
                    desiredPrice: $desiredPrice,
                    selectedArea: $selectedArea,
                    selectedBed: $selectedBed,
                    selectedBath: $selectedBath,
                    selectedGuest: $selectedGuest,
                    selectedDate: $selectedDate
                ) {
                    showSearchTab = false
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
