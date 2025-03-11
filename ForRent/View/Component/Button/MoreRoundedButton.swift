//
//  MoreRoundedButton.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-27.
//

import SwiftUI

struct MoreRoundedButton: View {
    var text: String
    var systemImgString: String? = nil
    var backgroundColor: Color = Color(Constant.Color.primaryText)
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                if let systemImg = systemImgString, !systemImg.isEmpty {
                    Image(systemName: systemImg)
                }
                Text(text)
                    .font(.custom(Constant.Font.semiBold, size: 14))
            }
            .padding()
            .padding(.horizontal)
            .foregroundStyle(Color.white)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(backgroundColor)
            )
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        MoreRoundedButton(text: "Switch to hosting", systemImgString: "arrow.triangle.swap", action: {})

        MoreRoundedButton(text: "Switch to guest", action: {})
    }
}
