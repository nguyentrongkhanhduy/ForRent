//
//  WishlistsView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-24.
//

import SwiftUI

struct WishlistView: View {
    @Environment(AuthenticationVM.self) var authenticationVM
    @Environment(UserVM.self) var userVM
    
    @State private var toLoginScreen = false
    @State private var toSignupScreen = false
    
    @Binding var tab: Int
    
    var body: some View {
        NavigationStack {
            VStack {
                if authenticationVM.isLoggedIn {
                    
                } else {
                    TemporaryViewForLogin(screenId: 1) {
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
        }//End of NavStack
    }//End of body
}

#Preview {
    @Previewable @State var test = 1
    WishlistView(tab: $test)
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
}
