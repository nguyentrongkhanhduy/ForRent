//
//  User.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-25.
//

import Foundation

struct User: Codable, Hashable {
    //required fields to sign up
    var id = ""
    var email = ""
    var username = ""
    
    //required fields to request/list a property
    var phone = ""
    var cardNumber = ""
    
    //optional fields (edit later)
    var wishList = [String]()
    var avatarURL = ""
    var about = ""
}
