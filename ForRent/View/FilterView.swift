//
//  FilterView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-02.
//

import SwiftUI

struct FilterView: View {
    @Binding var desiredPrice: String
    @Binding var  selectedArea: String
    @Binding var  selectedBed: String
    @Binding var selectedBath: String
    @Binding var selectedGuest: String
    @Binding var selectedDate: Date
    
    let areaOptions = Constant.PropertyProperties.areaOptions
    let bedroomOptions = Constant.PropertyProperties.bedroomOptions
    let bathroomOptions = Constant.PropertyProperties.bathroomOptions
    let guestOptions = Constant.PropertyProperties.guestOptions

    private func clearAll() {
        desiredPrice = ""
        selectedArea = ""
        selectedBed = ""
        selectedBath = ""
        selectedGuest = ""
        selectedDate = Date()
    }
    
    let search: () -> Void
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Customize Your Search")
                    .font(.custom(Constant.Font.semiBold, size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    Text("Desired price")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(Constant.Font.semiBold, size: 16))
                    HStack() {
                        Image(systemName: "dollarsign")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 15)
                            .aspectRatio(1, contentMode: .fit)
                        TextField("0", text: $desiredPrice)
                            .font(.custom(Constant.Font.regular, size: 16))
                            .keyboardType(.decimalPad)
                        Text("/night")
                            .font(.custom(Constant.Font.regular, size: 16))
                    }
                    .padding()
                    .foregroundStyle(Color(Constant.Color.primaryText))
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.clear)
                            .stroke(Color(Constant.Color.primaryText), lineWidth: 1)
                    )
                    .padding(.top, -8)
                }
                .padding(.top, 8)
                
                VStack {
                    Text("Where to?")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(Constant.Font.semiBold, size: 16))
                    
                    CustomizedPicker(
                        options: areaOptions,
                        placeholder: "Area",
                        selectedValue: $selectedArea
                    )
                    .padding(.top, -8)
                }
                .padding(.top, 8)
                
                VStack {
                    Text("When's your trip?")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(Constant.Font.semiBold, size: 16))
                    
                    DatePicker(
                        "Select a Date",
                        selection: $selectedDate,
                        in: Date()...,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                    .padding(.top, -20)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                .padding(.top, 8)
                
                VStack {
                    Text("Who's coming?")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(Constant.Font.semiBold, size: 16))
                    
                    CustomizedPicker(
                        options: guestOptions,
                        placeholder: "Guests",
                        selectedValue: $selectedGuest
                    )
                    .padding(.top, -8)
                }
                .padding(.top, 8)
                
                VStack {
                    Text("What do you need?")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(Constant.Font.semiBold, size: 16))
                    HStack {
                        CustomizedPicker(
                            options: bedroomOptions,
                            placeholder: "Bedrooms",
                            selectedValue: $selectedBed
                        )
                        
                        CustomizedPicker(
                            options: bathroomOptions,
                            placeholder: "Bathrooms",
                            selectedValue: $selectedBath
                        )
                    }
                    .padding(.top, -8)
                }
                .padding(.top, 8)
                
                HStack {
                    Button {
                        clearAll()
                    } label: {
                        Text("Clear all")
                            .font(.custom(Constant.Font.regular, size: 14))
                            .foregroundStyle(Color(Constant.Color.primaryText))
                            .underline()
                    }

                    
                    Spacer()
                    
                    SearchButton {
                        search()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                Spacer()
            }
            .padding()
        }
        
    }
}

#Preview {
    @Previewable @State var test1 = ""
    @Previewable @State var test2 = ""
    @Previewable @State var test3 = ""
    @Previewable @State var test4 = ""
    @Previewable @State var test5 = ""
    @Previewable @State var test6 = Date()
    FilterView(desiredPrice: $test1,
               selectedArea: $test2,
               selectedBed: $test3,
               selectedBath: $test4,
               selectedGuest: $test5,
               selectedDate: $test6) {}
}
