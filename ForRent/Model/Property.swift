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
    var isAvailable = true //-> false when approve request
    var isDelisted = false // only for owner to see when delisted = true -> user cannot see
    var price = 0.0
    var coordinate: GeoPoint = GeoPoint(latitude: 0.0, longitude: 0.0) //firebase type
    var dateAdded: Date = Date()
    var dateUpdated: Date = Date()
    var dateAvailable: Date = Date() //update to the dateEnd when request approve
    
    var coordinate2D: CLLocationCoordinate2D { //geocoder
        return CLLocationCoordinate2D(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
    }
    
    func getSubTotal(days: Int) -> Double {
        return self.price * Double(days)
    }
    
    func getCleaningFee(days: Int) -> Double {
        return getSubTotal(days: days) * 3 / 100
    }
    
    func getServiceFee(days: Int) -> Double {
        return self.getSubTotal(days: days) * 4 / 100
    }
    
    func getTax(days: Int) -> Double {
        return self.getSubTotal(days: days) * 13 / 100
    }
    
    func getFinalTotal(days: Int) -> Double {
        return getSubTotal(days: days) + getServiceFee(days: days) + getTax(days: days) + getCleaningFee(days: days)
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
