//
//  DisabledButton.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-27.
//

import SwiftUI

struct DisabledButton: View {
    var text: String
    
    var body: some View {
        Button {
        } label: {
            Text(text)
                .font(.custom(Constant.Font.semiBold, size: 20))
                .padding()
                .foregroundStyle(Color(Constant.Color.subText))
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(Constant.Color.sencondaryText))
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            Color(Constant.Color.primaryText),
                            lineWidth: 1
                        )
                }
        }
        .disabled(true)
    }
}

#Preview {
    DisabledButton(text: "Update")
}
