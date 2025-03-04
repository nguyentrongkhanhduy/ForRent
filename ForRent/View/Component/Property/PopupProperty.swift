//
//  PopupProperty.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-01.
//

import SwiftUI

struct PopupProperty: View {
    @Environment(LocationVM.self) var locationVM
    
    var property: Property
    let addtoWishlist: () -> Void
    let close: () -> Void
    
    @State var cityStateCountry = ""
    
    var body: some View {
        VStack {
            ZStack {
                AsyncImage(
                    url: URL(
                        string: property.imgURL
                    )
                ) { image in
                    image
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: 200)
                } placeholder: {
                    Image("house-placeholder")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: 200)
                }
                
                VStack {
                    HStack {
                        Spacer()
                        
                        CircleFavouriteButton(property: property) {
                            addtoWishlist()
                        }
                        
                        Button {
                            close()
                        } label: {
                            Text("X")
                                .padding(8)
                                .background(Circle()
                                    .fill(Color.white)
                                    .stroke(Color(Constant.Color.subText), lineWidth: 1))
                                .foregroundColor(
                                    Color(Constant.Color.sencondaryText)
                                )
                        }
                    }
                    .padding(.trailing, 8)
                    .padding(.bottom, 150)
                    
                }
                
            }
            
            Text(cityStateCountry)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .font(.custom(Constant.Font.semiBold, size: 16))
                .foregroundStyle(Color(Constant.Color.primaryText))
            
            Text(property.dateAvailable.getShortestMonthDayFormat())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
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
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, 1)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .stroke(Color(Constant.Color.subText), lineWidth: 1)
                .shadow(
                    color: Color(Constant.Color.sencondaryText)
                        .opacity(0.5),
                    radius: 2,
                    x: 2,
                    y: 2
                )
        )
        .padding(.horizontal)
        .onAppear {
            locationVM
                .fetchCityStateCountry(from: property.coordinate2D) { string in
                    self.cityStateCountry = string
            }
        }
    }
}

//#Preview {
//    PopupProperty() {} close: {}
//}
