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
    
    @AppStorage("currentRole") private var currentRole: String = "Guest"
    
    @Binding var tab: Int
    
    private func performSignout() {
        authenticationVM.signOut() {
            //            self.tab = 0
        }
    }
    
    @State private var avatarURL = ""
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if authenticationVM.isLoggedIn {
                    ZStack {
                        VStack {
                            NavigationLink {
                                ChangeAvatarView()
                            } label: {
                                HStack {
                                    AvatarImage(avatarURL: avatarURL, size: 45)
                                    VStack(alignment: .leading) {
                                        Text(userVM.user.username)
                                            .font(
                                                .custom(
                                                    Constant.Font.semiBold,
                                                    size: 18
                                                )
                                            )
                                            .foregroundStyle(
                                                Color(
                                                    Constant.Color.primaryText
                                                )
                                            )
                                        Text(currentRole)
                                            .font(.custom(Constant.Font.regular, size: 12))
                                            .foregroundStyle(
                                                Color(Constant.Color.sencondaryText)
                                            )
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(
                                            Constant.Color.primaryText
                                        ))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            
                            Divider()
                            
                            Text("Settings")
                                .font(.custom(Constant.Font.semiBold, size: 20))
                                .padding(.vertical, 20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            NavigationLink {
                                PersonalInformation()
                            } label: {
                                HStack {
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18, height: 18)
                                        .foregroundStyle(Color(
                                            Constant.Color.primaryText
                                        ))
                                    Text("Personal information")
                                        .font(
                                            .custom(
                                                Constant.Font.regular,
                                                size: 16
                                            )
                                        )
                                        .foregroundStyle(
                                            Color(
                                                Constant.Color.primaryText
                                            )
                                        )
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(
                                            Constant.Color.primaryText
                                        ))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            Divider()
                            
                            NavigationLink {
                                ChangePasswordView()
                            } label: {
                                HStack {
                                    Image(systemName: "lock.shield")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18, height: 18)
                                        .foregroundStyle(Color(
                                            Constant.Color.primaryText
                                        ))
                                    Text("Change password")
                                        .font(
                                            .custom(
                                                Constant.Font.regular,
                                                size: 16
                                            )
                                        )
                                        .foregroundStyle(
                                            Color(
                                                Constant.Color.primaryText
                                            )
                                        )
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(
                                            Constant.Color.primaryText
                                        ))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.top, 10)
                            Divider()
                            
                            NavigationLink {
                                PaymentInfo()
                            } label: {
                                HStack {
                                    Image(systemName: "creditcard.and.123")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18, height: 18)
                                        .foregroundStyle(Color(
                                            Constant.Color.primaryText
                                        ))
                                    Text("Payments")
                                        .font(
                                            .custom(
                                                Constant.Font.regular,
                                                size: 16
                                            )
                                        )
                                        .foregroundStyle(
                                            Color(
                                                Constant.Color.primaryText
                                            )
                                        )
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(
                                            Constant.Color.primaryText
                                        ))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.top, 10)
                            Divider()
                            
                            
                            SecondaryButton(text: "Log out") {
                                showSignoutAlert = true
                            }
                            .padding(.top, 30)
                            Spacer()
                        }//bottom layer content
                        
                        VStack {
                            Spacer()
                            MoreRoundedButton(text: "Switch to hosting") {
                                
                            }
                        }//top layer button
                    }
                    
                } else {
                    TemporaryViewForLogin(screenId: 3) {
                        toLoginScreen = true
                    } toSignup: {
                        toSignupScreen = true
                    }
                }
            }//End of VStack
            .onAppear(perform: {
                avatarURL = userVM.user.avatarURL
            })
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
        .environment(PropertyVM.shared)
        .environment(LocationVM.shared)
}
