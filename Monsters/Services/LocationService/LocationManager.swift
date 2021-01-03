//
//  LocationManager.swift
//  Monsters
//
//  Created by Maxim Alekseev on 02.01.2021.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol: class {
    var mapViewPresenter: MapPresenterProtocol? { get set }
}

class LocationManager: NSObject, LocationManagerProtocol {
    
    static let shared = LocationManager()
    
    private let cllocationManager = CLLocationManager()
    
    weak var mapViewPresenter: MapPresenterProtocol?
    
    override init() {
        super.init()
        cllocationManager.delegate = self
        cllocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        cllocationManager.requestWhenInUseAuthorization()
        cllocationManager.startUpdatingLocation()
    }

}

//MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        
        case .notDetermined:
            cllocationManager.stopUpdatingLocation()
            mapViewPresenter?.cantUpdateLocation(.notDetermined)
        case .restricted:
            cllocationManager.stopUpdatingLocation()
            mapViewPresenter?.cantUpdateLocation(.denied)
        case .denied:
            cllocationManager.stopUpdatingLocation()
            mapViewPresenter?.cantUpdateLocation(.denied)
        default:
            cllocationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else { return }
        mapViewPresenter?.getLocation(location)        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error.localizedDescription)
        manager.stopUpdatingLocation()
    }
}
