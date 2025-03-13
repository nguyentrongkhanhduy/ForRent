//
//  FilterRequestBar.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-12.
//

import SwiftUI

struct FilterRequestBar: View {
    @Binding var status: String
    let statusOptions = ["All", "Pending", "Approved", "Denied", "Cancelled"]
    
    var body: some View {
        VStack {
            Menu {
                ForEach(statusOptions, id: \.self) { option in
                    Button {
                        self.status = option
                    } label: {
                        Text(option)
                    }
                }
            } label: {
                HStack {
                    Spacer()
                    Text(self.status)
                        .font(.custom(Constant.Font.semiBold, size: 16))
                        .foregroundStyle(Color(Constant.Color.primaryText))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(8)
                .frame(width: 150, alignment: .trailing)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .stroke(.black)
                )
            }
        }
    }
}

//#Preview {
//    FilterRequestBar()
//}
