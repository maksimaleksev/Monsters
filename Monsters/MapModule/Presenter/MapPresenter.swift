//
//  MapPresenter.swift
//  Monsters
//
//  Created by Maxim Alekseev on 02.01.2021.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


protocol MapPresenterProtocol: class {
    var view: MapViewProtocol? { get set }
    var userLocation: CLLocationCoordinate2D? { get set }
    var locationManager: LocationManagerProtocol? { get set }
    var mapViewIsLoaded: Bool { get set }
    
    init(view: MapViewProtocol, locationManager: LocationManagerProtocol)
    
    func getLocation(_ location: CLLocationCoordinate2D)
    func cantUpdateLocation(_ reason: LocationAuthStatus)
    func makeRegion(scale: Double) -> MKCoordinateRegion?
    func showRegion()
}

class MapPresenter: MapPresenterProtocol {
    
    weak var view: MapViewProtocol?
    var locationManager: LocationManagerProtocol?
    var userLocation: CLLocationCoordinate2D?
    
    //Tells when map on view is loaded
    var mapViewIsLoaded: Bool = false
    
    //Tells about initialSetup
    var isInitialSetup: Bool = true
    
    //Accuracy region need to determine when user moves
    let accuracyRegionRadius: Double =  100
    
    required init(view: MapViewProtocol, locationManager: LocationManagerProtocol) {
        self.view = view
        self.locationManager = locationManager
    }
    
    //Get location
    func getLocation(_ location: CLLocationCoordinate2D) {
                        
        if mapViewIsLoaded && isInitialSetup {
            self.userLocation = location
            isInitialSetup = false
            showRegion()
            
        } else if isUserMoved(location){
            self.userLocation = location
            showRegion()
        }
    }
    
    //When location services not authorized
    func cantUpdateLocation(_ reason: LocationAuthStatus) {
        view?.showLocationSettingsAlert(title: "Внимание!", message: reason.status)
    }
    
    //Make region
    private func makeRegion(regionRadius: CLLocationDistance, for location: CLLocationCoordinate2D) -> MKCoordinateRegion {
        return MKCoordinateRegion(center: location,
                                  latitudinalMeters: regionRadius,
                                  longitudinalMeters: regionRadius)
    }
    
    //Make region with span
    func makeRegion(scale: Double) -> MKCoordinateRegion? {
        guard let userLocation = self.userLocation else { return nil }
        
        let span = MKCoordinateSpan(latitudeDelta: scale, longitudeDelta: scale)
        return MKCoordinateRegion(center: userLocation, span: span)
    }
    
    func showRegion() {
        guard let location = self.userLocation else { return }
        let region = makeRegion(regionRadius: 1000, for: location)
        view?.show(region: region)
    }
    
    //Checking new user location is in accuracy region
    private func isUserMoved (_ newLocationCoordinates: CLLocationCoordinate2D) -> Bool {
        guard let userLocation = self.userLocation else { return false }
        let location = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let newLocation = CLLocation(latitude: newLocationCoordinates.latitude, longitude: newLocationCoordinates.longitude)
        let coveredDistance = newLocation.distance(from: location)
        return self.accuracyRegionRadius <= coveredDistance
    }
}
