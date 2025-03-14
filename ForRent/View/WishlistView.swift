//
//  WishlistsView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-24.
//

import SwiftUI

struct WishlistView: View {
    @Environment(AuthenticationVM.self) var authenticationVM
    @Environment(UserVM.self) var userVM
    @Environment(PropertyVM.self) var propertyVM
    
    @State private var toLoginScreen = false
    @State private var toSignupScreen = false
    @State private var toDetailView = false
    @State private var selectProperty: Property?
    
    @Binding var tab: Int
    
    let columns = [
        GridItem(.flexible(), spacing: 10, alignment: .top),
        GridItem(.flexible(), spacing: 10, alignment: .top)
    ]
    
    private func performAddToWishList(property: Property) {
        guard let propId = property.id else {
            print("Error adding to wishlist")
            return
        }
        userVM
            .addOrRemoveToWishList(
                userId: authenticationVM.userID,
                propertyId: propId)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Wishlist")
                    .font(.custom(Constant.Font.semiBold, size: 30))
                    .foregroundStyle(Color(Constant.Color.primaryText))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                
                if authenticationVM.isLoggedIn {
                    if propertyVM.getWishlistProperties(wishList: userVM.user.wishList).isEmpty {
                        Text("Empty")
                            .font(.custom(Constant.Font.semiBold, size: 20))
                            .foregroundStyle(Color(Constant.Color.sencondaryText))
                    }
                    List {
                        ForEach(propertyVM.getWishlistProperties(wishList: userVM.user.wishList), id:\.self) { property in
                            WishlistItem(property: property) {
                                performAddToWishList(property: property)
                            }
                            .onTapGesture {
                                toDetailView = true
                                selectProperty = property
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                } else {
                    TemporaryViewForLogin(screenId: 1) {
                        toLoginScreen = true
                    } toSignup: {
                        toSignupScreen = true
                    }
                }
                
                Spacer()
            }//End of VStack
            .padding(.horizontal)
            .navigationDestination(isPresented: $toLoginScreen) {
                LoginView(tab: self.$tab)
            }
            .navigationDestination(isPresented: $toSignupScreen) {
                SignupView(tab: self.$tab)
            }
            .navigationDestination(isPresented: $toDetailView) {
                if let property = selectProperty {
                    PropertyDetailView(property: property, tab: self.$tab)
                }
            }
        }//End of NavStack
    }//End of body
}

#Preview {
    @Previewable @State var test = 1
    WishlistView(tab: $test)
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
        .environment(PropertyVM.shared)
        .environment(LocationVM.shared)
}
