//
//  MonsterBuilder.swift
//  Monsters
//
//  Created by Maxim Alekseev on 04.01.2021.
//

import Foundation
import CoreLocation

/*protocol MonsterBuilderProtocol {
   
    func set()
    func setMonsterName(_ name: String)
    func setMonsterImageName(_ imageName: String)
    func setMonsterLevel(_ level: Int)
    func setMonsterLocation(_ location: CLLocationCoordinate2D)
    func makeMonster() -> Monster?
}

class MonsterBuilder: MonsterBuilderProtocol {
    
    static let shared = MonsterBuilder()
    private var monster: Monster? = nil
    
    private init() {}
    
    func set() {
        self.monster = Monster()
    }
    
    private func reset() {
        self.monster = nil
    }
    
    func setMonsterName(_ name: String) {
        self.monster?.name = name
    }
    
    func setMonsterImageName(_ imageName: String) {
        self.monster?.imageName = imageName
    }
    
    func setMonsterLocation(_ location: CLLocationCoordinate2D) {
        self.monster?.location = location
    }
    
    func setMonsterLevel(_ level: Int) {
        self.monster?.level = level
    }
    
    func makeMonster() -> Monster? {
        guard  let monster = self.monster else { return nil }
        reset()
        return monster
    }
            
}*/
