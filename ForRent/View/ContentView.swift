//
//  ContentView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-21.
//

import SwiftUI

struct ContentView: View {
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
    
    private func printSelectedValue(){
        print(desiredPrice)
        print(selectedArea)
        print(selectedBath)
        print(selectedBed)
        print(selectedGuest)
        print(selectedDate)
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
            .toolbarBackground(Color.white)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(self.toolBarTitle)
                        .font(.custom(Constant.Font.semiBold, size: 30))
                        .foregroundStyle(Color(Constant.Color.primaryText))
                }
                ToolbarItem(placement: .principal) {
                    if selectedTab == 0 {
                        SearchBar()
                            .padding(.top)
                            .onTapGesture {
                                print("Search")
                                showSearchTab = true
                            }
                    }
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
                    printSelectedValue()
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
