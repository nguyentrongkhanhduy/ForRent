//
//  PropertyEditView.swift
//  ForRent
//
//  Created by wang zexi on 3/10/25.
//

import SwiftUI
import FirebaseFirestore
import CoreLocation
import MapKit

struct PropertyEditView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(PropertyVM.self) var propertyVM
    @Environment(AuthenticationVM.self) var authenticationVM

    // The property being edited or created.
    @State var property: Property
    let isEditing: Bool

    @State private var isSaving = false
    @State private var errorMessage = ""
    @State private var showErrorAlert = false

    // New state for the selected coordinate (based on the entered address).
    @State private var selectedCoordinate: CLLocationCoordinate2D

    // CLGeocoder instance to convert address into coordinates.
    let geocoder = CLGeocoder()

    // Computed property for the map region.
    private var currentRegion: MKCoordinateRegion {
        let latDelta: CLLocationDegrees = 0.01
        let longDelta: CLLocationDegrees = 0.01
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        return MKCoordinateRegion(center: selectedCoordinate, span: span)
    }

    init(property: Property, isEditing: Bool) {
        self._property = State(initialValue: property)
        self.isEditing = isEditing
        // Initialize selectedCoordinate from the property's current coordinate.
        _selectedCoordinate = State(initialValue: property.coordinate2D)
    }

    var body: some View {
        NavigationStack {
            propertyForm
                .navigationTitle(isEditing ? "Edit Listing" : "New Listing")
                .toolbar { saveToolbar }
                .alert("Error", isPresented: $showErrorAlert) {
                    alertButtons
                } message: {
                    Text(errorMessage)
                }
                .overlay {
                    if isSaving {
                        savingOverlay
                    }
                }
        }
    }

    // MARK: - Subviews

    private var propertyForm: some View {
        Form {
            detailsSection
            addressSection
            imageURLSection
        }
    }

    private var detailsSection: some View {
        Section(header: Text("Property Details")) {
            TextField("Title", text: $property.title)
            TextEditor(text: $property.description)
                .frame(height: 100)
            TextField("Price (per night)", value: $property.price, format: .number)
                .keyboardType(.decimalPad)
            Stepper("Bedrooms: \(property.bedroom)", value: $property.bedroom, in: 0...10)
            Stepper("Bathrooms: \(property.bathroom)", value: $property.bathroom, in: 0...10)
            Stepper("Guests: \(property.guest)", value: $property.guest, in: 1...20)
            DatePicker("Available From", selection: $property.dateAvailable, in: Date()..., displayedComponents: [.date])
        }
    }

    private var addressSection: some View {
        Section(header: Text("Property Address")) {
            TextField("Enter property address", text: $property.address)
                .onChange(of: property.address) { newAddress, _ in
                    if !newAddress.isEmpty {
                        geocoder.geocodeAddressString(newAddress) { placemarks, error in
                            if let error = error {
                                print("Geocoding error: \(error.localizedDescription)")
                            } else if let placemark = placemarks?.first,
                                      let location = placemark.location {
                                DispatchQueue.main.async {
                                    selectedCoordinate = location.coordinate
                                }
                            }
                        }
                    }
                }
            Section(header: Text("Property Location")) {
                HStack {
                    Text("Lat: \(String(format: "%.4f", selectedCoordinate.latitude))")
                    Spacer()
                    Text("Long: \(String(format: "%.4f", selectedCoordinate.longitude))")
                }
                // Breaking up the expression using a local constant.
                let region = currentRegion
                MapPreviewView(region: region)
            }
        }
    }

    private var imageURLSection: some View {
        Section(header: Text("Image URL")) {
            TextField("Image URL", text: $property.imgURL)
                .keyboardType(.URL)
        }
    }

    // Updated computed property for the toolbar.
    private var saveToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
                saveProperty()
            }
            .disabled(isSaving)
        }
    }

    private var alertButtons: some View {
        Button("OK", role: .cancel) { }
    }

    private var savingOverlay: some View {
        ProgressView("Saving...")
            .progressViewStyle(CircularProgressViewStyle())
    }

    // MARK: - Save Function

    func saveProperty() {
        isSaving = true
        // Ensure the ownerId is set.
        property.ownerId = authenticationVM.userID
        // Update the property's coordinate using the selectedCoordinate.
        property.coordinate = FirebaseFirestore.GeoPoint(latitude: selectedCoordinate.latitude,
                                                         longitude: selectedCoordinate.longitude)
        if isEditing {
            propertyVM.updateProperty(property: property) { success in
                isSaving = false
                if success {
                    dismiss()
                } else {
                    errorMessage = "Failed to update property."
                    showErrorAlert = true
                }
            }
        } else {
            propertyVM.addProperty(property: property) { success in
                isSaving = false
                if success {
                    dismiss()
                } else {
                    errorMessage = "Failed to add property."
                    showErrorAlert = true
                }
            }
        }
    }
}

// Helper view that shows a Map for a given region with a marker.
struct MapPreviewView: View {
    let region: MKCoordinateRegion
    var body: some View {
        // Provide annotationItems to display a marker.
        Map(
            coordinateRegion: .constant(region),
            annotationItems: [DummyAnnotation(coordinate: region.center)]
        ) { annotation in
            MapMarker(coordinate: annotation.coordinate, tint: .red)
        }
        .frame(height: 200)
        .cornerRadius(8)
    }
}

struct DummyAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
