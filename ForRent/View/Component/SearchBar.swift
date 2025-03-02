//
//  SearchBar.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-02.
//

import SwiftUI

struct SearchBar: View {
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 12, height: 12)
            Text("Start your search")
                .font(.custom(Constant.Font.regular, size: 14))
        }
        .padding(.vertical, 14)
        .foregroundStyle(Color(Constant.Color.primaryText))
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .stroke(Color(Constant.Color.subText), lineWidth: 1)
                .shadow(
                    color: Color(Constant.Color.sencondaryText)
                        .opacity(0.3),
                    radius: 2,
                    x: 2,
                    y: 2
                )
        )
        .padding()
    }
}

#Preview {
    SearchBar()
}
