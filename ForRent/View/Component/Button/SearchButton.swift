//
//  SearchButton.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-02.
//

import SwiftUI

struct SearchButton: View {
    var action: () -> Void
    
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("Search")
                    .font(.custom(Constant.Font.semiBold, size: 14))
                    
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .foregroundStyle(Color.white)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(Constant.Color.primaryColor))
            )
        }
    }
}

#Preview {
    SearchButton() {}
}
