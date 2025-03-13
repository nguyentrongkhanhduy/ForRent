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
    @Environment(UserVM.self) var userVM
    @AppStorage("currentRole") private var currentRole: String = "Guest"
    @Binding var tab: Int
    
    // This view is initialized with an existing Request.
    let request: Request
    
    // Fetched property details.
    @State private var property: Property?
    @State private var userInfo: User?
    
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
                        
                        if let user = userInfo {
                            VStack(alignment: .leading) {
                                Text(currentRole == "Guest" ? "Host Information" : "Guest Information")
                                    .font(.custom(Constant.Font.semiBold, size: 18))
                                    .padding()

                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        HStack {
                                            Text("Username:")
                                                .font(.custom(Constant.Font.semiBold, size: 15))
                                            Spacer()
                                            Text(user.username)
                                                .font(.custom(Constant.Font.regular, size: 15))
                                                .foregroundStyle(Color(Constant.Color.primaryText))
                                        }

                                        HStack {
                                            Text("Email:")
                                                .font(.custom(Constant.Font.semiBold, size: 15))
                                            Spacer()
                                            Text(user.email)
                                                .font(.custom(Constant.Font.regular, size: 15))
                                                .foregroundStyle(Color(Constant.Color.primaryText))
                                        }

                                        HStack {
                                            Text("Phone:")
                                                .font(.custom(Constant.Font.semiBold, size: 15))
                                            Spacer()
                                            Text(user.phone.isEmpty ? "N/A" : user.phone)
                                                .font(.custom(Constant.Font.regular, size: 15))
                                                .foregroundStyle(Color(Constant.Color.primaryText))
                                        }
                                    }
                                }
                                .background(Color.white)
                                .padding(.horizontal)
                            }
                        }
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
                                PrimaryButton(text: "Approve Request") {
                                    showAlert = true
                                    alertTitle = "Approve Request"
                                    alertMessage = "Are you sure you want to approve this request?"
                                }
                                .padding()
                                SecondaryButton(text: "Deny Request") {
                                    showAlert = true
                                    alertTitle = "Deny Request"
                                    alertMessage = "Are you sure you want to deny this request?"
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
                            } else if curStatus == "Denied" {
                                SecondaryButton(text: "Request Denied") {
                                    
                                }
                                .padding()
                            } else if curStatus == "Approved" {
                                SecondaryButton(text: "Request Approved") {
                                    
                                }
                                .padding()
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding(.bottom, 30)
            }
            .alert(alertTitle, isPresented: $showAlert) {
                if alertTitle == "Approve Request" || alertTitle == "Deny Request" || alertTitle == "Cancel Request" {
                    Button("Cancel", role: .cancel) { } // This appears only for confirmation alerts
                    Button("OK", role: .destructive) {
                        if alertTitle == "Approve Request" {
                            approveRequest()
                        } else if alertTitle == "Deny Request" {
                            denyRequest()
                        } else if alertTitle == "Cancel Request" {
                            cancelRequest()
                        }
                    }
                } else {
                    // Success/Error alerts → Only OK button, no Cancel
                    Button("OK", role: .cancel) { }
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
                
                let userId = currentRole == "Guest" ? request.ownerId : request.userId
                userVM.fetchOwnerInfo(ownerId: userId) { user in
                    self.userInfo = user
                }
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
                curStatus = "Approved"
                if var currentProperty = property {
                    currentProperty.dateAvailable = request.dateEnd
                    propertyVM.updateProperty(property: currentProperty) { updateSuccess in
                        alertTitle = "Success"
                        alertMessage = updateSuccess ?
                            "Request approved and property availability updated." :
                            "Request approved, but failed to update property availability."
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
                curStatus = "Denied"
                alertTitle = "Success"
                alertMessage = "Request denied successfully."
            } else {
                alertTitle = "Error"
                alertMessage = "Failed to deny request."
            }
            showAlert = true
        }
    }

    func cancelRequest() {
        guard let reqId = request.id, !reqId.isEmpty else { return }
        requestVM.cancelRequest(requestId: reqId) { success in
            if success {
                curStatus = "Cancelled"
                alertTitle = "Success"
                alertMessage = "Request cancelled."
            } else {
                alertTitle = "Error"
                alertMessage = "Failed to cancel request."
            }
            showAlert = true
        }
    }
}

//#Preview {
//    RequestCancelView()
//}
