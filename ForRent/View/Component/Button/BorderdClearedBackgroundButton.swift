//
//  BorderdClearedBackgroundButton.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-06.
//

import SwiftUI

struct BorderdClearedBackgroundButton: View {
    var text: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.custom(Constant.Font.regular, size: 14))
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .stroke(Color(Constant.Color.primaryText), lineWidth: 1)
                )
                .foregroundStyle(Color(Constant.Color.primaryText))
        }

    }
}

#Preview {
    BorderdClearedBackgroundButton(text: "Add") {}
}
