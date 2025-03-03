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
    
    @State private var desiredPrice = ""
    @State private var selectedArea = ""
    @State private var selectedBath = ""
    @State private var selectedBed = ""
    @State private var selectedGuest = ""
    @State private var selectedDate = Date()
    
    
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
                                    price: desiredPrice,
                                    bath: selectedBath,
                                    bed: selectedBed,
                                    guest: selectedGuest,
                                    date: selectedDate
                                ),
                            id: \.self
                        ) { property in
                            ListItem(property: property) {
                                print(property.title)
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
                    .padding(.bottom,40)
                }
            }// end of zstack
            .sheet(isPresented: $showMap) {
                ExploreView(filterArea: selectedArea)
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
            .navigationDestination(isPresented: $showDetailView) {
                if let property = selectedProperty {
                    PropertyDetailView(property: property)
                }
            }
            .toolbarBackground(.white, for: .tabBar)
        }// end of navstack
        
    }
}

#Preview {
    ListPropertyView()
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
        .environment(PropertyVM.shared)
        .environment(LocationVM.shared)
}
