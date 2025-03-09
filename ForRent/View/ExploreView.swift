//
//  ExploreView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-24.
//

import SwiftUI
import MapKit

struct ExploreView: View {
    @Environment(\.dismiss) var dismiss
    
    @Environment(AuthenticationVM.self) var authenticationVM
    @Environment(UserVM.self) var userVM
    @Environment(PropertyVM.self) var propertyVM
    @Environment(LocationVM.self) var locationVM
    
    @State private var selectedProperty: Property?
    @State private var showProperty = false
    @State private var showAlert = false
    @State private var defaultCameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 43.7255, longitude: -79.4523), // Toronto
            span: MKCoordinateSpan(latitudeDelta: 0.33, longitudeDelta: 0.33)
        )
    )
    @State private var showLoginAlert = false
    @State private var toLogin = false
    @State private var showDetailView = false
    @State private var showSearchTab = false

    @Binding var tab: Int
    @Binding var filterCriteria: FilterCriteria
    
    private func performGetCurrentLocation() {
        locationVM.requestLocationPermisstion() {
            DispatchQueue.main.async {
                if !locationVM.errorMessage.isEmpty {
                    showAlert = true
                } else {
                    if let location = locationVM.userLocation {
                        defaultCameraPosition = .region(
                            MKCoordinateRegion(
                                center: location,
                                span: MKCoordinateSpan(latitudeDelta: 0.33, longitudeDelta: 0.33)
                            )
                        )
                    }
                }
            }
        }
    }
    
    func updateCameraPosition() {
        if self.filterCriteria.selectedArea.isEmpty {
            return
        }
        var curLocation = CLLocationCoordinate2D()
        switch self.filterCriteria.selectedArea {
        case "Toronto":
            curLocation = Constant.TorontoDistrict.Toronto
        case "Etobicoke":
            curLocation = Constant.TorontoDistrict.Etobicoke
        case "York":
            curLocation = Constant.TorontoDistrict.York
        case "East York":
            curLocation = Constant.TorontoDistrict.EastYork
        case "North York":
            curLocation = Constant.TorontoDistrict.NorthYork
        case "Scarborough":
            curLocation = Constant.TorontoDistrict.Scarborough
        default:
            break
        }
        defaultCameraPosition = .region(
            MKCoordinateRegion(center: curLocation, span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15))
        )
    }
    
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
                Map(position: $defaultCameraPosition) {
                    ForEach(propertyVM
                        .getFilteredProperties(
                            price: filterCriteria.desiredPrice,
                            bath: filterCriteria.selectedBath,
                            bed: filterCriteria.selectedBed,
                            guest: filterCriteria.selectedGuest,
                            date: filterCriteria.selectedDate), id: \.self) { property in
                        Annotation(
                            "Property",
                            coordinate: property.coordinate2D) {
                                CustomizedMarker(price: property.price)
                                    .onTapGesture {
                                        showProperty = true
                                        selectedProperty = property
                                    }
                            }
                    }
                    
                }
                //                .mapControls {
                //                    MapUserLocationButton()
                //                }
                .onAppear {
                    //performGetCurrentLocation() //get user permission
                    updateCameraPosition()
                }
                .onChange(
                    of: filterCriteria.selectedArea
                ) { _, _ in
                    updateCameraPosition()
                }
                .alert("Location Permission Needed", isPresented: $showAlert, actions: {
                    Button("OK", role: .cancel) { }
                }, message: {
                    Text(locationVM.errorMessage)
                })
                //            .onTapGesture {
                //                if showProperty {
                //                    showProperty = false
                //                }
                //            }
                
                VStack{
                    SearchBar()
                        .padding()
                        .onTapGesture {
                            showSearchTab = true
                        }
                    Spacer()
                }
                
                if showProperty, let property = selectedProperty {
                    VStack {
                        Spacer()
                        PopupProperty(
                            property: property) {
                                performAddToWishList(property: property)
                            } close: {
                                showProperty = false
                            }
                            .onTapGesture {
                                showDetailView = true
                            }
                            .zIndex(1)
                    }
                    
                }
            }//end of ZStack
            .navigationDestination(isPresented: $toLogin, destination: {
                LoginView(tab: $tab)
            })
            .navigationDestination(isPresented: $showDetailView, destination: {
                if let property = selectedProperty {
                    PropertyDetailView(property: property, tab: $tab)
                }
            })
            .alert("Action Requires an Account", isPresented: $showLoginAlert) {
                Button("Log In") {
                    toLogin = true
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("You need to have an account to perform this action. Please log in or sign up.")
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                            .padding(8)
                            .font(.custom(Constant.Font.semiBold, size: 16))
                            .underline()
                            .foregroundStyle(Color(Constant.Color.primaryText))
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        performGetCurrentLocation()
                    } label: {
                        Image(systemName: "location.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .padding(6)
                            .foregroundStyle(Color(Constant.Color.primaryColor))
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 2)
                                    .fill(.white)
                                    .opacity(0.7)
                                
                            )
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .sheet(isPresented: $showSearchTab) {
                FilterView(filterCriteria: $filterCriteria) {
                    showSearchTab = false
                }
            }
        }//end of Navstack
        
    }
}

#Preview {
    @Previewable @State var test = 1
    @Previewable @State var test2 = FilterCriteria()
    ExploreView(tab: $test, filterCriteria: $test2)
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
        .environment(PropertyVM.shared)
        .environment(LocationVM.shared)
}
