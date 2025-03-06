//
//  RequestView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-05.
//

import SwiftUI

struct RequestView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                SummaryRow()
                
                Divider()
                    .frame(height: 5)
                    .background(Color(.systemGray5))
                
                VStack {
                    Text("Your trip")
                        .font(.custom(Constant.Font.semiBold, size: 18))
                    
                    
                }
                .foregroundStyle(Color(Constant.Color.primaryText))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                        }

                        Text("Request to Book")
                            .font(.custom(Constant.Font.semiBold, size: 18))
                            .padding(.leading)
                    }
                    .foregroundStyle(Color(Constant.Color.primaryText))
                }
            }
            
            
        }
    }
}

#Preview {
    RequestView()
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
        .environment(PropertyVM.shared)
        .environment(LocationVM.shared)
}
