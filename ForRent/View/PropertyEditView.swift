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

    @State var property: Property
    let isEditing: Bool

    @State private var isSaving = false
    @State private var errorMessage = ""
    @State private var showErrorAlert = false

    @State private var selectedCoordinate: CLLocationCoordinate2D
    let geocoder = CLGeocoder()

    // Validation State
    @State private var validationErrors: [String] = []

    private var currentRegion: MKCoordinateRegion {
        let latDelta: CLLocationDegrees = 0.01
        let longDelta: CLLocationDegrees = 0.01
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        return MKCoordinateRegion(center: selectedCoordinate, span: span)
    }

    init(property: Property, isEditing: Bool) {
        self._property = State(initialValue: property)
        self.isEditing = isEditing
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
                .border(validationErrors.contains("title") ? Color.red : Color.clear)
            TextField("Overview", text: $property.overview)
                .border(validationErrors.contains("overview") ? Color.red : Color.clear)
            TextEditor(text: $property.description)
                .frame(height: 100)
                .border(validationErrors.contains("description") ? Color.red : Color.clear)
            HStack {
                Text("Price per night:")
                    .font(.custom(Constant.Font.regular, size: 16))
                    .foregroundColor(.primary)

                TextField("Enter price", value: $property.price, format: .number)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .border(validationErrors.contains("price") ? Color.red : Color.clear)
            }
            Stepper("Bedrooms: \(property.bedroom)", value: $property.bedroom, in: 0...10)
            Stepper("Bathrooms: \(property.bathroom)", value: $property.bathroom, in: 0...10)
            Stepper("Guests: \(property.guest)", value: $property.guest, in: 1...20)
            DatePicker("Available From", selection: $property.dateAvailable, in: Date()..., displayedComponents: [.date])
        }
    }

    private var addressSection: some View {
        Section(header: Text("Property Address")) {
            TextField("Enter property address", text: $property.address)
                .border(validationErrors.contains("address") ? Color.red : Color.clear)
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
                let region = currentRegion
                MapPreviewView(region: region)
            }
        }
    }

    private var imageURLSection: some View {
        Section(header: Text("Image URL")) {
            TextField("Image URL", text: $property.imgURL)
                .keyboardType(.URL)
                .border(validationErrors.contains("imgURL") ? Color.red : Color.clear)
        }
    }

    // MARK: - Toolbar

    private var saveToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
                validateAndSave()
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

    // MARK: - Validation & Save

    func validateAndSave() {
        validationErrors.removeAll()

        // Check if required fields are empty
        if property.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationErrors.append("title")
        }
        if property.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationErrors.append("description")
        }
        if property.price <= 0 {
            validationErrors.append("price")
        }
        if property.address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationErrors.append("address")
        }
        if property.imgURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationErrors.append("imgURL")
        }
        if property.overview.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationErrors.append("overview")
        }

        if validationErrors.isEmpty {
            saveProperty()
        } else {
            errorMessage = "Please fill in all required fields."
            showErrorAlert = true
        }
    }

    func saveProperty() {
        isSaving = true
        property.ownerId = authenticationVM.userID
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
