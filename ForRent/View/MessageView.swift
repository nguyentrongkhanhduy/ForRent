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
                    if currentRole == "Guest" {
                        // Tenant's messages (user requests)
                        if requestVM.listUserRequest.isEmpty {
                            VStack {
                                Text("No messages yet.")
                                    .font(.custom(Constant.Font.semiBold, size: 20))
                                    .foregroundStyle(Color(Constant.Color.sencondaryText))
                                Spacer()
                            }
                            .padding(30)
                        } else {
                            List {
                                ForEach(requestVM.listUserRequest, id: \.self) { request in
                                    NavigationLink {
                                        RequestCancelView(tab: $tab, request: request)
                                    } label: {
                                        RequestRow(request: request)
                                    }
                                    .listRowSeparator(.hidden)
                                    .padding(.bottom, 30)
                                }
                            }
                            .padding(.vertical, 30)
                            .listStyle(.plain)
                        }
                    } else {
                        // Host's messages (owner requests)
                        if requestVM.listOwnerRequest.isEmpty {
                            VStack {
                                Text("No incoming requests.")
                                    .font(.custom(Constant.Font.semiBold, size: 20))
                                    .foregroundStyle(Color(Constant.Color.sencondaryText))
                                Spacer()
                            }
                            .padding(30)
                        } else {
                            List {
                                ForEach(requestVM.listOwnerRequest, id: \.self) { request in
                                    NavigationLink {
                                        // Navigate to the host's RequestView.
                                        RequestCancelView(tab: $tab, request: request)
                                    } label: {
                                        RequestRow(request: request)
                                    }
                                    .listRowSeparator(.hidden)
                                    .padding(.bottom, 30)
                                }
                            }
                            .padding(.vertical, 30)
                            .listStyle(.plain)
                        }
                    }
                } else {
                    TemporaryViewForLogin(screenId: 2) {
                        toLoginScreen = true
                    } toSignup: {
                        toSignupScreen = true
                    }
                    .padding(.horizontal)
                }
            }
            .navigationDestination(isPresented: $toLoginScreen) {
                LoginView(tab: $tab)
            }
            .navigationDestination(isPresented: $toSignupScreen) {
                SignupView(tab: $tab)
            }
            .onAppear {
                if currentRole == "Guest" {
                    requestVM.fetchAllUserRequest(userId: authenticationVM.userID)
                } else {
                    requestVM.fetchAllOwnerRequest(ownerId: authenticationVM.userID)
                }
            }
        }
    }
}

//#Preview {
//    @Previewable @State var test = 1
//    MessageView(tab: $test)
//        .environment(AuthenticationVM.shared)
//        .environment(UserVM.shared)
//        .environment(PropertyVM.shared)
//        .environment(LocationVM.shared)
//        .environment(RequestVM.shared)
//}
