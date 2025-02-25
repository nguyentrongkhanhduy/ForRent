//
//  LoginViewModel.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-24.
//

import Foundation
import Observation
import FirebaseAuth

@Observable
class AuthenticationVM {
    static let shared = AuthenticationVM()
    
    var email: String = ""
    var password: String = ""
    var errorMessage: String = ""
    
    private init() {}
    
    func validateCredentials() -> Bool {
        errorMessage = ""
        
        if !isValidEmail(email) {
            errorMessage = "Invalid email format"
            return false
        }
        
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters"
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func loginUser() {
        if !validateCredentials() {
            return
        }
    }
}
