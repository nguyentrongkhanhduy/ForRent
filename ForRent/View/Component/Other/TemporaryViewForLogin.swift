//
//  TemporaryView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-24.
//

import SwiftUI

struct TemporaryViewForLogin: View {
    var screenId: Int
    var toLogin: () -> Void
    var toSignup: () -> Void
    
    var body: some View {
        VStack {
            if screenId == 3 {
                Text("Log in to start planning your next trip.")
                    .font(.custom(Constant.Font.regular, size: 20))
                    .foregroundStyle(Color(Constant.Color.sencondaryText))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 5)
                
                
            } else if screenId == 2 {
                VStack {
                    Text("Log in to see messages")
                        .font(.custom(Constant.Font.semiBold, size: 20))
                        .foregroundStyle(Color(Constant.Color.primaryText))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    Text("Once you log in, you'll find your messages here")
                        .font(.custom(Constant.Font.regular, size: 14))
                        .foregroundStyle(Color(Constant.Color.sencondaryText))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 5)
                
            } else {
                VStack {
                    Text("Log in to view your wishlist")
                        .font(.custom(Constant.Font.semiBold, size: 20))
                        .foregroundStyle(Color(Constant.Color.primaryText))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    Text("You can view or edit wishlist once you've logged in")
                        .font(.custom(Constant.Font.regular, size: 14))
                        .foregroundStyle(Color(Constant.Color.sencondaryText))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 5)
            }
            
            PrimaryButton(text: "Log in") { toLogin() }
            .padding(.top, 40)

            HStack {
                Text("Don't have an account?")
                    .font(.custom(Constant.Font.regular, size: 15))
                Button {
                    toSignup()
                } label: {
                    Text("Sign up")
                        .font(.custom(Constant.Font.semiBold, size: 15))
                        .underline()
                }
            }
            .foregroundStyle(Color(Constant.Color.primaryText))
            .padding(.top, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
                            
            Spacer()
        }
    }
}

#Preview {
    TemporaryViewForLogin(screenId: 3) {} toSignup: {}
}
