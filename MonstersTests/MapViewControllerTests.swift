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
    var timer: Timer?
               
    var mapViewIsLoaded: Bool = true
       
    var view: MapViewProtocol?
    
    var userLocation: CLLocationCoordinate2D?
    
    var locationManager: LocationManagerProtocol?
    
    required init(view: MapViewProtocol, locationManager: LocationManagerProtocol) {
        self.view = view
        self.locationManager = locationManager
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
        presenter = MockPresenter(view: mapVC, locationManager: LocationManager())
        mapVC.presenter = presenter
        }

    override func tearDownWithError() throws {
        mapVC = nil
        presenter = nil
    }
    
    func testZoomOut() {
        mapVC.loadView()
        mapVC.zoomOutButtonTapped(UIButton())
        XCTAssertEqual(mapVC.scale, 0.025)
    }
    
    func testZoomIn() {
        mapVC.loadView()
        mapVC.scale = 1
        mapVC.zoomInButtonTapped(UIButton())
        XCTAssertEqual(mapVC.scale, 0.975)
        
        mapVC.scale = 0.1
        mapVC.zoomInButtonTapped(UIButton())
        XCTAssertEqual(mapVC.scale, 0.07500000000000001)
        
    }
    
    func testShowRegion() {
        let centerRegion = CLLocationCoordinate2D(latitude: 21.10000000000001, longitude: 21.100000000000023)
        let region = MKCoordinateRegion(center: centerRegion,
                                        latitudinalMeters: 100,
                                        longitudinalMeters: 100)
        mapVC.loadView()
        mapVC.show(region: region)
        
        XCTAssertEqual(mapVC.mapView.region.center.latitude, centerRegion.latitude)
        XCTAssertEqual(mapVC.mapView.region.center.longitude, centerRegion.longitude)
    }
}
