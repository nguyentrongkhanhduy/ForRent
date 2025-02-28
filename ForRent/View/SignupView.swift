//
//  SignupView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-24.
//

import SwiftUI

struct SignupView: View {
    @Binding var tab: Int
    
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthenticationVM.self) var authenticationVM
    @Environment(UserVM.self) var userVM
    
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var isLoading: Bool = false
    
    private func performSignup() {
        isLoading = true
        authenticationVM
            .signUpUser(
                password: password,
                confirmPassword: confirmPassword,
                username: userVM.user.username,
                legalName: userVM.user.legalName
            ) { success in
                DispatchQueue.main.async {
                    isLoading = false
                    if success {
                        if userVM
                            .setUserIDandEmail(
                                uid: authenticationVM.userID,
                                email: authenticationVM
                                    .email) {
                            userVM.createUser()
                            dismiss()
                            self.tab = 0
                        } else {
                            print("ERR ERR")
                        }
                    } else {
                        showAlert = true
                    }
                }
                
                
            }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("Sign up to ForRent")
                    .font(.custom(Constant.Font.semiBold, size: 20))
                    .foregroundStyle(Color(Constant.Color.primaryText))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                
                Text("Credentials")
                    .font(.custom(Constant.Font.regular, size: 14))
                    .foregroundStyle(Color(Constant.Color.primaryText))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 40)
                
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
                
                CustomizedTextField(
                    placeholder: "Password",
                    isSecure: true,
                    bindingText: $password
                )
                .padding(.top, 10)
                
                CustomizedTextField(
                    placeholder: "Confirm your password",
                    isSecure: true,
                    bindingText: $confirmPassword
                )
                .padding(.top, 10)
                
                Text("Personal information")
                    .font(.custom(Constant.Font.regular, size: 14))
                    .foregroundStyle(Color(Constant.Color.primaryText))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 30)
                CustomizedTextField(
                    placeholder: "Legal name",
                    isSecure: false,
                    bindingText: Binding(get: {
                        userVM.user.legalName
                    }, set: { value in
                        userVM.user.legalName = value
                    })
                )
                
                CustomizedTextField(
                    placeholder: "Display name",
                    isSecure: false,
                    bindingText: Binding(get: {
                        userVM.user.username
                    }, set: { value in
                        userVM.user.username = value
                    })
                )
                .padding(.top, 10)
                
                PrimaryButton(text: "Sign up") {
                    performSignup()
                }
                .padding(.top, 50)
                
                
                Spacer()
            }//End of VStack
            .opacity(isLoading ? 0.3 : 1)
            .padding(.horizontal)
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(authenticationVM.errorMessage)
            }
            
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                    .scaleEffect(2)
            }
        }
        
    }
}

#Preview {
    @Previewable @State var test = 1
    SignupView(tab: $test)
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
}
