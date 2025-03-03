//
//  ExploreView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-24.
//

import SwiftUI
import MapKit

struct ExploreView: View {
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
    
    var filterArea: String
    
    private func performGetCurrentLocation() {
        locationVM.requestLocationPermisstion() {
            DispatchQueue.main.async {
                if !locationVM.errorMessage.isEmpty {
                    showAlert = true
                }
            }
        }
    }
    
    func updateCameraPosition() {
        if self.filterArea.isEmpty {
            return
        }
        var curLocation = CLLocationCoordinate2D()
        switch filterArea {
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
    
    var body: some View {
        ZStack {
            Map(position: $defaultCameraPosition) {
                ForEach(propertyVM.listProperty, id: \.self) { property in
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
            .mapControls {
//                MapUserLocationButton()
            }
            .onAppear {
//                performGetCurrentLocation() //get user permission
                updateCameraPosition()
            }
            .onChange(
                of: locationVM.userLocationEquatable
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
            .presentationDetents([.height(900), .large])
            
            if showProperty, let property = selectedProperty {
                VStack {
                    Spacer()
                    PopupProperty(
                        property: property) {
                            
                        } close: {
                            showProperty = false
                        }
                        .zIndex(1)
                }
            }
        }
    }
}

#Preview {
    ExploreView(filterArea: "")
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
        .environment(PropertyVM.shared)
        .environment(LocationVM.shared)
}
