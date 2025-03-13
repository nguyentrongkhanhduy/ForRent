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
    @State private var role = "All"
    @State private var status = "All"

    @Binding var tab: Int

    var filteredRequests: [Request] {
        requestVM.filterRequest(userId: authenticationVM.userID, role: role, status: status)
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Messages")
                    .font(.custom(Constant.Font.semiBold, size: 30))
                    .foregroundStyle(Color(Constant.Color.primaryText))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                
                if authenticationVM.isLoggedIn {
                    RequestFilterBar(role: $role, status: $status)
                    
                    if filteredRequests.isEmpty {
                        VStack {
                            Text("No matching requests.")
                                .font(.custom(Constant.Font.semiBold, size: 20))
                                .foregroundStyle(Color(Constant.Color.sencondaryText))
                            Spacer()
                        }
                        .padding(30)
                    } else {
                        List {
                            ForEach(filteredRequests, id: \.self) { request in
                                NavigationLink {
                                    RequestCancelView(tab: $tab, request: request)
                                } label: {
                                    RequestRow(request: request)
                                }
                                .listRowSeparator(.hidden)
                                .padding(.bottom)
                            }
                        }
                        .listStyle(.plain)
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
            .padding(.bottom)
            .navigationDestination(isPresented: $toLoginScreen) {
                LoginView(tab: $tab)
            }
            .navigationDestination(isPresented: $toSignupScreen) {
                SignupView(tab: $tab)
            }
            .onAppear {
                requestVM.fetchAllRequest()
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
