//
//  Monster.swift
//  Monsters
//
//  Created by Maxim Alekseev on 04.01.2021.
//

import Foundation
import CoreLocation

struct Monster {
    
    let name: String
    let imageName: String
    var level: Int
    var coordinate: CLLocationCoordinate2D
    
    mutating func setNewLocation(_ newCoordinate: CLLocationCoordinate2D) {
        self.coordinate = newCoordinate
    }

}


