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
    let statusOptions = ["Pending", "Approved", "Denied", "Cancelled"]
    
    // Define equal spacing for status buttons
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 4)

    var body: some View {
        VStack(spacing: 6) { // Reduce vertical spacing
            HStack {
                // Role Selection
                Menu {
                    ForEach(roleOptions, id: \.self) { option in
                        Button {
                            self.role = option
                        } label: {
                            Text(option)
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
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(role == "All" ? .white : .black)
                            .stroke(Color.black)
                    )
                }
                Spacer()
            }
            .padding(.horizontal)
            
            // Status Buttons Aligned with List Width
            if role != "All" {
                LazyVGrid(columns: columns, spacing: 6) { // Even spacing
                    ForEach(statusOptions, id: \.self) { option in
                        Button {
                            status = option
                        } label: {
                            Text(option)
                                .font(.custom(Constant.Font.semiBold, size: 14))
                                .foregroundStyle(status == option ? .white : .black)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity) // Make all buttons equal width
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(status == option ? .black : .white)
                                        .stroke(Color.black)
                                )
                        }
                    }
                }
                .padding(.horizontal, 16) // Aligns with list width
                .padding(.top, 4)
                .padding(.bottom, 4)
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.3), value: role)
            }
        }
        .onChange(of: role) { _, _ in
            status = "All"
        }
    }
}
//
//#Preview {
//    RequestFilterBar()
//}
