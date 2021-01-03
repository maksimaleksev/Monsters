//
//  MapPresenter.swift
//  Monsters
//
//  Created by Maxim Alekseev on 02.01.2021.
//

import Foundation
import UIKit
import CoreLocation


protocol MapPresenterProtocol: class {
    var view: MapViewProtocol? { get set }
    var locationManager: LocationManagerProtocol? { get set }
    
    init(view: MapViewProtocol, locationManager: LocationManagerProtocol)
    
    func getLocation(_ location: CLLocationCoordinate2D)
    func cantUpdateLocation(_ reason: LocationAuthStatus)
}

class MapPresenter: MapPresenterProtocol {
       
    weak var view: MapViewProtocol?
    var locationManager: LocationManagerProtocol?
    
    required init(view: MapViewProtocol, locationManager: LocationManagerProtocol) {
        self.view = view
        self.locationManager = locationManager
        }
    
    func getLocation(_ location: CLLocationCoordinate2D) {
        view?.showLocation(location: location)
    }
    
    func cantUpdateLocation(_ reason: LocationAuthStatus) {
        view?.showLocationSettingsAlert(title: "Внимание!", message: reason.status)
    }
}
