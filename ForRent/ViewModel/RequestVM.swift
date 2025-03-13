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
    var listRequest = [Request]()
    
    private var db: Firestore {
        return Firestore.firestore()
    }
    
    private init() {}
    
    func filterUserRequest(status: String) -> [Request] {
        if status == "All" {
            return self.listUserRequest
        } else {
            return self.listUserRequest.filter { request in
                request.status == status
            }
        }
    }
    
    func filterOwnerRequest(status: String) -> [Request] {
        if status == "All" {
            return self.listOwnerRequest
        } else {
            return self.listOwnerRequest.filter { request in
                request.status == status
            }
        }
    }
    
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
        // First, update the status of the request to "Approved"
        updateRequestStatus(requestId: requestId, status: "Approved") { success in
            if success {
                // Fetch the approved request details
                self.db.collection("requests").document(requestId).getDocument { snapshot, error in
                    guard let snapshot = snapshot, snapshot.exists,
                          let approvedRequest = try? snapshot.data(as: Request.self) else {
                        print("Error fetching approved request details: \(error?.localizedDescription ?? "Unknown error")")
                        completion(false)
                        return
                    }

                    // Get all pending requests for the same property
                    self.db.collection("requests")
                        .whereField("propertyId", isEqualTo: approvedRequest.propertyId)
                        .whereField("status", isEqualTo: "Pending")
                        .getDocuments { snapshot, error in
                            guard let documents = snapshot?.documents, error == nil else {
                                print("Error fetching pending requests: \(error?.localizedDescription ?? "Unknown error")")
                                completion(true) // Still consider it successful if the update succeeded
                                return
                            }

                            for document in documents {
                                let otherRequest = try? document.data(as: Request.self)

                                // Skip the approved request
                                if otherRequest?.id == requestId {
                                    continue
                                }

                                // Check if the request overlaps with the approved request
                                if let otherRequest = otherRequest,
                                   (otherRequest.dateBegin < approvedRequest.dateEnd &&
                                    otherRequest.dateEnd > approvedRequest.dateBegin) {
                                    
                                    // Deny the request
                                    self.denyRequest(requestId: otherRequest.id!) { _ in }
                                }
                            }
                            
                            completion(true) // Final success completion after processing all requests
                        }
                }
            } else {
                completion(false)
            }
        }
    }
    
    func denyRequest(requestId: String, completion: @escaping (Bool) -> Void) {
        updateRequestStatus(requestId: requestId, status: "Denied", completion: completion)
    }
}
