//
//  AssemblyBuilder.swift
//  Monsters
//
//  Created by Maxim Alekseev on 02.01.2021.
//

import UIKit

protocol AssemblyBuilderProtocol: class {

    func createMapModule(router: RouterProtocol) -> MapViewController
    func createMonsterModule(monster: Monster, router: RouterProtocol) -> MonsterViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    
    func createMapModule(router: RouterProtocol) -> MapViewController {
        let locationManger = LocationManager()
        let view = MapViewController()
        let presenter = MapPresenter(view: view, locationManager: locationManger, router: router)
        locationManger.mapViewPresenter = presenter
        view.presenter = presenter
        return view
    }
    
    func createMonsterModule(monster: Monster, router: RouterProtocol) -> MonsterViewController {
        
        let view = MonsterViewController()
        let presenter = MonsterPresenter(view: view, monster: monster, router: router)
        view.presenter = presenter
        return view
    }
}
