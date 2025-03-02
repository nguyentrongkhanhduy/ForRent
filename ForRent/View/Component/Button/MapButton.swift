//
//  MapButton.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-01.
//

import SwiftUI

struct MapButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text("Map")
                    .font(.custom(Constant.Font.semiBold, size: 14))
                Image(systemName: "map.fill")
                    .resizable()
                    .frame(width: 14, height: 14)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 6)
            .foregroundStyle(Color.white)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(Constant.Color.primaryText))
            )
        }
    }
}

#Preview {
    MapButton() {}
}
