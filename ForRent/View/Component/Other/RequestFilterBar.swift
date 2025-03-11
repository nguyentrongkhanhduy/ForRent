//
//  RequestFilterBar.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-11.
//

import SwiftUI

struct RequestFilterBar: View {
    @Binding var role: String
    @Binding var status: String
    let roleOptions = ["All", "Travelling", "Hosting"]
//    let statusOptions = ["All", "Pending", "Approved", "Denied", "Cancelled"]
    
    var body: some View {
        VStack {
            HStack {
                Menu {
                    ForEach(roleOptions, id:\.self) { role in
                        Button {
                            self.role = role
                        } label: {
                            Text(role)
                        }
                    }
                } label: {
                    HStack {
                        Text(self.role)
                            .foregroundColor(role == "All" ? .black : .white)
                            .font(.custom(Constant.Font.semiBold, size: 14))
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(role == "All" ? .white : .black)
                            .stroke(Color.black)
                    )
                }
                Spacer()
            }
            .padding(.horizontal)
            
            HStack{
                Button {
                    status = "Pending"
                } label: {
                    Text("Pending")
                        .font(.custom(Constant.Font.semiBold, size: 14))
                        .foregroundStyle(status != "Pending" ? .black : .white)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(status != "Pending" ? .white : .black)
                                .stroke(Color.black)
                                
                        )
                }
                
                Spacer()
                
                Button {
                    status = "Approved"
                } label: {
                    Text("Approved")
                        .font(.custom(Constant.Font.semiBold, size: 14))
                        .foregroundStyle(status != "Approved" ? .black : .white)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(status != "Approved" ? .white : .black)
                                .stroke(Color.black)
                        )
                }
                
                Spacer()
                
                Button {
                    status = "Denied"
                } label: {
                    Text("Denied")
                        .font(.custom(Constant.Font.semiBold, size: 14))
                        .foregroundStyle(status != "Denied" ? .black : .white)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(status != "Denied" ? .white : .black)
                                .stroke(Color.black)
                        )
                }
                
                Spacer()
                
                Button {
                    status = "Cancelled"
                } label: {
                    Text("Cancelled")
                        .font(.custom(Constant.Font.semiBold, size: 14))
                        .foregroundStyle(status != "Cancelled" ? .black : .white)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(status != "Cancelled" ? .white : .black)
                                .stroke(Color.black)
                        )
                }
            }
            .padding(.horizontal)
            .opacity(role == "All" ? 0 : 1)
            .animation(.easeInOut(duration: 0.3), value: role)

            
        }
        .onChange(of: role) { oldValue, newValue in
            status = "All"
        }
    }
}
//
//#Preview {
//    RequestFilterBar()
//}
