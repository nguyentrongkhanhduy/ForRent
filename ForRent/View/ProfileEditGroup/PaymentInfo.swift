//
//  PaymentInfo.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-28.
//

import SwiftUI

struct PaymentInfo: View {
    @Environment(AuthenticationVM.self) var authenticationVM
    @Environment(UserVM.self) var userVM
    
    @State private var oldUser = User()
    @State private var isDisableTextField = true
    @State private var showAlert = false
    @State private var newCardNumber = ""
    
    var isValidCardNumber: Bool {
        return newCardNumber.count == 10
    }
    
    private func saveOldValues() {
        oldUser = userVM.user
    }
    
    private func resetFields() {
        userVM.user = oldUser
    }
    
    private func performUpdatePaymentMethod() {
        userVM.updatePaymentMethod(cardNumber: newCardNumber) { success in
            if success {
                isDisableTextField = true
                newCardNumber = ""
                saveOldValues()
            } else {
                resetFields()
                showAlert = true
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack (alignment: .firstTextBaseline) {
                Text("Personal Info")
                    .font(.custom(Constant.Font.semiBold, size: 25))
                    .foregroundStyle(Color(Constant.Color.primaryText))
                    .padding(.top, 10)
                
                Spacer()
                
                Button {
                    isDisableTextField.toggle()
                    resetFields()
                } label: {
                    Text(isDisableTextField ? "Edit" : "Cancel")
                        .font(.custom(Constant.Font.semiBold, size: 16))
                    .foregroundStyle(Color(Constant.Color.primaryText))
                    .underline()
                }

            }
            
            VStack {
                Text("Card number")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom(Constant.Font.semiBold, size: 15))
                if isDisableTextField {
                    Text(userVM.maskCardNumber())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(Constant.Font.regular, size: 15))
                        .foregroundStyle(Color(Constant.Color.sencondaryText))
                } else {
                    CustomizedTextField(
                        placeholder: "",
                        isSecure: false,
                        bindingText: $newCardNumber
                    )
                    .keyboardType(.numberPad)
                }
            }
            .padding(.top, 20)
            
            Spacer()
            
            if isValidCardNumber {
                PrimaryButton(text: "Update") {
                    performUpdatePaymentMethod()
                }
            } else {
                DisabledButton(text: "Update")
            }
            
            Spacer()
        }
        .alert(
            "Change payment card number",
            isPresented: $showAlert,
            actions: {
                Button("OK", role: .cancel, action: {})
            },
            message: {
                Text(userVM.errorMessage)
            }
        )
        .onAppear() {
            saveOldValues()
        }
        .padding(.horizontal)
    }
}

#Preview {
    PaymentInfo()
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
}
