//
//  DBService.swift
//  GBFrameworks
//
//  Created by Vitaly Prosvetov on 03.06.2021.
//

import Foundation
import MapKit
import RealmSwift

class DBService {
    static let shared = DBService()
    private let realm = try! Realm()
    
    private init() {}
    
    func save(location: Location) {
        try! realm.write {
            realm.add(location)
        }
    }
    
    func removeAllLocation() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func getLocation() -> [Location] {
        //let routePoints = realm.objects(Location.self)
        realm.objects(Location.self).map{ $0 }
        
        //return routePoints.map { $0.clLocationCoordinate2D }
    }
    
}
