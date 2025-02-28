//
//  PrimaryButton.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-24.
//

import SwiftUI

struct PrimaryButton: View {
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
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(Constant.Color.primaryColor))
                )
        }
    }
}

