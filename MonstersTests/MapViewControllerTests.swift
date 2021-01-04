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
    
    func makeRegion(scale: Double) -> MKCoordinateRegion? {
        return nil
    }
    
    func showRegion() {
        
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
        mapVC.zoomOutButtonTapped(UIButton())
        XCTAssertEqual(mapVC.scale, 0.25)
    }
    
    func testZoomIn() {
        mapVC.scale = 1
        mapVC.zoomInButtonTapped(UIButton())
        XCTAssertEqual(mapVC.scale, 0.75)
        
        mapVC.scale = 0.1
        mapVC.zoomInButtonTapped(UIButton())
        XCTAssertEqual(mapVC.scale, 0.0)
        
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
