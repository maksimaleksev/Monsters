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

//MARK: - Map presenter Protocol

protocol MapPresenterProtocol: class {
    var view: MapViewProtocol? { get set }
    var userLocation: CLLocationCoordinate2D? { get set }
    var locationManager: LocationManagerProtocol? { get set }
    var router: RouterProtocol? { get set }
    var mapViewIsLoaded: Bool { get set }
    var timer: Timer? { get set }
    var isTeamEmpty: Bool { get }
    
    init(view: MapViewProtocol, locationManager: LocationManagerProtocol, router: RouterProtocol)
    
    func getLocation(_ location: CLLocationCoordinate2D)
    func cantUpdateLocation(_ reason: LocationAuthStatus)
    func makeRegion(center coordinate: CLLocationCoordinate2D, scale: Double) -> MKCoordinateRegion
    func makeRegion(regionRadius: CLLocationDistance, for location: CLLocationCoordinate2D) -> MKCoordinateRegion
    func showRegion()
    func makeAnnotations() -> [MonsterAnnotation]
    func startTimer()
    func stopTimer()
    func showMonster(_ monster: Monster)
    func catchedMonsterHandler(_ monster: MonsterModelProtocol)
    func showMyTeam()
}

//MARK: - Map presenter class
class MapPresenter: MapPresenterProtocol {
    
    //MARK: - Properties
    
    weak var view: MapViewProtocol?
    var locationManager: LocationManagerProtocol?
    var userLocation: CLLocationCoordinate2D?
    var monsters: [Monster]!
    var router: RouterProtocol?
    var timer: Timer?
    var isTeamEmpty: Bool {
        return UserDefaults.standard.savedMonsters().isEmpty
    }
    
    //Tells when map on view is loaded
    var mapViewIsLoaded: Bool = false
    
    //Tells about initialSetup
    var isInitialSetup: Bool = true
    
    //Accuracy region need to determine when user moves
    let accuracyRegionRadius: Double =  100
    
    //MARK: - Init
    
    required init(view: MapViewProtocol, locationManager: LocationManagerProtocol, router: RouterProtocol) {
        self.view = view
        self.locationManager = locationManager
        self.router = router
    }
    
    //MARK: - Methods
    
    //Get location
    func getLocation(_ location: CLLocationCoordinate2D) {
        
        if mapViewIsLoaded && isInitialSetup {
            self.userLocation = location
            isInitialSetup = false
            showRegion()
            monsters = MonsterFarm.shared.makeMonsters(from: userLocation!)
            let annotations = makeAnnotations()
            view?.setAnnotations(annotations)
            startTimer()
        } else if isUserMoved(location){
            self.userLocation = location
            
            showRegion()
            setNewMonsterLocations()
            
            let annotations = makeAnnotations()
            view?.setAnnotations(annotations)
        }
    }
    
    //When location services not authorized
    func cantUpdateLocation(_ reason: LocationAuthStatus) {
        view?.showLocationSettingsAlert(title: "Внимание!", message: reason.status)
    }
    
    //Make region
    func makeRegion(regionRadius: CLLocationDistance, for location: CLLocationCoordinate2D) -> MKCoordinateRegion {
        return MKCoordinateRegion(center: location,
                                  latitudinalMeters: regionRadius,
                                  longitudinalMeters: regionRadius)
    }
    
    //Make region with span
    func makeRegion(center coordinate: CLLocationCoordinate2D, scale: Double) -> MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: scale, longitudeDelta: scale)
        return MKCoordinateRegion(center: coordinate, span: span)
    }
    
    //Shows mapView region with center in user location
    func showRegion() {
        guard let location = self.userLocation else { return }
        let region = makeRegion(regionRadius: 300, for: location)
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
    
    //Making annotation from monster model
//    private func makeAnnotation(from monster: Monster) -> MonsterAnnotation {
//        return MonsterAnnotation(monster: monster)
//    }
    
    //Making mapViewAnnotations in 300 meters from user location
    func makeAnnotations() -> [MonsterAnnotation] {
        
        return monsters.filter {[weak self] monster in
            guard let userLocation = self?.userLocation else { return false}
            return monster.getDistance(from: userLocation) <= 300 }
            .map { return MonsterAnnotation(monster: $0) }
        
    }
    
    //Create chance to change location for monster
    private func setNewMonsterLocations() {
        
        monsters.forEach {[weak self] monster in
            guard let location = self?.userLocation else { return }
            let chance = Int.random(in: 1...5)
            if chance == 5 {
                let coordinate = MonsterFarm.shared.makeCoordinate(from: location)
                monster.setNewLocation(coordinate)
            }
        }
    }
    
    //Timer for change moncter position every 5 minutes
    func startTimer() {
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true, block: { [weak self] _ in
                guard let self = self else { return }
                
                self.setNewMonsterLocations()
                
                let annotations = self.makeAnnotations()
                self.view?.setAnnotations(annotations)
            })
            
            timer?.tolerance = 0.1
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    //Segue to MonsterViewController
    
    func showMonster(_ monster: Monster) {
        
        guard let userLocation = userLocation,
              monster.getDistance(from: userLocation) <= 100
        
        else {
            view?.animateWarningDistanceViewAppear()
            return
        }
        
        stopTimer()
        router?.showMonsterModule(monster)
    }

    //Handing when monster catch
    
    func catchedMonsterHandler(_ monster: MonsterModelProtocol) {
        
        guard let m = monster as? Monster,
              let index = monsters.firstIndex(of: m)
        else { return }
        
        monsters.remove(at: index)
        let annotaions = makeAnnotations()
        view?.setAnnotations(annotaions)
    }
    
    //Segue to MonstersTeamViewController
    
    func showMyTeam() {
        stopTimer()
        router?.showMonstersTeamModule()
    }
}
