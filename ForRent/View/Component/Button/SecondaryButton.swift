//
//  SecondaryButton.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-27.
//

import SwiftUI

struct SecondaryButton: View {
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.custom(Constant.Font.semiBold, size: 20))
                .padding()
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, minHeight: 50) // Fixed minimum height
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(Constant.Color.primaryText))
                )
        }
    }
}

