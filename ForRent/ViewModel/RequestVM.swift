//
//  RequestVM.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-07.
//

import Foundation
import Observation
import FirebaseFirestore
import FirebaseAuth

@Observable
class RequestVM {
    static let shared = RequestVM()
    
    var listUserRequest = [Request]()
    var listOwnerRequest = [Request]()
    
    private var db: Firestore {
        return Firestore.firestore()
    }
    
    private init() {}
    
    func fetchAllOwnerRequest(ownerId: String) {
        
    }
    
    func fetchAllUserRequest(userId: String) {
        db
            .collection("requests")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { snapshot, error in
                if error != nil {
                    print("Error fetching requests")
                    return
                }
                
                guard let unwrappedSnapshot = snapshot else {
                    print("No request found")
                    return
                }
                
                for change in unwrappedSnapshot.documentChanges {
                    do {
                        let request = try change.document.data(as: Request.self)
                        
                        switch change.type {
                        case .added:
                            if !self.listUserRequest
                                .contains(where: { $0.id == request.id }) {
                                self.listUserRequest.append(request)
                            }
                        case .modified:
                            if let index = self.listUserRequest.firstIndex(where: { item in
                                item.id == request.id
                            }) {
                                self.listUserRequest[index] = request
                            }
                        case .removed:
                            self.listUserRequest.removeAll { item in
                                item.id == request.id
                            }
                        }
                    } catch {
                        print("Error decoding request")
                    }
                }
            }
    }
    
    func createRequest(request: Request, completion: @escaping (Bool) -> Void) {
        do {
            try db.collection("requests").addDocument(from: request) { error in
                if error != nil {
                    print("Error adding new request")
                    completion(false)
                    return
                }
                
                print("New request added successfully")
                completion(true)
                
            }
        } catch {
            print("Error decoding new request")
            completion(false)
        }
    }
    
    func cancelRequest(requestId: String, completion: @escaping (Bool) -> Void) {
        db.collection("requests").document(requestId).updateData([
            "status" : "Cancelled"
        ]) { error in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
}
