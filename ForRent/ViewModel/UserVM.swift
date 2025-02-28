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
    var errorMessage = ""
    
    private var db: Firestore {
        return Firestore.firestore()
    }
    
    private init() {}
    
    func maskEmail() -> String {
        guard let atIndex = self.user.email.firstIndex(of: "@") else {
            return self.user.email
        }
        
        let prefix = self.user.email[..<atIndex]
        let domain = self.user.email[atIndex...]
        
        if prefix.count <= 2 {
            return "\(prefix)****\(domain)"
        }
        
        let firstChar = prefix.prefix(1)
        let lastChar = prefix.suffix(1)
        let asteriskCount = prefix.count - 2
        let asteriskString = String(repeating: "*", count: asteriskCount)
        
        return "\(firstChar)\(asteriskString)\(lastChar)\(domain)"
    }
    
    func maskCardNumber() -> String {
        if user.cardNumber.isEmpty {
            return "Empty"
        }
        
        let asteriskString = String(repeating: "*", count: 8)
        
        return "\(user.cardNumber.prefix(1))\(asteriskString)\(user.cardNumber.suffix(1))"
    }
    
    func setUserIDandEmail(uid: String, email: String) -> Bool {
        if !uid.isEmpty && !email.isEmpty {
            self.user.id = uid
            self.user.email = email
            return true
        }
        return false
    }
    
    func createUser() {
        do {
            try db
                .collection("users")
                .document(user.id)
                .setData(from: user)
            print(
                "User created successfully in Firestore with UUID: \(String(describing: user.id))"
            )
        } catch {
            print("Error saving user to Firestore: \(error.localizedDescription)")
        }
        
    }
    
    func updatePersonalInfo(completion: @escaping (Bool) -> Void) {
        if !checkFields() {
            completion(false)
            return
        } else {
            db.collection("users").document(user.id).updateData([
                "username" : user.username,
                "legalName" : user.legalName,
                "phone" : user.phone,
                "address" : user.address
            ]) { error in
                if let unwrappedError = error {
                    self.errorMessage = unwrappedError.localizedDescription
                    completion(false)
                } else {
                    self.errorMessage = ""
                    completion(true)
                }
            }
        }
    }
    
    func updatePaymentMethod(cardNumber: String, completion: @escaping (Bool) -> Void) {
        user.cardNumber = cardNumber
        db.collection("users").document(user.id).updateData([
            "cardNumber" : user.cardNumber
        ]) { error in
            if let unwrappedError = error {
                self.errorMessage = unwrappedError.localizedDescription
                completion(false)
            } else {
                self.errorMessage = ""
                completion(true)
            }
        }
    }
    
    private func checkFields() -> Bool {
        if self.user.legalName.isEmpty || self.user.username.isEmpty {
            errorMessage = "Name fields cannot be empty."
            return false
        }
        
        if self.user.phone.count != 10 {
            errorMessage = "Incorrect format phone number."
            return false
        }
        
        return true
    }
    
    func updateAvatar(url: String, completion: @escaping (Bool) -> Void) {
        user.avatarURL = url
        db.collection("users").document(user.id).updateData([
            "avatarURL" : user.avatarURL
        ]) { error in
            if let unwrappedError = error {
                self.errorMessage = unwrappedError.localizedDescription
                completion(false)
            } else {
                self.errorMessage = ""
                completion(true)
            }
        }
    }
    
    func fetchUserInfo(completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No authenticated user found.")
            completion(false)
            return
        }
        
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let document = document, document.exists {
                do {
                    self.user = try document.data(as: User.self)
                    completion(true)
                    print("User data loaded successfully!")
                } catch {
                    completion(false)
                    print("Error decoding user data: \(error.localizedDescription)")
                }
            } else {
                print("No user document found in Firestore.")
                completion(false)
            }
        }
    }
}
