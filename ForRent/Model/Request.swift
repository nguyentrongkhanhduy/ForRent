//
//  Request.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-07.
//

import Foundation
import FirebaseFirestore

struct Request: Codable, Hashable {
    @DocumentID var id = ""
    var userId = ""
    var ownerId = ""
    var propertyId = ""
    var dateRequest = Date()
    var dateBegin = Date()
    var dateEnd = Date()
    var status = "" //Pending/Approved/Denied/Cancelled
}
