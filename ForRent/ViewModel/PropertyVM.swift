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
            .whereField("isAvailable", isEqualTo: true).addSnapshotListener {
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
                (bath.isEmpty || property.bathroom == Int(bath.prefix(1))) &&
                (bed.isEmpty || property.bedroom == Int(bed.prefix(1))) &&
                (guest.isEmpty || property.guest == Int(guest.prefix(1)))
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

extension PropertyVM {
    func addProperty(property: Property, completion: @escaping (Bool) -> Void) {
        do {
            _ = try db.collection("properties").addDocument(from: property) { error in
                if let error = error {
                    print("Error adding property: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Property added successfully.")
                    completion(true)
                }
            }
        } catch {
            print("Error encoding property: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func updateProperty(property: Property, completion: @escaping (Bool) -> Void) {
        guard let propertyId = property.id, !propertyId.isEmpty else {
            print("Property id is nil or empty")
            completion(false)
            return
        }
        do {
            try db.collection("properties").document(propertyId).setData(from: property, merge: true) { error in
                if let error = error {
                    print("Error updating property: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Property updated successfully.")
                    completion(true)
                }
            }
        } catch {
            print("Error encoding property: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func updatePropertyStatus(propertyId: String, isDelisted: Bool, completion: @escaping (Bool) -> Void) {
        let propertyRef = Firestore.firestore().collection("properties").document(propertyId)
        
        propertyRef.updateData(["isDelisted": isDelisted]) { error in
            if let error = error {
                print("Error updating property status: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
