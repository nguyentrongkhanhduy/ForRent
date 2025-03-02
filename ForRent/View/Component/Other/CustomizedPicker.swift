//
//  CustomizedPicker.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-02.
//

import SwiftUI

struct CustomizedPicker: View {
    var options: [String]
    var placeholder: String
    @Binding var selectedValue: String
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selectedValue = option
                }) {
                    Text(option)
                }
            }
        } label: {
            HStack {
                Text(selectedValue.isEmpty ? placeholder : selectedValue)
                    .font(.headline)
                    .foregroundColor(Color(Constant.Color.primaryText))
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(Color(Constant.Color.sencondaryText))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(Constant.Color.primaryText), lineWidth: 1)
            )
        }
    }
}

#Preview {
    @Previewable @State var testValue = ""
    let testArray = ["1", "2", "3"]
    CustomizedPicker(options: testArray, placeholder: "test", selectedValue: $testValue)
}
