//
//  SquareImage.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-03.
//

import SwiftUI

struct SquareImage: View {
    var imgURL: String
    var size: Double
    var radius: Double
    
    var body: some View {
        AsyncImage(
            url: URL(
                string: imgURL
            )
        ) { image in
            image
                .resizable()
                .scaledToFill()
                .clipped()
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: radius))
            
        } placeholder: {
            Image("house-placeholder")
                .resizable()
                .scaledToFill()
                .clipped()
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: radius))
        }
    }
}

#Preview {
    SquareImage(imgURL: "", size: 350, radius: 10)

}
