//
//  RequestView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-05.
//

import SwiftUI

struct RequestView: View {
    @Environment(\.dismiss) var dismiss
    
    @Environment(UserVM.self) var userVM
    @Environment(PropertyVM.self) var propertyVM
    @Environment(LocationVM.self) var locationVM
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    let property: Property
    
    private func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        
        let startDate = calendar.startOfDay(for: start)
        let endDate = calendar.startOfDay(for: end)
        
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return max(components.day! + 1, 1)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    SummaryRow(property: property)
                    
                    Divider()
                        .frame(height: 5)
                        .background(Color(.systemGray5))
                    
                    VStack(alignment: .leading) {
                        Text("Your trip")
                            .font(.custom(Constant.Font.semiBold, size: 18))
                            .padding(.bottom, 8)
                        
                        VStack(alignment: .leading) {
                            Text("Guests")
                                .font(.custom(Constant.Font.semiBold, size: 15))
                            Text("\(property.guest) \(property.guest > 1 ? "guests" : "guest")")
                                .font(.custom(Constant.Font.regular, size: 14))
                        }
                        .padding(.bottom, 8)
                        
                        HStack(alignment: .firstTextBaseline) {
                            VStack(alignment: .leading) {
                                Text("Start date")
                                    .font(.custom(Constant.Font.semiBold, size: 15))
                                    .padding(.bottom)
                                Text(startDate.getFullFormatDate())
                                    .font(.custom(Constant.Font.regular, size: 14))
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Choose your end date")
                                    .font(.custom(Constant.Font.semiBold, size: 15))
                                DatePicker(
                                    "",
                                    selection: $endDate,
                                    in: startDate...,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(.compact)
                            }
                        }
                    }
                    .foregroundStyle(Color(Constant.Color.primaryText))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .frame(height: 5)
                        .background(Color(.systemGray5))
                    
                    VStack(alignment: .leading) {
                        Text("Price details")
                            .font(.custom(Constant.Font.semiBold, size: 18))
                            .padding(.bottom, 8)
                        
                        VStack {
                            HStack {
                                Text("$\(String(format: "%.2f", property.price)) CAD x \(daysBetween(start: startDate, end: endDate)) \(daysBetween(start: startDate, end: endDate) > 1 ? "nights" : "night")")
                                Spacer()
                                Text("$\(String(format: "%.2f", property.getSubTotal(days: daysBetween(start: startDate, end: endDate)))) CAD")
                            }
                            .padding(.bottom, 4)
                            HStack {
                                Text("Cleaning fee")
                                Spacer()
                                Text("$\(String(format: "%.2f", property.getCleaningFee(days: daysBetween(start: startDate, end: endDate)))) CAD")
                            }
                            .padding(.bottom, 4)
                            HStack {
                                Text("ForRent service fee")
                                Spacer()
                                Text("$\(String(format: "%.2f", property.getServiceFee(days: daysBetween(start: startDate, end: endDate)))) CAD")
                            }
                            .padding(.bottom, 4)
                            HStack {
                                Text("Taxes")
                                Spacer()
                                Text("$\(String(format: "%.2f", property.getTax(days: daysBetween(start: startDate, end: endDate)))) CAD")
                            }
                            .padding(.bottom, 4)
                            Divider()
                                .padding(.bottom, 4)
                        }
                        .font(.custom(Constant.Font.regular, size: 16))
                        
                        VStack {
                            HStack {
                                Text("Total (CAD)")
                                Spacer()
                                Text("$\(String(format: "%.2f", property.getFinalTotal(days: daysBetween(start: startDate, end: endDate)))) CAD")
                            }
                            .font(.custom(Constant.Font.semiBold, size: 16))
                            .padding(.bottom, 4)
                            HStack {
                                Spacer()
                                Button {
                                    
                                } label: {
                                    Text("More info")
                                        .font(.custom(Constant.Font.semiBold, size: 14))
                                        .underline()
                                }
                            }
                        }
                    }
                    .foregroundStyle(Color(Constant.Color.primaryText))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .frame(height: 5)
                        .background(Color(.systemGray5))
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("Pay with")
                                .font(.custom(Constant.Font.semiBold, size: 18))
                                .foregroundStyle(Color(Constant.Color.primaryText))
                                .padding(.bottom, 8)
                            
                            if !userVM.user.cardNumber.isEmpty {
                                Text("Card: \(userVM.maskCardNumber())")
                                    .font(
                                        .custom(Constant.Font.regular, size: 14)
                                    )
                                    .foregroundStyle(
                                        Color(Constant.Color.sencondaryText)
                                    )
                            }
                        }
                        
                        Spacer()
                        BorderdClearedBackgroundButton(
                            text: userVM.user.cardNumber.isEmpty ? "Add card" : "Change"
                        ) {
                            
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .frame(height: 5)
                        .background(Color(.systemGray5))
                    
                    if userVM.user.phone.isEmpty || userVM.user.avatarURL.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Required for your trip")
                                .font(.custom(Constant.Font.semiBold, size: 18))
                                .foregroundStyle(Color(Constant.Color.primaryText))
                                .padding(.bottom, 8)
                            
                            if userVM.user.phone.isEmpty {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading) {
                                        Text("Phone number")
                                            .font(.custom(Constant.Font.semiBold, size: 15))
                                        Text("Add your phone number to get trip updates")
                                            .font(.custom(Constant.Font.regular, size: 14))
                                            .foregroundStyle(
                                                Color(Constant.Color.sencondaryText)
                                            )
                                    }
                                    Spacer()
                                    BorderdClearedBackgroundButton(text: "Add") {
                                        
                                    }
                                }
                            }
                            
                            if userVM.user.avatarURL.isEmpty {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading) {
                                        Text("Profile photo")
                                            .font(.custom(Constant.Font.semiBold, size: 15))
                                        Text("Hosts want to know who's staying at their place")
                                            .font(.custom(Constant.Font.regular, size: 14))
                                            .foregroundStyle(
                                                Color(Constant.Color.sencondaryText)
                                            )
                                    }
                                    Spacer()
                                    BorderdClearedBackgroundButton(text: "Add") {
                                        
                                    }
                                }
                            }
                            
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                            .frame(height: 5)
                            .background(Color(.systemGray5))
                    }//requirements end
                    
                    VStack(alignment: .leading) {
                        Text("Ground rules")
                            .font(.custom(Constant.Font.semiBold, size: 18))
                            .foregroundStyle(Color(Constant.Color.primaryText))
                            .padding(.bottom, 8)
                        Text(Constant.Rules.statement)
                            .font(.custom(Constant.Font.regular, size: 12))
                            .foregroundStyle(
                                Color(Constant.Color.sencondaryText)
                            )
                            .padding(.bottom, 8)
                        Text(Constant.Rules.ruleOne)
                            .font(.custom(Constant.Font.regular, size: 12))
                            .foregroundStyle(
                                Color(Constant.Color.sencondaryText)
                            )
                        Text(Constant.Rules.ruleTwo)
                            .font(.custom(Constant.Font.regular, size: 12))
                            .foregroundStyle(
                                Color(Constant.Color.sencondaryText)
                            )
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .frame(height: 5)
                        .background(Color(.systemGray5))
                    
                    Text(Constant.Rules.agree)
                        .font(.custom(Constant.Font.regular, size: 12))
                        .foregroundStyle(
                            Color(Constant.Color.sencondaryText)
                        )
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    PrimaryButton(text: "Request to book") {
                        
                    }
                    .padding()
                    
                }//end of vstack
            }// end of scroll view
            .onAppear(perform: {
                startDate = property.dateAvailable
            })
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
        }// end of navstack
    }
}

//#Preview {
//    RequestView()
//        .environment(AuthenticationVM.shared)
//        .environment(UserVM.shared)
//        .environment(PropertyVM.shared)
//        .environment(LocationVM.shared)
//}
