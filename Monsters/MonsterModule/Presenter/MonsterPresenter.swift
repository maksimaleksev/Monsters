//
//  MonsterPresenter.swift
//  Monsters
//
//  Created by Maxim Alekseev on 08.01.2021.
//

import Foundation


protocol MonsterPresenterProtocol {
    var view: MonsterViewProtocol { get }
    var monster: Monster { get }
    var router: RouterProtocol { get }
    
    init (view: MonsterViewProtocol, monster: Monster, router: RouterProtocol)
    
    func setImage()
    func setLabelText()
}

class MonsterPresenter: MonsterPresenterProtocol {

    var view: MonsterViewProtocol
    var monster: Monster
    var router: RouterProtocol
    
    
    required init(view: MonsterViewProtocol, monster: Monster, router: RouterProtocol) {
        self.view = view
        self.monster = monster
        self.router = router
    }

    func setImage() {
        view.setImage(monster.imageName)
    }
    
    func setLabelText() {
        view.setLabel(monster.name)
    }

}
