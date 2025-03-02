//
//  ListPropertyView.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-01.
//

import SwiftUI

struct ListPropertyView: View {
    @Environment(AuthenticationVM.self) var authenticationVM
    @Environment(UserVM.self) var userVM
    @Environment(PropertyVM.self) var propertyVM
    @Environment(LocationVM.self) var locationVM
    
    @State private var showMap = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(propertyVM.listProperty, id: \.self) { property in
                        ListItem(property: property) {
                            print(property.title)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding(.bottom)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                
                VStack {
                    Spacer()
                    MapButton {
                        showMap = true
                    }
                    .padding(.bottom)
                }
            }
            .sheet(isPresented: $showMap) {
                ExploreView()
            }
        }
        
    }
}

#Preview {
    ListPropertyView()
        .environment(AuthenticationVM.shared)
        .environment(UserVM.shared)
        .environment(PropertyVM.shared)
        .environment(LocationVM.shared)
}
