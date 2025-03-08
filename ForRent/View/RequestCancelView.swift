//
//  RequestCancelView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-08.
//

import SwiftUI

struct RequestCancelView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(UserVM.self) var userVM
    @Environment(PropertyVM.self) var propertyVM
    @Environment(LocationVM.self) var locationVM
    @Environment(RequestVM.self) var requestVM
    
    @State private var property: Property?
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var curStatus = ""
    
    let request: Request
    
    private func fetchRequestData() {
        propertyVM.getPropertyById(propertyId: request.propertyId) { property in
            self.property = property
        }
        
        startDate = request.dateBegin
        endDate = request.dateEnd
        curStatus = request.status
    }
    
    private func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        
        let startDate = calendar.startOfDay(for: start)
        let endDate = calendar.startOfDay(for: end)
        
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return max(components.day! + 1, 1)
    }
    
    private func performCancelRequest() {
        requestVM.cancelRequest(requestId: request.id!) { success in
            if success {
                showAlert = true
                alertTitle = "Request Cancelled"
                alertMessage = ""
                curStatus = "Cancelled"
            } else {
                
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if let property = self.property {
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
                                    Text(startDate.getFullFormatDate())
                                        .font(.custom(Constant.Font.regular, size: 14))
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("End date")
                                        .font(.custom(Constant.Font.semiBold, size: 15))
                                    Text(endDate.getFullFormatDate())
                                        .font(.custom(Constant.Font.regular, size: 14))
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
                                //                            HStack {
                                //                                Spacer()
                                //                                Button {
                                //
                                //                                } label: {
                                //                                    Text("More info")
                                //                                        .font(.custom(Constant.Font.semiBold, size: 14))
                                //                                        .underline()
                                //                                }
                                //                            }
                            }
                        }
                        .foregroundStyle(Color(Constant.Color.primaryText))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                            .frame(height: 5)
                            .background(Color(.systemGray5))
                        
                        if curStatus == "Pending" {
                            SecondaryButton(text: "Cancel Request") {
                                showAlert = true
                                alertTitle = "Cancel Request"
                                alertMessage = "Are you sure you want to cancel this request?"
                            }
                            .padding()
                        } else if curStatus == "Cancelled" {
                            SecondaryButton(text: "Request Cancelled") {
                                
                            }
                            .padding()
                        }
                        
                        Spacer()
                    }
                }
                
            }//end of scroll view
            .onAppear {
                fetchRequestData()
            }
            .alert(alertTitle, isPresented: $showAlert) {
                if alertTitle == "Cancel Request" {
                    Button("Cancel", role: .cancel) {}
                    Button("OK", role: .destructive) {
                        performCancelRequest()
                    }
                } else {
                    Button("OK", role: .cancel) {}
                }
            } message: {
                Text(alertMessage)
            }

        }
        
    }
}

//#Preview {
//    RequestCancelView()
//}
