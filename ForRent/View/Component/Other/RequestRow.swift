//
//  RequestRow.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-07.
//

import SwiftUI

struct RequestRow: View {
    @Environment(UserVM.self) var userVM
    @Environment(PropertyVM.self) var propertyVM
    @Environment(LocationVM.self) var locationVM
    @Environment(RequestVM.self) var requestVM

    @AppStorage("currentRole") private var currentRole: String = "Guest" // Check user role
    
    @State private var owner: User = User()
    @State private var guestName: String = ""
    @State private var property: Property = Property()

    let request: Request
    
    private func fetchRequestData() {
        // Fetch host (property owner) info
        userVM.fetchOwnerInfo(ownerId: request.ownerId) { owner in
            if let ownerData = owner {
                self.owner = ownerData
            }
        }

        // Fetch guest (only if current role is a host)
        if currentRole != "Guest" {
            userVM.fetchOwnerInfo(ownerId: request.userId) { guest in
                if let guestData = guest {
                    self.guestName = guestData.username
                } else {
                    self.guestName = "Unknown"
                }
            }
        }
        
        // Fetch property info
        propertyVM.getPropertyById(propertyId: request.propertyId) { property in
            if let propertyData = property {
                self.property = propertyData
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            SquareImage(imgURL: property.imgURL, size: 90, radius: 10)
                .padding(.trailing)
            VStack(alignment: .leading) {
                HStack {
                    Text("Trip requested")
                        .font(.custom(Constant.Font.regular, size: 14))
                    Spacer()
                    Text(request.dateRequest.getShortMonthDayFormat())
                        .font(.custom(Constant.Font.regular, size: 14))
                }
                .foregroundStyle(Color(Constant.Color.primaryText))
                
                Text(property.title)
                    .font(.custom(Constant.Font.semiBold, size: 16))
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                if currentRole != "Guest" {
                    Text("Guest: \(guestName)")
                        .font(.custom(Constant.Font.regular, size: 14))
                        .foregroundStyle(Color(Constant.Color.sencondaryText))
                } else {
                    Text("Host: \(owner.username)")
                        .font(.custom(Constant.Font.regular, size: 14))
                        .foregroundStyle(Color(Constant.Color.sencondaryText))
                }
                
                HStack {
                    Text(
                        "\(request.dateBegin.getShortestMonthDayFormat()) - \(request.dateEnd.getShortestMonthDayFormat())"
                    )
                        .font(.custom(Constant.Font.regular, size: 14))
                        .foregroundStyle(Color(Constant.Color.sencondaryText))
                    Spacer()
                    Text(request.status)
                        .font(.custom(Constant.Font.semiBold, size: 14))
                        .foregroundStyle(Color(Constant.Color.sencondaryText))
                }
            }
            Spacer()
        }
        .onAppear {
            fetchRequestData()
        }
    }
}

//#Preview {
//    RequestRow()
//        .environment(AuthenticationVM.shared)
//        .environment(UserVM.shared)
//        .environment(PropertyVM.shared)
//        .environment(LocationVM.shared)
//        .environment(RequestVM.shared)
//}
