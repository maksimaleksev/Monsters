//
//  Router.swift
//  Monsters
//
//  Created by Maxim Alekseev on 08.01.2021.
//

import UIKit

//MARK: - Router Protocol

protocol RouterProtocol: class {
    
    var navigationController: UINavigationController? { get }
    var assemblyBuilder: AssemblyBuilderProtocol? { get }
    var mapPresenter: MapPresenterProtocol? { get set }
    
    func initialViewController()
    func showMonsterModule(_ monster: MonsterModelProtocol)
    func popToMapViewController(_ case: SegueCases)
    func showMonstersTeamModule()
}

//MARK: - Segue cases

enum SegueCases {
    case Monster(MonsterModelProtocol)
    case Loose
}

//MARK: - Routet Class

class Router: RouterProtocol {
    
    //MARK: - Variables
    
    internal var navigationController: UINavigationController?
    internal var assemblyBuilder: AssemblyBuilderProtocol?
    internal weak var mapPresenter: MapPresenterProtocol?
    
    
    //MARK: - Init
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Class methods
    
    //Set initial viewcontroller
    func initialViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblyBuilder?.createMapModule(router: self)  else { return }
            mapPresenter = mainViewController.presenter
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    //Show Monster module
    func showMonsterModule(_ monster: MonsterModelProtocol) {
        if let navigationController = navigationController {
            guard let monsterViewController = assemblyBuilder?.createMonsterModule(monster: monster, router: self)  else { return }
            navigationController.pushViewController(monsterViewController, animated: true)
        }
        
    }
    
    func showMonstersTeamModule() {
        
        if let navigationController = navigationController {
            guard let monstersTeamViewController = assemblyBuilder?.createMonsterTeamModel(router: self)  else { return }
            navigationController.pushViewController(monstersTeamViewController, animated: true)
        }
    }
    
    //Back to map view controller
    func popToMapViewController(_ segueCase: SegueCases) {
        
        guard let navigationController = navigationController  else { return }
        
        switch segueCase {
        
        case .Monster(let monster):
            mapPresenter?.catchedMonsterHandler(monster)
            navigationController.popToRootViewController(animated: true)
        case .Loose:
            navigationController.popToRootViewController(animated: true)
        }
        
    }
}
