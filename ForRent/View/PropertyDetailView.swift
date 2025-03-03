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
    
    @State private var owner: User?
    @State private var cityStateCountry = "Toronto"
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 43.642954, longitude: -79.394835), // Toronto
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    @State private var amenities = ""
    
    var property: Property
    
    private func fetchPropertyInfo() {
        
        userVM.fetchOwnerInfo(ownerId: property.ownerId) { ownerData in
            self.owner = ownerData
        }
        
        locationVM
            .fetchCityStateCountry(
                from: property.coordinate2D) { result in
                    cityStateCountry = result
                }
        
        amenities += "\(property.bedroom) \(property.bedroom > 1 ? "beds" : "bed"), "
        amenities += "\(property.bathroom) \(property.bathroom > 1 ? "baths" : "bath") for "
        amenities += "\(property.guest) \(property.guest > 1 ? "guests." : "guest.")"
    }
    
    private func reCenterMap(position: CLLocationCoordinate2D) {
        cameraPosition = .region(
            MKCoordinateRegion(
                center: position, // Toronto
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        AsyncImage(
                            url: URL(
                                string: property.imgURL
                            )
                        ) { image in
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
                                .foregroundStyle(
                                    Color(Constant.Color.sencondaryText)
                                )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.horizontal)
                        
                        HStack {
                            if let owner = self.owner {
                                AvatarImage(avatarURL: owner.avatarURL, size: 45)
                                    .padding(.trailing, 8)
                                VStack(alignment: .leading) {
                                    Text("Hosted by \(owner.username)")
                                        .font(.custom(Constant.Font.semiBold, size: 14))
                                        .foregroundStyle(Color(Constant.Color.primaryText))
                                    Spacer()
                                    HStack {
                                        Text("Verified host")
                                            .font(
                                                .custom(Constant.Font.regular, size: 14)
                                            )
                                            .foregroundStyle(
                                                Color(Constant.Color.sencondaryText)
                                            )
                                        Image(systemName: "checkmark.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 14)
                                            .foregroundStyle(
                                                Color(Constant.Color.subText)
                                            )
                                    }
                                }
                            }
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        
                        Divider()
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("About this place")
                                .font(.custom(Constant.Font.semiBold, size: 20))
                                .foregroundStyle(Color(Constant.Color.primaryText))
                                .padding(.bottom)
                            Text("Long Description goes here")
                                .font(.custom(Constant.Font.regular, size: 14))
                                .foregroundStyle(Color(Constant.Color.primaryText))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        
                        Divider()
                            .padding(.horizontal)
                        
                        Spacer()
                        
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
                            .onAppear(perform: {
                                reCenterMap(position: property.coordinate2D)
                            })
                            .frame(height: 400)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        
                        Divider()
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading)  {
                            Text("Availability")
                                .font(.custom(Constant.Font.semiBold, size: 20))
                                .foregroundStyle(Color(Constant.Color.primaryText))
                            Text(property.getFormattedDate(type: "available"))
                                .font(.custom(Constant.Font.regular, size: 14))
                                .foregroundStyle(
                                    Color(Constant.Color.sencondaryText)
                                )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .padding(.bottom, 100)
                        
                    }
                    .onAppear {
                        fetchPropertyInfo()
                    }
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
                                        .font(
                                            .custom(Constant.Font.regular, size: 18)
                                        )
                                        .foregroundStyle(Color(Constant.Color.primaryText))
                                }
                                Text(property.getFormattedDate(type: "available"))
                                    .font(.custom(Constant.Font.regular, size: 14))
                                    .foregroundStyle(
                                        Color(Constant.Color.primaryText)
                                    )
                            }
                            
                            Spacer()
                            MoreRoundedPrimaryButton(text: "Request") {
                                
                            }
                        }
                        .padding(.horizontal)
                        .padding(.horizontal)
                    }
                    .background(Color.white)
                }
            }//end of ZStack
            .background(ignoresSafeAreaEdges: .bottom)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14)
                                .foregroundStyle(Color(Constant.Color.primaryText))
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16)
                                .foregroundStyle(Color(Constant.Color.primaryText))
                        }
                    }
                }
            }
            .toolbarBackground(.white, for: .automatic)
        }//end of NavStack
        
    }
}

//#Preview {
//    PropertyDetailView()
//        .environment(AuthenticationVM.shared)
//        .environment(UserVM.shared)
//        .environment(PropertyVM.shared)
//        .environment(LocationVM.shared)
//}
