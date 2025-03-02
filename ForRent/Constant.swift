//
//  Constant.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-24.
//

import Foundation

struct Constant {
    struct Color {
        static let primaryColor = "AirBnBColor"
        static let primaryText = "DarkGrayText"
        static let sencondaryText = "GrayText"
        static let subText = "LightGrayText"
    }
    
    struct Font {
        static let bold = "Poppins-Bold"
        static let regular = "Poppins-Regular"
        static let semiBold = "Poppins-SemiBold"
    }
    
    struct PropertyProperties {
        static let areaOptions = ["Toronto", "York", "East York", "North York", "Etobicoke", "Scarborough"]
        static let bedroomOptions = ["1 Bed", "2 Beds", "3 Beds", "4 Beds", "5 Beds"]
        static let bathroomOptions = ["1 Bath", "2 Baths", "3 Baths"]
        static let guestOptions = ["1 guest", "2 guests", "3 guests", "4 guests", "5 guests", "6 guests", "7 guests"]
    }
}
