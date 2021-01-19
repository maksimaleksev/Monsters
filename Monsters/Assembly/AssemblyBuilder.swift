//
//  AssemblyBuilder.swift
//  Monsters
//
//  Created by Maxim Alekseev on 02.01.2021.
//

import UIKit


//MARK: - AssemblyBuilder Protocol

protocol AssemblyBuilderProtocol: class {

    func createMapModule(router: RouterProtocol) -> MapViewController
    func createMonsterModule(monster: MonsterModelProtocol, router: RouterProtocol) -> MonsterViewController
}

//MARK: - AssemblyBuilder class

class AssemblyBuilder: AssemblyBuilderProtocol {
    
    func createMapModule(router: RouterProtocol) -> MapViewController {
        let locationManger = LocationManager()
        let view = MapViewController()
        let presenter = MapPresenter(view: view, locationManager: locationManger, router: router)
        locationManger.mapViewPresenter = presenter
        view.presenter = presenter
        return view
    }
    
    func createMonsterModule(monster: MonsterModelProtocol, router: RouterProtocol) -> MonsterViewController {
        
        let view = MonsterViewController()
        let presenter = MonsterPresenter(view: view, monster: monster, router: router)
        view.presenter = presenter
        return view
    }
}
