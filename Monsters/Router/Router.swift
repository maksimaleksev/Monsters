//
//  Router.swift
//  Monsters
//
//  Created by Maxim Alekseev on 08.01.2021.
//

import UIKit

protocol RouterProtocol: class {
    var navigationController: UINavigationController? { get }
    var assemblyBuilder: AssemblyBuilderProtocol? { get }
    
    func initialViewController()
    func showMonsterModule(_ monster: Monster)
    func popToRoot()
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    //Set initial viewcontroller
    func initialViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblyBuilder?.createMapModule(router: self)  else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }
    //Show Monster module
    func showMonsterModule(_ monster: Monster) {
        if let navigationController = navigationController {
            guard let monsterViewController = assemblyBuilder?.createMonsterModule(monster: monster, router: self)  else { return }
            navigationController.pushViewController(monsterViewController, animated: true)
        }

    }
    
    //Back to root
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
