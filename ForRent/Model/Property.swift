//
//  Property.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-01.
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct Property: Codable, Hashable {
    @DocumentID var id = ""
    var ownerId = ""
    var title = ""
    var bedroom = 0
    var bathroom = 0
    var guest = 0
    var description = ""
    var imgURL = ""
    var isAvailable = false
    var isDelisted = false
    var price = 0.0
    var coordinate: GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0)
    var dateAdded: Date = Date()
    var dateUpdated: Date = Date()
    var dateAvailable: Date = Date()
    
    var coordinate2D: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
    }
}

extension Date {
    func getShortMonthDayFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        return formatter.string(from: self)
    }
    
    func getFullFormatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMMM dd"
        return formatter.string(from: self)
    }

    func getShortestMonthDayFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: self)
    }
}
