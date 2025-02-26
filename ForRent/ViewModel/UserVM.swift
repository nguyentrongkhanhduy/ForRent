//
//  UserVM.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-25.
//

import Foundation
import Observation
import FirebaseFirestore
import FirebaseAuth

@Observable
class UserVM {
    static let shared = UserVM()
    
    var user = User()
    
    private var db: Firestore {
        return Firestore.firestore()
    }
    
    private init() {}
    
    func createUser() {
        do {
            try db
                .collection("users")
                .document(user.id.uuidString)
                .setData(from: user)
            print(
                "User created successfully in Firestore with UUID: \(String(describing: user.id))"
            )
        } catch {
            print("Error saving user to Firestore: \(error.localizedDescription)")
        }
        
    }
}
