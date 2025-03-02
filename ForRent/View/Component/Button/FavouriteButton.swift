//
//  FavouriteButton.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-01.
//

import SwiftUI

struct FavouriteButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "heart")
                .scaledToFit()
                .frame(width: 13.5, height: 13.5)
                .padding(7)
                .background(Circle()
                    .fill(Color.white)
                    .stroke(Color(Constant.Color.subText), lineWidth: 1))
                .foregroundColor(
                    Color(Constant.Color.sencondaryText)
                )
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .buttonStyle(BorderlessButtonStyle())
    }
}

#Preview {
    FavouriteButton() {}
}
