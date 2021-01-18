//
//  MapViewControllerTests.swift
//  MonstersTests
//
//  Created by Maxim Alekseev on 04.01.2021.
//

import XCTest
import CoreLocation
import MapKit
@testable import Monsters

class MockPresenter: MapPresenterProtocol {
    var router: RouterProtocol?
    
        
    var timer: Timer?
               
    var mapViewIsLoaded: Bool = true
       
    var view: MapViewProtocol?
    
    var userLocation: CLLocationCoordinate2D?
    
    var locationManager: LocationManagerProtocol?
    
    required init(view: MapViewProtocol, locationManager: LocationManagerProtocol, router: RouterProtocol) {
        self.view = view
        self.locationManager = locationManager
        self.router = router
    }
    
    func showMonster(_ monster: Monster) {
        
    }
    
    func getLocation(_ location: CLLocationCoordinate2D) {
        
    }
    
    func cantUpdateLocation(_ reason: LocationAuthStatus) {
        
    }
    
    func showRegion() {
        
    }
    
    func makeRegion(center coordinate: CLLocationCoordinate2D, scale: Double) -> MKCoordinateRegion {
        return MKCoordinateRegion()
    }
    
    func makeRegion(regionRadius: CLLocationDistance, for location: CLLocationCoordinate2D) -> MKCoordinateRegion {
       return MKCoordinateRegion()
    }
    
    func makeAnnotations() -> [MonsterAnnotation] {
            return []
    }
    
    func startTimer() {
        
    }
    
    func stopTimer() {
        
    }
    



}

class MapViewControllerTests: XCTestCase {

    var mapVC: MapViewController!
    var presenter: MapPresenterProtocol!
    
    override func setUpWithError() throws {
        mapVC = MapViewController()
        presenter = MockPresenter(view: mapVC, locationManager: LocationManager(), router: Router(navigationController: UINavigationController(), assemblyBuilder: AssemblyBuilder()))
        mapVC.presenter = presenter
        }

    override func tearDownWithError() throws {
        mapVC = nil
        presenter = nil
    }
    
    func testZoomOut() {
        mapVC.loadView()
        mapVC.zoomOutButtonTapped(UIButton())
        XCTAssertEqual(mapVC.scaleCounter, 1)
    }
    
    func testZoomIn() {
        mapVC.loadView()
        mapVC.scaleCounter = 1
        mapVC.zoomInButtonTapped(UIButton())
        XCTAssertEqual(mapVC.scaleCounter, 0)
        
        mapVC.scaleCounter = 2
        mapVC.zoomInButtonTapped(UIButton())
        XCTAssertEqual(mapVC.scaleCounter, 1)
        
    }
    
    func testShowRegion() {
        let centerRegion = CLLocationCoordinate2D(latitude: 21, longitude: 21)
        let region = MKCoordinateRegion(center: centerRegion,
                                        latitudinalMeters: 100,
                                        longitudinalMeters: 100)
        mapVC.loadView()
        mapVC.show(region: region)
        
        XCTAssertEqual(mapVC.mapView.region.center.latitude.rounded(), centerRegion.latitude.rounded())
        XCTAssertEqual(mapVC.mapView.region.center.longitude.rounded(), centerRegion.longitude.rounded())
    }
}
