//
//  CustomizedMarker.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-01.
//

import SwiftUI

struct CustomizedMarker: View {
    var price: Double
    
    var body: some View {
        Text("$\(String(format: "%.2f", price)) CAD")
            .font(.custom(Constant.Font.semiBold, size: 12))
            .foregroundStyle(Color(Constant.Color.primaryText))
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 30)
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
           
    }
}

#Preview {
    CustomizedMarker(price: 100.0)
}
