//
//  MoreRoundedButton.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-27.
//

import SwiftUI

struct MoreRoundedButton: View {
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
                .frame(width: 250)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(Constant.Color.primaryText))
                )
        }
    }
}

#Preview {
    MoreRoundedButton(text: "Switch to Host", action: {})
}
