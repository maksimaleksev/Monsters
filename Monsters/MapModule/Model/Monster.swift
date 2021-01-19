//
//  Monster.swift
//  Monsters
//
//  Created by Maxim Alekseev on 04.01.2021.
//

import Foundation
import CoreLocation

protocol MonsterModelProtocol: class {
    var name: String { get }
    var imageName: String { get }
    var level: Int { get set }
}

class Monster: MonsterModelProtocol  {

    let name: String
    let imageName: String
    var level: Int
    var coordinate: CLLocationCoordinate2D
    
    init(name: String, imageName: String, level: Int, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.imageName = imageName
        self.level = level
        self.coordinate = coordinate
    }
}

//MARK: - Location methods

extension Monster {
    
    //Determing distance between monster location and user location
    func getDistance(from userCoordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        let monsterLocation = CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        
        return monsterLocation.distance(from: userLocation)
    }
    
    func setNewLocation(_ newCoordinate: CLLocationCoordinate2D) {
        self.coordinate = newCoordinate
    }
}

//MARK: - Equatable conform
extension Monster: Equatable {
    
    static func == (lhs: Monster, rhs: Monster) -> Bool {
        return lhs.name == rhs.name && lhs.level == rhs.level
    }
}
