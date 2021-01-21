//
//  MonsterTableViewCell.swift
//  Monsters
//
//  Created by Maxim Alekseev on 20.01.2021.
//

import UIKit

class MonsterTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let reuseId = String(describing: MonsterTableViewCell.self)

    //MARK: - IBOutlets
    
    @IBOutlet weak var monsterImageView: UIImageView!
    @IBOutlet weak var monsterNameLabel: UILabel!
    @IBOutlet weak var monsterLevelLabel: UILabel!
    
    public func setupCellFor(monster: MonsterModelProtocol?) {
        
        guard let monster = monster else { return }
        
        self.monsterImageView.image = UIImage(named: monster.imageName)
        self.monsterNameLabel.text = monster.name
        self.monsterLevelLabel.text = "Уровень: \(monster.level)"
    }
    
}
