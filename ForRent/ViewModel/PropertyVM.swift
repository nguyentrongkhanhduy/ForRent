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
    
    var errorMessage = ""
    
    private var db: Firestore {
        return Firestore.firestore()
    }
    
    private init() {}
    
    func fetchAllProperty() {
        db
            .collection("properties")
            .whereField("isAvailable", isEqualTo: true)
            .whereField("isDelisted", isEqualTo: false).addSnapshotListener {
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
    
    func getFilteredProperties(price: String, bath: String, bed: String, guest: String, date: Date) -> [Property] {
            return listProperty.filter { property in
                (price.isEmpty || property.price <= Double(price) ?? Double.infinity) &&
                (bath.isEmpty || String(property.bathroom) == bath) &&
                (bed.isEmpty || String(property.bedroom) == bed) &&
                (guest.isEmpty || String(property.guest) == guest)
                && (date <= property.dateAvailable)
            }
        }
    
    func getWishlistProperties(wishList: [String]) -> [Property] {
        return listProperty.filter { property in
            guard let propertyId = property.id else {
                return false
            }
            return wishList.contains { id in
                propertyId == id
            }
        }
    }
    
    func getPropertyById(propertyId: String, completion: @escaping (Property?) -> Void) {
        db
            .collection("properties")
            .document(propertyId)
            .getDocument { snapshot, error in
                if error != nil {
                    completion(nil)
                    return
                }
                
                guard let snapshot = snapshot, snapshot.exists,
                      let propertyData = try? snapshot.data(as: Property.self) else {
                    completion(nil)
                    return
                }
                
                completion(propertyData)
            }
    }
}


