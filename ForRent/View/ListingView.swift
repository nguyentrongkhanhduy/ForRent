//
//  ListingView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-08.
//

import SwiftUI
import FirebaseFirestore

struct ListingView: View {
    @Environment(AuthenticationVM.self) var authenticationVM
    @Environment(PropertyVM.self) var propertyVM
    @Binding var tab: Int
    
    @State private var showDetailView = false
    @State private var selectedProperty: Property?
    @State private var isAddingNew = false
    @State private var showLoginAlert = false
    @State private var toLogin = false

    // New state for filtering listed vs. delisted properties
    @State private var isShowingListed: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                
                HStack {
                    Text("Your Listings")
                        .font(.custom(Constant.Font.semiBold, size: 30))
                        .foregroundStyle(Color(Constant.Color.primaryText))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    Button {
                        isAddingNew = true
                    } label: {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                    .padding()
                }

                // Toggle filter between Listed & Delisted properties
                Picker("Filter", selection: $isShowingListed) {
                    Text("Listed").tag(true)
                    Text("Delisted").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                List {
                    // Correct filtering for Listed and Delisted properties
                    ForEach(
                        propertyVM.listProperty
                            .filter { $0.ownerId == authenticationVM.userID && $0.isDelisted == !isShowingListed },
                        id: \.self
                    ) { property in
                        ListItem(property: property) {
                            // Optional: add host-specific actions here.
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding(.bottom, 10)
                        .onTapGesture {
                            selectedProperty = property
                            showDetailView = true
                        }
                    }
                }
                .padding(.bottom)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            
            .navigationDestination(isPresented: $isAddingNew) {
                // Create a new property with default values.
                PropertyEditView(
                    property: Property(
                        ownerId: authenticationVM.userID,
                        title: "",
                        bedroom: 0,
                        bathroom: 0,
                        guest: 1,
                        description: "",
                        imgURL: "",
                        isAvailable: true,
                        isDelisted: false,
                        price: 0.0,
                        coordinate: FirebaseFirestore.GeoPoint(latitude: 0.0, longitude: 0.0),
                        dateAdded: Date(),
                        dateUpdated: Date(),
                        dateAvailable: Date()
                    ),
                    isEditing: false
                )
            }
            .navigationDestination(isPresented: $showDetailView) {
                if let property = selectedProperty {
                    PropertyDetailView(property: property, tab: $tab)
                }
            }
            .navigationDestination(isPresented: $toLogin) {
                LoginView(tab: $tab)
            }
        }
    }
}

//#Preview {
//    @Previewable @State var test = 1
//    ListingView(tab: $test)
//        .environment(AuthenticationVM.shared)
//        .environment(UserVM.shared)
//        .environment(PropertyVM.shared)
//        .environment(LocationVM.shared)
//        .environment(RequestVM.shared)
//}
