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
    
//    var isLoggedIn: Bool {
//        return dbAuth.currentUser != nil
//    }
    var isLoggedIn = false
    
    var userID: String {
        if isLoggedIn {
            return dbAuth.currentUser!.uid
        } else {
            return ""
        }
    }
    var email: String = ""
    var errorMessage: String = ""
    
    private init() {}
    
    func validateCredentials(email: String, password: String, confirmPassword: String = "", username: String = "", legalName: String = "", signUp: Bool = false) -> Bool {
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
            if confirmPassword.isEmpty || username.isEmpty || legalName.isEmpty {
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
    
    func loginUser(password: String, completion: @escaping (Bool) -> Void) {
        if !validateCredentials(email: self.email, password: password) {
            completion(false)
            return
        }
        
        dbAuth.signIn(withEmail: self.email, password: password) { result, error in
            if error != nil {
                self.errorMessage = "Incorrect email or password."
                self.email = ""
                completion(false)
            } else {
                self.errorMessage = ""
                self.isLoggedIn = true
                completion(true)
            }
        }
    }
    
    func signUpUser(
        password: String,
        confirmPassword: String,
        username: String,
        legalName: String,
        completion: @escaping
        (Bool) -> Void) {
            if !validateCredentials(
                email: self.email,
                password: password,
                confirmPassword: confirmPassword,
                username: username,
                legalName: legalName,
                signUp: true
            ) {
                completion(false)
                return
            }
            
            dbAuth
                .createUser(withEmail: self.email, password: password) { result, error in
                    if let unwrappedError = error as NSError? {
                        switch unwrappedError.code {
                        case AuthErrorCode.emailAlreadyInUse.rawValue:
                            self.errorMessage = "The email address is already in use."
                        case AuthErrorCode.invalidEmail.rawValue:
                            self.errorMessage = "Invalid email format."
                        case AuthErrorCode.weakPassword.rawValue:
                            self.errorMessage = "Password must be at least 6 characters."
                        case AuthErrorCode.networkError.rawValue:
                            self.errorMessage = "Network error. Check your internet connection."
                        case AuthErrorCode.operationNotAllowed.rawValue:
                            self.errorMessage = "Email/password sign-up is disabled."
                        case AuthErrorCode.tooManyRequests.rawValue:
                            self.errorMessage = "Too many attempts. Try again later."
                        default:
                            self.errorMessage = unwrappedError.localizedDescription
                        }
                        completion(false)
                    } else {
                        self.errorMessage = ""
                        self.isLoggedIn = true
                        completion(true)
                    }
                }
        }
    
    func signOut(completion: @escaping () -> Void) {
        do {
            try dbAuth.signOut()
            self.email = ""
            self.errorMessage = ""
            self.isLoggedIn = false
            UserVM.shared.user = User() //reset user
            completion()
        } catch {
            print("Error signing out")
            self.errorMessage = "Failed to sign out"
        }
    }
    
    func changePassword(currentPassword: String, newPassword: String, completion: @escaping (Bool) -> Void) {
        guard let user = dbAuth.currentUser, let email = user.email else {
            self.errorMessage = "No authenticated user found."
            completion(false)
            return
        }
        
        let credential = EmailAuthProvider.credential(
            withEmail: email,
            password: currentPassword
        )
        
        user.reauthenticate(with: credential) { result, error in
            if let unwrappedError = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Re-authentication failed: \(unwrappedError.localizedDescription)"
                    completion(false)
                }
                return
            }
            
            user.updatePassword(to: newPassword) { error in
                if error != nil {
                    self.errorMessage = "New password update failed."
                    completion(false)
                } else {
                    self.errorMessage = ""
                    completion(true)
                }
            }
        }
    }
}
