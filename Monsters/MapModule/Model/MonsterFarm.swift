//
//  MonsterGenerator.swift
//  Monsters
//
//  Created by Maxim Alekseev on 05.01.2021.
//

import Foundation
import CoreLocation

class MonsterFarm {
    
    static let shared = MonsterFarm()
    
    private let monsterNames:[String:String] = ["altair": "Altair", "amyrose": "Amy Rose", "articuno": "Articuno", "bobby": "Bobby", "bulbasaur": "Bulbasaur", "charizard": "Charizard", "chicky": "Chicky", "connielyn": "Connie Lyn", "dragon": "Dragon", "dragonite": "Dragonite",
                                                "freddy": "Freddy", "frizza": "Frizza", "gyrados": "Gyrados", "hulk": "Hulk", "mew-mewtwo": "Mew", "moltres": "Moltres", "mudkipz": "Mudkipz", "pikachu": "Pikachu", "pinky": "Pinky", "piplup": "Piplup", "queen": "Queen", "rabloox": "Rabloox", "robot": "Robot", "scyther": "Scyther", "sonic": "Sonic", "spiderman": "Spiderman", "squirtle": "Squirtle", "stormtrooper": "Storm trooper", "ur-draug": "Ur-Draug", "zapados": "Zapados"]
    
    func makeMonsters(from userCoordinate: CLLocationCoordinate2D) -> [Monster] {
        
        var monsters = [Monster]()
        
        for (imageName, name) in self.monsterNames {
            let level  = Int.random(in: 1...50)
            let coordinate = makeCoordinate(from: userCoordinate)
            let monster = Monster(name: name, imageName: imageName, level: level, coordinate: coordinate)
            monsters.append(monster)
        }
        
        return monsters
    }
    
    //Making monster coordinate
    func makeCoordinate(from userCoordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        let degreesInMeters = 0.00001
        let deltaLatitude = Int.random(in: 1...1000)
        let deltaLongitude = Int.random(in: 1...1000)
        
        var latitude: Double
        var longitude: Double
        
        //Make latitude
        if deltaLatitude % 2 == 0 {
            latitude = userCoordinate.latitude + degreesInMeters * Double(deltaLatitude)
        } else {
            latitude = userCoordinate.latitude - degreesInMeters * Double(deltaLatitude)
        }
        
        //Make longitude
        if deltaLongitude % 2 == 0 {
            longitude = userCoordinate.longitude + degreesInMeters * Double(deltaLongitude)
        } else {
            longitude = userCoordinate.longitude - degreesInMeters * Double(deltaLongitude)
        }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
