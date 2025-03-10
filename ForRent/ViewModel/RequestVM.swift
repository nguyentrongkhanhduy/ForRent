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
        db.collection("requests")
            .whereField("ownerId", isEqualTo: ownerId)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching owner requests: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("No owner requests found")
                    return
                }
                
                for change in snapshot.documentChanges {
                    do {
                        let request = try change.document.data(as: Request.self)
                        switch change.type {
                        case .added:
                            if !self.listOwnerRequest.contains(where: { $0.id == request.id }) {
                                self.listOwnerRequest.append(request)
                            }
                        case .modified:
                            if let index = self.listOwnerRequest.firstIndex(where: { $0.id == request.id }) {
                                self.listOwnerRequest[index] = request
                            }
                        case .removed:
                            self.listOwnerRequest.removeAll { $0.id == request.id }
                        }
                    } catch {
                        print("Error decoding owner request: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func fetchAllUserRequest(userId: String) {
        db.collection("requests")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching user requests: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("No user requests found")
                    return
                }
                
                for change in snapshot.documentChanges {
                    do {
                        let request = try change.document.data(as: Request.self)
                        switch change.type {
                        case .added:
                            if !self.listUserRequest.contains(where: { $0.id == request.id }) {
                                self.listUserRequest.append(request)
                            }
                        case .modified:
                            if let index = self.listUserRequest.firstIndex(where: { $0.id == request.id }) {
                                self.listUserRequest[index] = request
                            }
                        case .removed:
                            self.listUserRequest.removeAll { $0.id == request.id }
                        }
                    } catch {
                        print("Error decoding user request: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func createRequest(request: Request, completion: @escaping (Bool) -> Void) {
        do {
            try db.collection("requests").addDocument(from: request) { error in
                if let error = error {
                    print("Error adding new request: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                print("New request added successfully")
                completion(true)
            }
        } catch {
            print("Error encoding new request: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func cancelRequest(requestId: String, completion: @escaping (Bool) -> Void) {
        db.collection("requests").document(requestId).updateData([
            "status": "Cancelled"
        ]) { error in
            if let error = error {
                print("Error cancelling request: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // Helper method to update request status.
    private func updateRequestStatus(requestId: String, status: String, completion: @escaping (Bool) -> Void) {
        db.collection("requests").document(requestId).updateData([
            "status": status
        ]) { error in
            if let error = error {
                print("Error updating request (\(status)): \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func approveRequest(requestId: String, completion: @escaping (Bool) -> Void) {
        updateRequestStatus(requestId: requestId, status: "Approved", completion: completion)
    }
    
    func denyRequest(requestId: String, completion: @escaping (Bool) -> Void) {
        updateRequestStatus(requestId: requestId, status: "Denied", completion: completion)
    }
}
