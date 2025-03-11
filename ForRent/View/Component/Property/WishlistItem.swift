//
//  GridItem.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-03.
//

import SwiftUI

struct WishlistItem: View {
    var property: Property
    let addtoWishlist: () -> Void
    
    var body: some View {
        
        VStack {
            ZStack {
                SquareImage(imgURL: property.imgURL, size: 350, radius: 16)
                
                HStack {
                    Spacer()
                    FavouriteButton(property: property) {
                        addtoWishlist()
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 300)
                }
                .frame(width: 350)
            }
            
            VStack(alignment: .leading) {
                Text(property.title)
                    .frame(width: 350, alignment: .leading)
                    .font(.custom(Constant.Font.semiBold, size: 16))
                    .foregroundStyle(Color(Constant.Color.primaryText))
                
                Text(property.overview)
                    .frame(width: 350, alignment: .leading)
                    .font(.custom(Constant.Font.regular, size: 15))
                    .foregroundStyle(Color(Constant.Color.sencondaryText))
                Text("\(property.bedroom) \(property.bedroom > 1 ? "beds" : "bed")")
                    .frame(width: 350, alignment: .leading)
                    .font(.custom(Constant.Font.regular, size: 15))
                    .foregroundStyle(Color(Constant.Color.sencondaryText))
            }
            
        }
        
        
        
        
    }
}

//#Preview {
//    WishlistItem() {}
//        .environment(AuthenticationVM.shared)
//        .environment(UserVM.shared)
//        .environment(PropertyVM.shared)
//        .environment(LocationVM.shared)
//}
