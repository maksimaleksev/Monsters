//
//  MonsterAnnotation.swift
//  Monsters
//
//  Created by Maxim Alekseev on 05.01.2021.
//

import UIKit
import MapKit

class MonsterAnnotation: NSObject, MKAnnotation {
                
    var coordinate: CLLocationCoordinate2D    
    var title: String?
    var imageName: String
    var monsterLevel: Int
    
    init(monster: Monster) {
        self.coordinate = monster.coordinate
        self.title = monster.name
        self.imageName = monster.imageName
        self.monsterLevel = monster.level
    }
}
