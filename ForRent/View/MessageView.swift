//
//  MessageView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-24.
//

import SwiftUI

struct MessageView: View {
    @Environment(AuthenticationVM.self) var authenticationVM
    @Environment(UserVM.self) var userVM
    @Environment(PropertyVM.self) var propertyVM
    @Environment(LocationVM.self) var locationVM
    @Environment(RequestVM.self) var requestVM
    
    @AppStorage("currentRole") private var currentRole: String = "Guest"
    
    @State private var toLoginScreen = false
    @State private var toSignupScreen = false
    
    @Binding var tab: Int
    
    var body: some View {
        NavigationStack {
            VStack {
                if authenticationVM.isLoggedIn {
                    Text("Messages")
                        .font(.custom(Constant.Font.semiBold, size: 30))
                        .foregroundStyle(Color(Constant.Color.primaryText))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    if currentRole == "Guest" {
                        if requestVM.listUserRequest.isEmpty {
                            VStack {
                                Text("Empty")
                                    .font(.custom(Constant.Font.semiBold, size: 20))
                                    .foregroundStyle(Color(Constant.Color.sencondaryText))
                                Spacer()
                            }
                            .padding(30)
                        } else {
                            List {
                                ForEach(requestVM.listUserRequest, id:\.self) { request in
                                    NavigationLink {
                                        RequestCancelView(request: request)
                                    } label: {
                                        RequestRow(request: request)
                                    }
                                        .listRowSeparator(.hidden)
                                        .padding(.bottom, 30)
                                }
                            }
                            .listStyle(.plain)
                        }
                    }
                    
                    
                    
                    Spacer()
                    
                } else {
                    TemporaryViewForLogin(screenId: 2) {
                        toLoginScreen = true
                    } toSignup: {
                        toSignupScreen = true
                    }
                    .padding(.horizontal)
                }
            }//End of VStack
            
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
    MessageView(tab: $test)
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
        .environment(PropertyVM.shared)
        .environment(LocationVM.shared)
        .environment(RequestVM.shared)
}
