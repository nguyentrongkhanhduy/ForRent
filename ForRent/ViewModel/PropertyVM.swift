//
//  PropertyVM.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-01.
//

import Foundation
import Observation
import FirebaseFirestore
import FirebaseAuth

@Observable
class PropertyVM {
    static let shared = PropertyVM()
    
    var listProperty = [Property]()
    var cityStateCountryCache: [String : String] = [:]
    var errorMessage = ""
    
    private var db: Firestore {
        return Firestore.firestore()
    }
    
    private init() {}
    
    func fetchAllProperty() {
        db.collection("properties").addSnapshotListener {
 snapshot,
 error in
            if error != nil {
                print("Error fetching properties")
                return
            }
            
            guard let unwrappedSnapshot = snapshot else {
                print("No properties found")
                return
            }
            
            for change in unwrappedSnapshot.documentChanges {
                do {
                    let property = try change.document.data(as: Property.self)
                    
                    switch change.type {
                    case .added:
                        if !self.listProperty.contains(where: { $0.id == property.id }) {
                            self.listProperty.append(property)
                        }
                    case .modified:
                        if let index = self.listProperty.firstIndex(where: { item in
                            item.id == property.id
                        }) {
                            self.listProperty[index] = property
                        }
                    case .removed:
                        self.listProperty.removeAll { item in
                            item.id == property.id
                        }
                    }
                } catch {
                    print("Error decoding property")
                }
            }
        }
    }
}
