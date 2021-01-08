//
//  MonsterAnnotation.swift
//  Monsters
//
//  Created by Maxim Alekseev on 05.01.2021.
//

import UIKit
import MapKit

class MonsterAnnotation: NSObject, MKAnnotation {
    
    var monster: Monster
    var coordinate: CLLocationCoordinate2D
    var imageName: String
    var title: String?
        
    init(monster: Monster) {
        self.coordinate = monster.coordinate
        self.title = monster.name
        self.imageName = monster.imageName
        self.monster = monster
    }
}
