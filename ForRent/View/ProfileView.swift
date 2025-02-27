//
//  ProfileView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AuthenticationVM.self) var authenticationVM
    @Environment(UserVM.self) var userVM
    
    @State private var toLoginScreen = false
    @State private var toSignupScreen = false
    @State private var showSignoutAlert = false
    
    
    @Binding var tab: Int

    private func performSignout() {
        authenticationVM.signOut() {
//            self.tab = 0
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if authenticationVM.isLoggedIn {
                    SecondaryButton(text: "Log out") {
                        showSignoutAlert = true
                    }
                    Spacer()
                } else {
                    TemporaryViewForLogin(screenId: 3) {
                        toLoginScreen = true
                    } toSignup: {
                        toSignupScreen = true
                    }
                }
            }//End of VStack
            .padding(.horizontal)
            .navigationDestination(isPresented: $toLoginScreen) {
                LoginView(tab: self.$tab)
            }
            .navigationDestination(isPresented: $toSignupScreen) {
                SignupView(tab: self.$tab)
            }
            .alert("", isPresented: $showSignoutAlert) {
                Button("Log out", role: .destructive) {
                    performSignout()
                }
            } message: {
                Text("Are you sure you want to log out?")
            }

        }//end of NavStack
    }
}

#Preview {
    @Previewable @State var test = 1
    ProfileView(tab: $test)
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
}
