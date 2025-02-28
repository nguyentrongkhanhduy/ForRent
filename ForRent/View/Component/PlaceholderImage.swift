//
//  CircleImage.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-27.
//

import SwiftUI

struct PlaceholderImage: View {
    var size: Double
    
    var body: some View {
        Image(systemName: "person.fill")
            .resizable()
            .scaledToFit()
            .padding(10)
            .frame(width: size, height: size)
            .clipShape(Circle())
            .background(
                Circle()
                    .fill(Color(Constant.Color.subText))
            )
            .foregroundColor(Color(Constant.Color.sencondaryText))
            .overlay {
                Circle()
                    .stroke(
                        Color(Constant.Color.sencondaryText),
                        lineWidth: 1
                    )
            }
    }
}

#Preview {
    PlaceholderImage(size: 100)
}
