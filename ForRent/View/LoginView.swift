//
//  LoginView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthenticationVM.self) var authenticationVM
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @Binding var tab: Int
    
    var body: some View {
        VStack {
            Text("Log in to ForRent")
                .font(.custom(Constant.Font.semiBold, size: 20))
                .foregroundStyle(Color(Constant.Color.primaryText))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
            
            TextField("Email", text: $email)
                .font(.custom(Constant.Font.regular, size: 16))
                .padding()
                .foregroundStyle(Color(Constant.Color.primaryText))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .stroke(Color(Constant.Color.primaryText), lineWidth: 1)
                )
                .keyboardType(.emailAddress)
                .padding(.top, 50)
            
            SecureField("Password", text: $password)
                .font(.custom(Constant.Font.regular, size: 16))
                .padding()
                .foregroundStyle(Color(Constant.Color.primaryText))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .stroke(Color(Constant.Color.primaryText), lineWidth: 1)
                )
                .padding(.top, 10)
            
            PrimaryButton(text: "Log in") {
                dismiss()
                self.tab = 0
            }
            .padding(.top, 10)
            Spacer()
        }//End of VStack
        .padding(.horizontal)
    }
}

#Preview {
    @Previewable @State var test = 1
    LoginView(tab: $test)
        .environment(AuthenticationVM.shared)
}
