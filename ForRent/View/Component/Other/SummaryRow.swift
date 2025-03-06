//
//  SummaryRow.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-05.
//

import SwiftUI

struct SummaryRow: View {
    @Environment(LocationVM.self) var locationVM
    
    @State private var cityStateCountry = "Toronto"
    @State private var amenities = ""
    
//    var property: Property
//    
//    private func fetchPropertyInfo() {
//        amenities += "\(property.bedroom) \(property.bedroom > 1 ? "beds" : "bed"), "
//        amenities += "\(property.bathroom) \(property.bathroom > 1 ? "baths" : "bath") for "
//        amenities += "\(property.guest) \(property.guest > 1 ? "guests." : "guest.")"
//    }
    
    var body: some View {
        HStack {
            SquareImage(imgURL: "https://cdnarchitect.s3.ca-central-1.amazonaws.com/2023/08/29154750/The-Well-2023-117.jpg", size: 90, radius: 10)
                .padding(.trailing)
            VStack(alignment: .leading) {
                Text("property.title")
                    .font(.custom(Constant.Font.semiBold, size: 16))
                Text("cityStateCountry")
                    .font(.custom(Constant.Font.regular, size: 14))
                Spacer()
                Text("amenities")
                    .font(.custom(Constant.Font.regular, size: 14))
            }
            .foregroundStyle(Color(Constant.Color.primaryText))
            .padding(.vertical, 5)
            
            Spacer()
        }
        .frame(height: 90)
        .padding()
        .onAppear {
//            fetchPropertyInfo()
//            locationVM
//                .fetchCityStateCountry(
//                    from: property.coordinate2D) { result in
//                        cityStateCountry = result
//                    }
        }
    }
}

//#Preview {
//    SummaryRow()
//}
