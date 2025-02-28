//
//  LoginView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-24.
//

import SwiftUI

struct LoginView: View {
    @Binding var tab: Int
    
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthenticationVM.self) var authenticationVM
    @Environment(UserVM.self) var userVM
    
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    
    @AppStorage("rememberMe") private var rememberCredential: Bool = false
    @AppStorage("savedEmail") private var savedEmail: String = ""
    @AppStorage("savedPassword") private var savedPassword: String = ""

    private func loadSavedCredentials() {
        if rememberCredential {
            authenticationVM.email = savedEmail
            password = savedPassword
        }
    }
    
    private func performLogin() {
        authenticationVM.loginUser(password: self.password) { success in
            if success {
                if rememberCredential {
                    savedEmail = authenticationVM.email
                    savedPassword = self.password
                }
                userVM.fetchUserInfo { fetched in
                    if fetched {
                        dismiss()
                        self.tab = 0
                    } else {
                        print("Error loading user data")
                    }
                }
            } else {
                password = ""
                showAlert = true
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Log in to ForRent")
                .font(.custom(Constant.Font.semiBold, size: 20))
                .foregroundStyle(Color(Constant.Color.primaryText))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
            
            CustomizedTextField(
                placeholder: "Email",
                isSecure: false,
                bindingText: Binding(get: {
                    authenticationVM.email
                }, set: { value in
                    authenticationVM.email = value
                })
            )
                .keyboardType(.emailAddress)
                .padding(.top, 50)
            
            CustomizedTextField(
                placeholder: "Password",
                isSecure: true,
                bindingText: $password
            )
                .padding(.top, 10)
            
            HStack {
                Button {
                    rememberCredential.toggle()
                } label: {
                    Image(systemName: rememberCredential ? "checkmark.square.fill" : "square")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(Color(Constant.Color.primaryText))
                    
                    Text("Remember me")
                        .font(.custom(Constant.Font.regular, size: 14))
                        .foregroundStyle(Color(Constant.Color.primaryText))
                }
            }
            .padding(.top, 5)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            PrimaryButton(text: "Log in") {
                performLogin()
            }
            .padding(.top, 10)
            Spacer()
        }//End of VStack
        .onAppear() {
            loadSavedCredentials()
        }
        .padding(.horizontal)
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(authenticationVM.errorMessage)
        }

    }
}

#Preview {
    @Previewable @State var test = 1
    LoginView(tab: $test)
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
}
