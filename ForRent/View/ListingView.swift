//
//  ListingView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-08.
//

import SwiftUI

struct ListingView: View {
    @Binding var tab: Int
    
    var body: some View {
        Text("My listing")
    }
}

#Preview {
    @Previewable @State var test = 1
    ListingView(tab: $test)
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
        .environment(PropertyVM.shared)
        .environment(LocationVM.shared)
        .environment(RequestVM.shared)
}
