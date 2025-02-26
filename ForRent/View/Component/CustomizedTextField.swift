//
//  CustomizedTextField.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-25.
//

import SwiftUI

struct CustomizedTextField: View {
    var placeholder: String
    var isSecure: Bool
    @Binding var bindingText: String
    
    var body: some View {
        if !isSecure {
            TextField(placeholder, text: $bindingText)
                .font(.custom(Constant.Font.regular, size: 16))
                .padding()
                .foregroundStyle(Color(Constant.Color.primaryText))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .stroke(Color(Constant.Color.primaryText), lineWidth: 1)
                )
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        } else {
            SecureField(placeholder, text: $bindingText)
                .font(.custom(Constant.Font.regular, size: 16))
                .padding()
                .foregroundStyle(Color(Constant.Color.primaryText))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .stroke(Color(Constant.Color.primaryText), lineWidth: 1)
                )
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        }
        
    }
}

#Preview {
    @Previewable @State var test = ""
    CustomizedTextField(placeholder: "Email", isSecure: false, bindingText: $test)
}
