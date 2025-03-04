//
//  GridItem.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-03.
//

import SwiftUI

struct GridItem: View {
    var property: Property
    let addtoWishlist: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                SquareImage(imgURL: "https://www.easyprecon.com/wp-content/uploads/2023/01/easy-precon-luxury-condo-toronto.jpg.webp", size: 160, radius: 20)
                
                Text("Title goes here")
                    .frame(width: 160, alignment: .leading)
                    .font(.custom(Constant.Font.semiBold, size: 16))
                    .foregroundStyle(Color(Constant.Color.primaryText))
                
                Text("6 beds")
                    .frame(width: 160, alignment: .leading)
                    .font(.custom(Constant.Font.regular, size: 15))
                    .foregroundStyle(Color(Constant.Color.sencondaryText))
            }
            
            HStack {
                Spacer()
                FavouriteButton(property: property) {
                    addtoWishlist()
                }
                .padding(.trailing)
                .padding(.bottom, 170)
            }
            .frame(width: 160)
            
        }
    }
}

//#Preview {
//    GridItem()
//        .environment(AuthenticationVM.shared)
//        .environment(UserVM.shared)
//        .environment(PropertyVM.shared)
//        .environment(LocationVM.shared)
//}
