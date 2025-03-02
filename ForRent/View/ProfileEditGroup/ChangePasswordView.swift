//
//  ChangePasswordView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-27.
//

import SwiftUI

struct ChangePasswordView: View {
    @Environment(AuthenticationVM.self) var authenticationVM
    @Environment(UserVM.self) var userVM
    
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmNewPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading: Bool = false
    
    var isEmptyField: Bool {
        return currentPassword.isEmpty || newPassword.isEmpty || confirmNewPassword.isEmpty
    }
    
    private func performChangePassword() {
        guard newPassword == confirmNewPassword else {
            showAlert = true
            alertMessage = "New passwords do not match"
            confirmNewPassword = ""
            return
        }
        
        isLoading = true
        authenticationVM
            .changePassword(
                currentPassword: currentPassword,
                newPassword: newPassword) { success in
                    DispatchQueue.main.async {
                        isLoading = false
                        if success {
                            alertMessage = "Password changed successfully!"
                        } else {
                            alertMessage = authenticationVM.errorMessage
                        }
                        showAlert = true
                        resetFields()
                    }
                }
    }
    
    private func resetFields() {
        currentPassword = ""
        newPassword = ""
        confirmNewPassword = ""
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Change password")
                    .font(.custom(Constant.Font.semiBold, size: 25))
                    .foregroundStyle(Color(Constant.Color.primaryText))
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    Text("Current password")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(Constant.Font.semiBold, size: 15))
                    CustomizedTextField(
                        placeholder: "",
                        isSecure: true,
                        bindingText: $currentPassword
                    )
                }
                .padding(.top, 20)
                
                VStack {
                    Text("New password")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(Constant.Font.semiBold, size: 15))
                    CustomizedTextField(
                        placeholder: "",
                        isSecure: true,
                        bindingText: $newPassword
                    )
                }
                .padding(.top, 10)
                
                VStack {
                    Text("Confirm new password")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(Constant.Font.semiBold, size: 15))
                    CustomizedTextField(
                        placeholder: "",
                        isSecure: true,
                        bindingText: $confirmNewPassword
                    )
                }
                .padding(.top, 10)
                
                Spacer()
                
                if isEmptyField {
                    DisabledButton(text: "Update")
                } else {
                    PrimaryButton(text: "Update") {
                        performChangePassword()
                    }
                }
                
                
                Spacer()
            }
            .opacity(isLoading ? 0.3 : 1)
            .alert("Password Update", isPresented: $showAlert) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text(alertMessage)
                    }
            .onAppear(perform: {
                resetFields()
            })
            .padding(.horizontal)
            
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
    ChangePasswordView()
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
        .environment(PropertyVM.shared)
        .environment(LocationVM.shared)
}
