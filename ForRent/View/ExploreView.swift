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
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832), // Toronto
            span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)
        )
    )
    
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
        if let curPosition = locationVM.userLocation {
            print(curPosition)
            DispatchQueue.main.async {
                cameraPosition = .region(
                    MKCoordinateRegion(center: curPosition, span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
                )
            }
        }
    }
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
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
                MapUserLocationButton()
            }
            .onAppear {
                performGetCurrentLocation()
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
    ExploreView()
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
        .environment(PropertyVM.shared)
        .environment(LocationVM.shared)
}
