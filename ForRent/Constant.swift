//
//  Constant.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-02-24.
//

import Foundation
import CoreLocation

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
    
    struct TorontoDistrict {
        static let Toronto = CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832)
        static let York = CLLocationCoordinate2D(latitude: 43.6956, longitude: -79.4500)
        static let NorthYork = CLLocationCoordinate2D(latitude: 43.7615, longitude: -79.4111)
        static let EastYork = CLLocationCoordinate2D(latitude: 43.6995, longitude: -79.3320)
        static let Etobicoke = CLLocationCoordinate2D(latitude: 43.6205, longitude: -79.5132) 
        static let Scarborough = CLLocationCoordinate2D(latitude: 43.7764, longitude: -79.2318)
    }
    
    struct Rules {
        static let statement = "We ask every guest to remember a few simple things about what makes a great guest"
        static let ruleOne = "- Follow the house rules"
        static let ruleTwo = "- Treat your Host's home like your own"
        static let agree = "By selecting the button below, I agree  to the Host's House Rules, Ground rules for guests, ForRent's Rebooking and Refund Poilicu, and that ForRent can charge my payment method if I'm responsible for damage."
    }
}
