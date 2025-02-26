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
    
    private var dbAuth: Auth {
        return Auth.auth()
    }
    
    var email: String = ""
    var errorMessage: String = ""
    
    private init() {}
    
    func validateCredentials(email: String, password: String, confirmPassword: String = "", signUp: Bool = false) -> Bool {
        errorMessage = ""
        
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please fill all fields"
            return false
        }
        
        if !isValidEmail(email) {
            errorMessage = "Invalid email format"
            return false
        }
        
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters"
            return false
        }
        
        if signUp {
            if confirmPassword.isEmpty {
                errorMessage = "Please fill all fields"
                return false
            }
            
            if password != confirmPassword {
                errorMessage = "Passwords do not match"
                return false
            }
        }
        
        return true
    }
    
    
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func loginUser(password: String) {
        if !validateCredentials(email: self.email, password: password) {
            return
        }
        
        dbAuth.signIn(withEmail: self.email, password: password) { result, error in
            if let unwrappedError = error {
                self.errorMessage = unwrappedError.localizedDescription
            } else {
                self.errorMessage = ""
            }
        }
    }
    
    func signUpUser(password: String, confirmPassword: String) {
        if !validateCredentials(
            email: self.email,
            password: password,
            confirmPassword: confirmPassword,
            signUp: true
        ) {
            return
        }
        
        dbAuth
            .createUser(withEmail: self.email, password: password) { result, error in
                if let unwrappedError = error {
                    self.errorMessage = unwrappedError.localizedDescription
                } else {
                    self.errorMessage = ""
                }
            }
    }
}
