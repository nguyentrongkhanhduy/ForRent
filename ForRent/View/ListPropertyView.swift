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
                    .padding(.bottom, 40)
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
                ExploreView(filterArea: filterCriteria.selectedArea)
            }
            .sheet(isPresented: $showSearchTab) {
                FilterView(filterCriteria: $filterCriteria) {
                    showSearchTab = false
                }
            }
            .navigationDestination(isPresented: $showDetailView) {
                if let property = selectedProperty {
                    PropertyDetailView(property: property)
                }
            }
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
