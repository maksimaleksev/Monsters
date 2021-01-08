//
//  MonsterViewController.swift
//  Monsters
//
//  Created by Maxim Alekseev on 08.01.2021.
//

import UIKit

protocol MonsterViewProtocol {
    var presenter: MonsterPresenterProtocol! { get set }
    func setImage(_ imageName: String)
    func setLabel(_ name: String)
}


class MonsterViewController: UIViewController {
    
    var presenter: MonsterPresenterProtocol!

    @IBOutlet weak var monsterImage: UIImageView!
    @IBOutlet weak var monsterName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setImage()
        presenter.setLabelText()
    }
    
}

extension MonsterViewController: MonsterViewProtocol {
    
    func setImage(_ imageName: String) {
        monsterImage.image = UIImage(named: imageName)
    }
    
    func setLabel(_ name: String) {
        monsterName.text = name
    }
}
