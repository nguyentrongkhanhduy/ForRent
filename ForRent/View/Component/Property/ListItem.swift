//
//  ListItem.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-01.
//

import SwiftUI

struct ListItem: View {
    @Environment(LocationVM.self) var locationVM
    
    @State private var cityStateCountry = "Toronto"
    
    var property: Property
    let addtoWishlist: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                AsyncImage(
                    url: URL(
                        string: property.imgURL
                    )
                ) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 350, height: 350)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                } placeholder: {
                    Image("house-placeholder")
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 350, height: 350)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                VStack(alignment: .leading) {
                    Text(property.title)
                        .font(.custom(Constant.Font.semiBold, size: 16))
                        .foregroundStyle(Color(Constant.Color.primaryText))
                    Text(cityStateCountry)
                        .font(.custom(Constant.Font.regular, size: 14))
                        .foregroundStyle(Color(Constant.Color.sencondaryText))
                    Text(property.description)
                        .font(.custom(Constant.Font.regular, size: 14))
                        .foregroundStyle(Color(Constant.Color.sencondaryText))
                    Text("Available: \(property.getFormattedDate(type: "available"))")
                        .font(.custom(Constant.Font.regular, size: 14))
                        .foregroundStyle(Color(Constant.Color.sencondaryText))
                    HStack(alignment: .lastTextBaseline) {
                        Text("$\(String(format: "%.2f", property.price)) CAD")
                            .font(.custom(Constant.Font.semiBold, size: 18))
                            .foregroundStyle(Color(Constant.Color.primaryText))
                        Text("night")
                            .font(.custom(Constant.Font.regular, size: 16))
                            .foregroundStyle(Color(Constant.Color.primaryText))
                    }
                    .padding(.top, 1)
                }
                .frame(width: 350, alignment: .leading)
                
                
            }
            .frame(width: 350)
           
            HStack {
                Spacer()
                
                FavouriteButton {
                    addtoWishlist()
                }
            }
            .padding(.trailing)
            .padding(.bottom, 430)
            .frame(width: 350)
            .zIndex(2)
        }
        .onAppear {
            locationVM
                .fetchCityStateCountry(
                    from: property.coordinate2D) { result in
                        cityStateCountry = result
                    }
        }
    }
    
    
}

//#Preview {
//    ListItem()
//}
