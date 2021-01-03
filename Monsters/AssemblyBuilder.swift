//
//  AssemblyBuilder.swift
//  Monsters
//
//  Created by Maxim Alekseev on 02.01.2021.
//

import UIKit

protocol AssemblyBuilderProtocol: class {
    func createMapModule() -> MapViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    
    
    func createMapModule() -> MapViewController {
        
        let locationManger = LocationManager()
        let view = MapViewController()
        let presenter = MapPresenter(view: view, locationManager: locationManger)
        locationManger.mapViewPresenter = presenter
        view.presenter = presenter
        return view
    }
    
}
