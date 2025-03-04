//
//  FavouriteButton.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-01.
//

import SwiftUI

struct CircleFavouriteButton: View {
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
            Image(systemName: isInWishlist ? "heart.fill" : "heart")
                .resizable()
                .scaledToFit()
                .frame(width: 13.5, height: 13.5)
                .padding(7)
                .background(Circle()
                    .fill(Color.white)
                    .stroke(Color(Constant.Color.subText), lineWidth: 1))
                .foregroundColor(isInWishlist ?
                                 Color(Constant.Color.primaryColor) :
                                    Color(Constant.Color.sencondaryText)
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
//        .environment(AuthenticationVM.shared)
//        .environment(UserVM.shared)
//        .environment(PropertyVM.shared)
//        .environment(LocationVM.shared)
//}
