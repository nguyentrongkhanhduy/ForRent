//
//  ChangeAvatarView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-28.
//

import SwiftUI

struct ChangeAvatarView: View {
    @Environment(AuthenticationVM.self) var authenticationVM
    @Environment(UserVM.self) var userVM
    
    @State private var imgURL = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private func performUpdateAvatar() {
        userVM.updateAvatar(url: imgURL) { success in
            if success {
                alertMessage = "Avatar changed successfully"
                imgURL = ""
            } else {
                alertMessage = userVM.errorMessage
            }
            showAlert = true
        }
    }
    
    var body: some View {
        VStack {
            Text("Change profile picture")
                .font(.custom(Constant.Font.semiBold, size: 25))
                .foregroundStyle(Color(Constant.Color.primaryText))
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            AvatarImage(avatarURL: userVM.user.avatarURL, size: 150)
            
            CustomizedTextField(
                placeholder: "Image URL",
                isSecure: false,
                bindingText: $imgURL
            )
            .padding(.top)
            
            Spacer()
            
            SecondaryButton(text: "Load Image") {
                userVM.user.avatarURL = imgURL
            }
            .padding(.bottom)
            
            if imgURL.isEmpty {
                DisabledButton(text: "Update")
            } else {
                PrimaryButton(text: "Update") {
                    performUpdateAvatar()
                }
            }
            
            Spacer()
        }
        .alert(
            "Change profile picture",
            isPresented: $showAlert,
            actions: {
                Button("OK", role: .cancel, action: {})
            },
            message: {
                Text(alertMessage)
            }
        )
        .padding(.horizontal)
    }
}

#Preview {
    ChangeAvatarView()
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
        .environment(PropertyVM.shared)
        .environment(LocationVM.shared)
}
