//
//  PropertyDetailView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-02.
//

import SwiftUI
import MapKit

struct PropertyDetailView: View {
    @Environment(AuthenticationVM.self) var authenticationVM
    @Environment(UserVM.self) var userVM
    @Environment(PropertyVM.self) var propertyVM
    @Environment(LocationVM.self) var locationVM
    
    // Add currentRole from AppStorage
    @AppStorage("currentRole") private var currentRole: String = "Guest"
    
    @State private var owner: User?
    @State private var cityStateCountry = "Toronto"
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 43.642954, longitude: -79.394835),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    @State private var amenities = ""
    @State private var isInWishlist: Bool = false
    @State private var showLoginAlert = false
    @State private var toLogin = false
    @State private var toRequest = false
    // New state to trigger edit navigation
    @State private var toEdit = false

    @State var property: Property
    @Binding var tab: Int
    
    private func navigateToRequestView() {
        if authenticationVM.isLoggedIn {
            toRequest = true
        } else {
            showLoginAlert = true
        }
    }
    
    private func performAddToWishList() {
        if authenticationVM.isLoggedIn {
            guard let propId = property.id, !propId.isEmpty else {
                print("Error adding to wishlist")
                return
            }
            userVM.addOrRemoveToWishList(userId: authenticationVM.userID, propertyId: propId)
        } else {
            showLoginAlert = true
        }
    }
    
    private func updateWishlistState() {
        guard authenticationVM.isLoggedIn, let propertyId = property.id, !propertyId.isEmpty else {
            isInWishlist = false
            return
        }
        isInWishlist = userVM.user.wishList.contains(propertyId)
    }
    
    private func fetchPropertyInfo() {
        userVM.fetchOwnerInfo(ownerId: property.ownerId) { ownerData in
            self.owner = ownerData
        }
        
        locationVM.fetchCityStateCountry(from: property.coordinate2D) { result in
            cityStateCountry = result
        }
        
        amenities = "\(property.bedroom) \(property.bedroom > 1 ? "beds" : "bed"), " +
                    "\(property.bathroom) \(property.bathroom > 1 ? "baths" : "bath") for " +
                    "\(property.guest) \(property.guest > 1 ? "guests" : "guest")"
    }
    
    private func reCenterMap(position: CLLocationCoordinate2D) {
        cameraPosition = .region(
            MKCoordinateRegion(
                center: position,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        AsyncImage(url: URL(string: property.imgURL)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            Image("house-placeholder")
                                .resizable()
                                .scaledToFit()
                        }
                        
                        VStack(alignment: .leading) {
                            Text(property.title)
                                .font(.custom(Constant.Font.semiBold, size: 25))
                                .foregroundStyle(Color(Constant.Color.primaryText))
                                .padding(.top, 20)
                            
                            Text("Room in \(cityStateCountry)")
                                .font(.custom(Constant.Font.semiBold, size: 16))
                                .foregroundStyle(Color(Constant.Color.primaryText))
                                .padding(.top, 1)
                            
                            Text(amenities)
                                .font(.custom(Constant.Font.regular, size: 14))
                                .foregroundStyle(Color(Constant.Color.sencondaryText))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        Divider().padding(.horizontal)
                        
                        HStack {
                            if let owner = self.owner {
                                AvatarImage(avatarURL: owner.avatarURL, size: 45)
                                    .padding(.trailing, 8)
                                VStack(alignment: .leading) {
                                    Text("Hosted by \(owner.username)")
                                        .font(.custom(Constant.Font.semiBold, size: 14))
                                        .foregroundStyle(Color(Constant.Color.primaryText))
                                    HStack {
                                        Text("Verified host")
                                            .font(.custom(Constant.Font.regular, size: 14))
                                            .foregroundStyle(Color(Constant.Color.sencondaryText))
                                        Image(systemName: "checkmark.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 14)
                                            .foregroundStyle(Color(Constant.Color.subText))
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        
                        Divider().padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("About this place")
                                .font(.custom(Constant.Font.semiBold, size: 20))
                                .foregroundStyle(Color(Constant.Color.primaryText))
                                .padding(.bottom)
                            Text(property.description)
                                .font(.custom(Constant.Font.regular, size: 14))
                                .foregroundStyle(Color(Constant.Color.primaryText))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        
                        Divider().padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("Where you'll be")
                                .font(.custom(Constant.Font.semiBold, size: 20))
                                .foregroundStyle(Color(Constant.Color.primaryText))
                            HStack {
                                Text(cityStateCountry)
                                    .font(.custom(Constant.Font.regular, size: 14))
                                    .foregroundStyle(Color(Constant.Color.primaryText))
                                Spacer()
                                Button {
                                    reCenterMap(position: property.coordinate2D)
                                } label: {
                                    Text("Re-center map")
                                        .font(.custom(Constant.Font.semiBold, size: 14))
                                        .foregroundStyle(Color(Constant.Color.primaryText))
                                        .underline()
                                }
                            }
                            Map(position: $cameraPosition) {
                                Annotation("", coordinate: property.coordinate2D) {
                                    Image(systemName: "house.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40)
                                }
                                MapCircle(center: property.coordinate2D, radius: 200)
                                    .foregroundStyle(.black.opacity(0.2))
                            }
                            .onAppear { reCenterMap(position: property.coordinate2D) }
                            .frame(height: 400)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        
                        VStack(alignment: .leading) {
                            Text("Availability")
                                .font(.custom(Constant.Font.semiBold, size: 20))
                                .foregroundStyle(Color(Constant.Color.primaryText))
                            Text(property.dateAvailable.getFullFormatDate())
                                .font(.custom(Constant.Font.regular, size: 14))
                                .foregroundStyle(Color(Constant.Color.sencondaryText))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .padding(.bottom, 100)
                    }
                    .onAppear { fetchPropertyInfo() }
                }
                
                VStack {
                    Spacer()
                    VStack {
                        Divider()
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("$\(String(format: "%.2f", property.price)) CAD")
                                        .font(.custom(Constant.Font.semiBold, size: 20))
                                        .foregroundStyle(Color(Constant.Color.primaryText))
                                        .underline()
                                    Text("night")
                                        .font(.custom(Constant.Font.regular, size: 18))
                                        .foregroundStyle(Color(Constant.Color.primaryText))
                                }
                                Text(property.dateAvailable.getShortMonthDayFormat())
                                    .font(.custom(Constant.Font.regular, size: 14))
                                    .foregroundStyle(Color(Constant.Color.primaryText))
                            }
                            Spacer()

                            // Show "Request" button only for guests
                            if currentRole == "Guest" && !property.isDelisted {
                                MoreRoundedPrimaryButton(text: "Request") {
                                    navigateToRequestView()
                                }
                            }

                            // Define a nice green color for "List Property"
                            let listColor = Color.green.opacity(0.8)
                            let delistColor = Color.red.opacity(0.8)

                            // Show "Delist/Relist" button for hosts
                            if currentRole != "Guest" {
                                MoreRoundedButton(
                                    text: property.isDelisted ? "List Property" : "Delist Property",
                                    backgroundColor: property.isDelisted ? listColor : delistColor
                                ) {
                                    toggleDelistStatus()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .background(Color.white)
                }
            }
            .toolbar {
                // Share and wishlist buttons (wishlist button appears only for guests)
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        if currentRole == "Guest" {
                            ShareLink(item: "\(property.title), $\(String(format: "%.2f", property.price)) CAD") {
                                Image(systemName: "square.and.arrow.up")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 14)
                                                                .foregroundStyle(Color(Constant.Color.primaryText))
                            }
                            
                            Button {
                                performAddToWishList()
                            } label: {
                                Image(systemName: isInWishlist ? "heart.fill" : "heart")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16)
                                    .foregroundStyle(isInWishlist ?
                                        Color(Constant.Color.primaryColor) :
                                        Color(Constant.Color.sencondaryText))
                            }
                            .onAppear { updateWishlistState() }
                            .onChange(of: userVM.user.wishList) { _, _ in updateWishlistState() }
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if currentRole != "Guest" {
                        Button("Edit") {
                            toEdit = true
                        }
                        .foregroundStyle(Color(Constant.Color.primaryText))
                    }
                }
            }
            .navigationDestination(isPresented: $toRequest) {
                RequestView(property: property, tab: $tab)
            }
            .navigationDestination(isPresented: $toLogin) {
                LoginView(tab: $tab)
            }
            // Navigation to the edit screen for host mode
            .navigationDestination(isPresented: $toEdit) {
                PropertyEditView(property: property, isEditing: true)
            }
            .alert("Action Requires an Account", isPresented: $showLoginAlert) {
                Button("Log In") { toLogin = true }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("You need to have an account to perform this action. Please log in or sign up.")
            }
        }
    }

    // MARK: - Toggle Delist Status

    private func toggleDelistStatus() {
        guard let propId = property.id else { return }
        
        let newStatus = !property.isDelisted // Toggle the status

        propertyVM.updatePropertyStatus(propertyId: propId, isDelisted: newStatus) { success in
            if success {
                DispatchQueue.main.async {
                    property.isDelisted = newStatus
                }
            } else {
                print("Failed to update property delist status.")
            }
        }
    }
}

//#Preview {
//    PropertyDetailView()
//        .environment(AuthenticationVM.shared)
//        .environment(UserVM.shared)
//        .environment(PropertyVM.shared)
//        .environment(LocationVM.shared)
//}
