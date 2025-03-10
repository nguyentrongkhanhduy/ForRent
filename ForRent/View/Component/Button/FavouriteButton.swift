//
//  FavouriteButton.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-03.
//

import SwiftUI

struct FavouriteButton: View {
    @Environment(AuthenticationVM.self) var authenticationVM
    @Environment(UserVM.self) var userVM
    
    var property: Property
    let action: () -> Void
    
    @State private var isInWishlist: Bool = false
    
    private func updateWishlistState() {
        guard authenticationVM.isLoggedIn, let propertyId = property.id else {
                    isInWishlist = false
                    return
                }
                isInWishlist = userVM.user.wishList.contains(propertyId)
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "heart.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
                .foregroundColor(isInWishlist ?
                                 Color(Constant.Color.primaryColor) :
                                    Color(Constant.Color.sencondaryText)
                )
                .background(
                    Image(systemName: "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 21, height: 21)
                        .foregroundStyle(.white)
                )
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .buttonStyle(BorderlessButtonStyle())
        .onAppear {
            updateWishlistState()
        }
        .onChange(of: userVM.user.wishList) { oldValue, newValue in
            updateWishlistState()
        }
    }
}

//#Preview {
//    FavouriteButton() {}
//            .environment(AuthenticationVM.shared)
//            .environment(UserVM.shared)
//            .environment(PropertyVM.shared)
//            .environment(LocationVM.shared)
//}
