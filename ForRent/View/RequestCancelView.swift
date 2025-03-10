//
//  RequestCancelView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-08.
//

import SwiftUI
import FirebaseFirestore
import MapKit

struct RequestCancelView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(PropertyVM.self) var propertyVM
    @Environment(RequestVM.self) var requestVM
    @AppStorage("currentRole") private var currentRole: String = "Guest"
    @Binding var tab: Int
    
    // This view is initialized with an existing Request.
    let request: Request
    
    // Fetched property details.
    @State private var property: Property?
    
    // For local date display.
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    // Request status.
    @State private var curStatus: String = ""
    
    // Alert state.
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if let property = property {
                        // Property summary section.
                        SummaryRow(property: property)
                        
                        Divider()
                            .frame(height: 5)
                            .background(Color(.systemGray5))
                        
                        // Request details section.
                        VStack(alignment: .leading) {
                            Text("Request Details")
                                .font(.custom(Constant.Font.semiBold, size: 18))
                                .padding(.bottom, 8)
                            
                            HStack(alignment: .firstTextBaseline) {
                                VStack(alignment: .leading) {
                                    Text("Start Date")
                                        .font(.custom(Constant.Font.semiBold, size: 15))
                                    Text(startDate.getFullFormatDate())
                                        .font(.custom(Constant.Font.regular, size: 14))
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("End Date")
                                        .font(.custom(Constant.Font.semiBold, size: 15))
                                    Text(endDate.getFullFormatDate())
                                        .font(.custom(Constant.Font.regular, size: 14))
                                }
                            }
                        }
                        .foregroundStyle(Color(Constant.Color.primaryText))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                            .frame(height: 5)
                            .background(Color(.systemGray5))
                        
                        // Price details section.
                        VStack(alignment: .leading) {
                            Text("Price Details")
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
                            }
                        }
                        .foregroundStyle(Color(Constant.Color.primaryText))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                            .frame(height: 5)
                            .background(Color(.systemGray5))
                        
                        // Action Buttons – host mode vs guest mode.
                        if currentRole != "Guest" {
                            if curStatus == "Pending" {
                                SecondaryButton(text: "Approve Request") {
                                    showAlert = true
                                    alertTitle = "Approve Request"
                                    alertMessage = "Are you sure you want to approve this request?"
                                    approveRequest()
                                }
                                .padding()
                                SecondaryButton(text: "Deny Request") {
                                    showAlert = true
                                    alertTitle = "Deny Request"
                                    alertMessage = "Are you sure you want to deny this request?"
                                    denyRequest()
                                }
                                .padding()
                            }
                        } else {
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
                        }
                        
                        Spacer()
                    }
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Request Details")
            .alert(alertTitle, isPresented: $showAlert) {
                Button("Ok", role: .cancel) {
                    if alertTitle == "Success" {
                        dismiss()
                        tab = 2
                    }
                }
            } message: {
                Text(alertMessage)
            }
            .onAppear {
                propertyVM.getPropertyById(propertyId: request.propertyId) { fetchedProperty in
                    if let fetchedProperty = fetchedProperty {
                        self.property = fetchedProperty
                    }
                }
                startDate = request.dateBegin
                endDate = request.dateEnd
                curStatus = request.status
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: start)
        let endDay = calendar.startOfDay(for: end)
        let components = calendar.dateComponents([.day], from: startDay, to: endDay)
        return max((components.day ?? 0) + 1, 1)
    }
    
    // MARK: - Host Action Functions
    
    func approveRequest() {
        guard let reqId = request.id, !reqId.isEmpty else { return }
        requestVM.approveRequest(requestId: reqId) { success in
            if success {
                // If the property is available, update its available date.
                if var currentProperty = property {
                    currentProperty.dateAvailable = request.dateEnd
                    propertyVM.updateProperty(property: currentProperty) { updateSuccess in
                        if updateSuccess {
                            alertTitle = "Success"
                            alertMessage = "Request approved and property availability updated."
                        } else {
                            alertTitle = "Success"
                            alertMessage = "Request approved, but failed to update property availability."
                        }
                        showAlert = true
                    }
                } else {
                    alertTitle = "Success"
                    alertMessage = "Request approved successfully."
                    showAlert = true
                }
            } else {
                alertTitle = "Error"
                alertMessage = "Failed to approve request."
                showAlert = true
            }
        }
    }
    
    func denyRequest() {
        guard let reqId = request.id, !reqId.isEmpty else { return }
        requestVM.denyRequest(requestId: reqId) { success in
            if success {
                alertTitle = "Success"
                alertMessage = "Request denied successfully."
                showAlert = true
            } else {
                alertTitle = "Error"
                alertMessage = "Failed to deny request."
                showAlert = true
            }
        }
    }
    
    func cancelRequest() {
        guard let reqId = request.id, !reqId.isEmpty else { return }
        requestVM.cancelRequest(requestId: reqId) { success in
            if success {
                alertTitle = "Success"
                alertMessage = "Request cancelled successfully."
                showAlert = true
            } else {
                alertTitle = "Error"
                alertMessage = "Failed to cancel request."
                showAlert = true
            }
        }
    }
}

//#Preview {
//    RequestCancelView()
//}
