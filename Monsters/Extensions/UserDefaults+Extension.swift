//
//  UserDefaults+Extension.swift
//  Monsters
//
//  Created by Maxim Alekseev on 20.01.2021.
//

import Foundation


extension UserDefaults {
    
    static let monsterTeam = "monsterTeam"
    
    func savedMonsters() -> [TeamedMonsterModel] {
        let defaults = UserDefaults.standard
        
        guard let data = defaults.object(forKey: UserDefaults.monsterTeam) as? Data,
              let savedMonsters = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [TeamedMonsterModel]
              else { return [] }
        
        return savedMonsters
    }
}
