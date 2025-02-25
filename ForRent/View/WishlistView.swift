//
//  WishlistsView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-24.
//

import SwiftUI

struct WishlistView: View {
    @State private var toLoginScreen = false
    @State private var toSignupScreen = false
    
    @Binding var tab: Int
    
    var body: some View {
        NavigationStack {
            VStack {
                TemporaryViewForLogin(screenId: 1) {
                    toLoginScreen = true
                } toSignup: {
                    toSignupScreen = true
                }
            }//End of VStack
            .navigationDestination(isPresented: $toLoginScreen) {
                LoginView(tab: self.$tab)
            }
            .navigationDestination(isPresented: $toSignupScreen) {
                SignupView()
            }
        }//End of NavStack
    }//End of body
}

#Preview {
    @Previewable @State var test = 1
    WishlistView(tab: $test)
}
