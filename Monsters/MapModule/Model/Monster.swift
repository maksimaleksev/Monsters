//
//  Monster.swift
//  Monsters
//
//  Created by Maxim Alekseev on 04.01.2021.
//

import Foundation
import CoreLocation

struct Monster {
    
    let id = UUID().uuidString
    var name: String?
    var imageName: String?
    var location: CLLocationCoordinate2D?
    
    mutating func setNewLocation(_ newLocation: CLLocationCoordinate2D) {
        self.location = newLocation
    }
}


