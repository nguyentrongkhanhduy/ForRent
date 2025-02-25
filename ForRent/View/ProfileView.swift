//
//  ProfileView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-24.
//

import SwiftUI

struct ProfileView: View {
    @State private var toLoginScreen = false
    @State private var toSignupScreen = false
    
    @Binding var tab: Int
    
    var body: some View {
        NavigationStack {
            VStack {
                TemporaryViewForLogin(screenId: 3) {
                    toLoginScreen = true
                } toSignup: {
                    toSignupScreen = true
                }
                                
                Spacer()
            }//end of VStack
            .navigationDestination(isPresented: $toLoginScreen) {
                LoginView(tab: self.$tab)
            }
            .navigationDestination(isPresented: $toSignupScreen) {
                SignupView()
            }
        }//end of NavStack
        .accentColor(Color(Constant.Color.primaryText))
    }
}

#Preview {
    @Previewable @State var test = 1
    ProfileView(tab: $test)
}
