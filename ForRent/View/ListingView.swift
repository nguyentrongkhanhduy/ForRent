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
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Your listing")
                    .font(.custom(Constant.Font.semiBold, size: 30))
                    .foregroundStyle(Color(Constant.Color.primaryText))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                List {
                    // Filter properties so that only those owned by the current user (host) are shown.
                    ForEach(
                        propertyVM.listProperty.filter { $0.ownerId == authenticationVM.userID },
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
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            
            
            
            
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        isAddingNew = true
//                    } label: {
//                        Image(systemName: "plus")
//                    }
//                }
//            }
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

#Preview {
    @Previewable @State var test = 1
    ListingView(tab: $test)
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
        .environment(PropertyVM.shared)
        .environment(LocationVM.shared)
        .environment(RequestVM.shared)
}
