//
//  MonsterTeamPresenter.swift
//  Monsters
//
//  Created by Maxim Alekseev on 20.01.2021.
//

import Foundation

//MARK: - Monster Team Presenter Protocol

protocol MonsterTeamPresenterProtocol: class {
    
    var view: MonsterTeamViewProtocol? { get }
    var router: RouterProtocol? { get }
    var monstersTeam: [TeamedMonsterModel] { get }
    
    init(view: MonsterTeamViewProtocol, router: RouterProtocol)
}

//MARK: - Monster Team Presenter class

class MonsterTeamPresenter: MonsterTeamPresenterProtocol {
    
    //MARK: - Class properties
    
    var router: RouterProtocol?
    weak var view: MonsterTeamViewProtocol?
    var monstersTeam: [TeamedMonsterModel] {
        return UserDefaults.standard.savedMonsters()
    }
    
    //MARK: - Init
    required init(view: MonsterTeamViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    deinit {
        print(String(describing: MonsterTeamPresenter.self) + " deinit")
    }
        
}
