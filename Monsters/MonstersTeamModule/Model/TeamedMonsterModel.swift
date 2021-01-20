//
//  TeamedMonsterModel.swift
//  Monsters
//
//  Created by Maxim Alekseev on 20.01.2021.
//

import Foundation

@objc class TeamedMonsterModel: NSObject, MonsterModelProtocol, NSCoding, Identifiable {
    
    private enum MonsterCodingKeys: String {
        case monsterName
        case monsterImageName
        case monsterLevel
    }
    
    var name: String
    
    var imageName: String
    
    var level: Int
    
    init(name: String, imageName: String, level: Int) {
        self.name = name
        self.imageName = imageName
        self.level = level
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: MonsterCodingKeys.monsterName.rawValue)
        coder.encode(imageName, forKey: MonsterCodingKeys.monsterImageName.rawValue)
        coder.encode(level, forKey: MonsterCodingKeys.monsterLevel.rawValue)
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: MonsterCodingKeys.monsterName.rawValue) as? String ?? ""
        imageName = coder.decodeObject(forKey: MonsterCodingKeys.monsterImageName.rawValue) as? String ?? ""
        level = coder.decodeInteger(forKey: MonsterCodingKeys.monsterLevel.rawValue)
        
    }

    
}
