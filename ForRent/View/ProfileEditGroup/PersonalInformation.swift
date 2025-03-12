//
//  PersonalInformation.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-27.
//

import SwiftUI

struct PersonalInformation: View {
    @Environment(AuthenticationVM.self) var authenticationVM
    @Environment(UserVM.self) var userVM
    
    @State private var oldUser = User()
    @State private var isDisableTextField = true
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private func saveOldValues() {
        oldUser = userVM.user
    }
    
    private func resetFields() {
        userVM.user = oldUser
    }
    
    private func performUpdateInfo() {
        userVM.updatePersonalInfo { success in
            if success {
                isDisableTextField = true
                saveOldValues()
                alertMessage = "Information updated successfully!"
            } else {
                alertMessage = userVM.errorMessage
//                resetFields()
            }
            showAlert = true
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
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
                Text("Legal name")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom(Constant.Font.semiBold, size: 15))
                CustomizedTextField(
                    placeholder: "",
                    isSecure: false,
                    bindingText: Binding(get: {
                        userVM.user.legalName
                    }, set: { value in
                        userVM.user.legalName = value
                    })
                )
                .disabled(isDisableTextField)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            isDisableTextField ? Color(
                                Constant.Color.subText
                            ) : Color.clear
                        )
                )
            }
            .padding(.top, 20)
            
            
            VStack {
                Text("Display name")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom(Constant.Font.semiBold, size: 15))
                CustomizedTextField(
                    placeholder: "",
                    isSecure: false,
                    bindingText: Binding(get: {
                        userVM.user.username
                    }, set: { value in
                        userVM.user.username = value
                    })
                )
                .disabled(isDisableTextField)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            isDisableTextField ? Color(
                                Constant.Color.subText
                            ) : Color.clear
                        )
                )
            }
            .padding(.top, 10)
            
            VStack {
                Text("Phone number")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom(Constant.Font.semiBold, size: 15))
                CustomizedTextField(
                    placeholder: "",
                    isSecure: false,
                    bindingText: Binding(get: {
                        userVM.user.phone
                    }, set: { value in
                        userVM.user.phone = value
                    })
                )
                .keyboardType(.phonePad)
                .disabled(isDisableTextField)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            isDisableTextField ? Color(
                                Constant.Color.subText
                            ) : Color.clear
                        )
                )
                .onChange(of: userVM.user.phone) { oldValue, newValue in
                    if newValue.count > 10 {
                        userVM.user.phone = String(newValue.prefix(10))
                    }
                }
            }
            .padding(.top, 10)
            
            VStack {
                Text("Email")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom(Constant.Font.semiBold, size: 15))
                    .padding(.bottom, 5)
                Text(userVM.maskEmail())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom(Constant.Font.regular, size: 15))
                    .foregroundStyle(Color(Constant.Color.sencondaryText))
//                    .padding(.top, 2)
            }
            .padding(.top, 10)
            
            VStack {
                Text("Address")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom(Constant.Font.semiBold, size: 15))
                CustomizedTextField(
                    placeholder: "",
                    isSecure: false,
                    bindingText: Binding(get: {
                        userVM.user.address
                    }, set: { value in
                        userVM.user.address = value
                    })
                )
                .disabled(isDisableTextField)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            isDisableTextField ? Color(
                                Constant.Color.subText
                            ) : Color.clear
                        )
                )
            }
            .padding(.top, 10)
            
            Spacer()
            
            if isDisableTextField {
                DisabledButton(text: "Update")
            } else {
                PrimaryButton(text: "Update") {
                    performUpdateInfo()
                }
            }

            
            Spacer()
        }//End of VStack
        .alert("Update information", isPresented: $showAlert, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text(alertMessage)
        })
        .onAppear(perform: {
            saveOldValues()
        })
        .padding(.horizontal)
    }
}

#Preview {
    PersonalInformation()
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
        .environment(PropertyVM.shared)
        .environment(LocationVM.shared)
}
