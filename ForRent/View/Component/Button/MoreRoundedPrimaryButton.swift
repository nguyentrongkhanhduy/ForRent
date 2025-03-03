//
//  RequestButton.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-02.
//

import SwiftUI

struct MoreRoundedPrimaryButton: View {
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.custom(Constant.Font.semiBold, size: 18))
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .foregroundStyle(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(Constant.Color.primaryColor))
                )
        }
    }
}

#Preview {
    MoreRoundedPrimaryButton(text: "Request") {
        
    }
}
