//
//  ListPropertyView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-01.
//

import SwiftUI

struct ListPropertyView: View {
    @Environment(AuthenticationVM.self) var authenticationVM
    @Environment(UserVM.self) var userVM
    @Environment(PropertyVM.self) var propertyVM
    @Environment(LocationVM.self) var locationVM
    
    @State private var showMap = false
    @State private var showDetailView = false
    @State private var selectedProperty: Property?
    @State private var showSearchTab = false
    @State private var filterCriteria = FilterCriteria()
    @State private var showLoginAlert = false
    @State private var toLogin = false
    
    @Binding var tab: Int
    
    private func performAddToWishList(property: Property) {
        if authenticationVM.isLoggedIn {
            guard let propId = property.id else {
                print("Error adding to wishlist")
                return
            }
            userVM
                .addOrRemoveToWishList(
                    userId: authenticationVM.userID,
                    propertyId: propId)
        } else {
            showLoginAlert = true
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    SearchBar()
                        .onTapGesture {
                            showSearchTab = true
                        }
                    
                    List {
                        ForEach(
                            propertyVM
                                .getFilteredProperties(
                                    price: filterCriteria.desiredPrice,
                                    bath: filterCriteria.selectedBath,
                                    bed: filterCriteria.selectedBed,
                                    guest: filterCriteria.selectedGuest,
                                    date: filterCriteria.selectedDate
                                ),
                            id: \.self
                        ) { property in
                            ListItem(property: property) {
                                performAddToWishList(property: property)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .padding(.bottom, 10)
                            .onTapGesture {
                                showDetailView = true
                                selectedProperty = property
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(.bottom)
                }
                
                VStack {
                    Spacer()
                    MapButton {
                        showMap = true
                    }
                    .padding(.bottom, 25)
                }
            }// end of zstack
            .fullScreenCover(
                isPresented: $showMap,
                content: {
                    ExploreView(
                        tab: $tab,
                        filterCriteria: $filterCriteria
                    )
                })
            .sheet(isPresented: $showSearchTab) {
                FilterView(filterCriteria: $filterCriteria) {
                    showSearchTab = false
                }
            }
            .navigationDestination(isPresented: $showDetailView) {
                if let property = selectedProperty {
                    PropertyDetailView(property: property, tab: $tab)
                }
            }
            .navigationDestination(isPresented: $toLogin, destination: {
                LoginView(tab: $tab)
            })
            .alert("Action Requires an Account", isPresented: $showLoginAlert) {
                Button("Log In") {
                    toLogin = true
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("You need to have an account to perform this action. Please log in or sign up.")
            }
        }// end of navstack
        
    }
}

#Preview {
    @Previewable @State var test = 1
    ListPropertyView(tab: $test)
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
        .environment(PropertyVM.shared)
        .environment(LocationVM.shared)
}
