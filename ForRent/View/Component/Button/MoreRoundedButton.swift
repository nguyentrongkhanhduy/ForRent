//
//  MoreRoundedButton.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-27.
//

import SwiftUI

struct MoreRoundedButton: View {
    var text: String
    var systemImgString: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: systemImgString)
                Text(text)
                    .font(.custom(Constant.Font.semiBold, size: 18))
            }
            .padding()
            .padding(.horizontal)
            .foregroundStyle(Color.white)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(Constant.Color.primaryText))
            )
        }
    }
}

#Preview {
    MoreRoundedButton(text: "Switch to hosting", systemImgString: "arrow.trianglehead.swap", action: {})
}
