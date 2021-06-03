//
//  Location.swift
//  GBFrameworks
//
//  Created by Vitaly Prosvetov on 01.06.2021.
//

import Foundation
import MapKit
import RealmSwift

class Location: Object {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Location {
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
