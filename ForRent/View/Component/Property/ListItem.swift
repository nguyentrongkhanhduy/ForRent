//
//  ListItem.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-01.
//

import SwiftUI

struct ListItem: View {
    @Environment(LocationVM.self) var locationVM
    @AppStorage("currentRole") private var currentRole: String = "Guest"
    
    @State private var cityStateCountry = "Toronto"
    
    var property: Property
    let addtoWishlist: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                SquareImage(imgURL: property.imgURL, size: 350, radius: 16)
                
                VStack(alignment: .leading) {
                    Text(property.title)
                        .font(.custom(Constant.Font.semiBold, size: 16))
                        .foregroundStyle(Color(Constant.Color.primaryText))
                    Text(cityStateCountry)
                        .font(.custom(Constant.Font.regular, size: 14))
                        .foregroundStyle(Color(Constant.Color.sencondaryText))
                    Text("\(property.dateAvailable.getShortMonthDayFormat())")
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
                
                // Only show FavouriteButton if the current role is "Guest"
                if currentRole == "Guest" {
                    FavouriteButton(property: property) {
                        addtoWishlist()
                    }
                }
            }
            .padding(.trailing, 14)
            .padding(.bottom, 420)
            .frame(width: 350)
            .zIndex(2)
        }
        .onAppear {
            locationVM.fetchCityStateCountry(from: property.coordinate2D) { result in
                cityStateCountry = result
            }
        }
    }
}

//#Preview {
//    ListItem()
//}
