//
//  MapPresenterTests.swift
//  MonstersTests
//
//  Created by Maxim Alekseev on 03.01.2021.
//

import XCTest
import CoreLocation
@testable import Monsters

class MockMapView: MapViewProtocol {
    
    var location: CLLocationCoordinate2D?
    var message: String?
    
    func showLocation(location: CLLocationCoordinate2D) {
        self.location = location
    }
    
    func showLocationSettingsAlert(title: String, message: String) {
        self.message = message
    }
    
}

class MockLocationManager: LocationManagerProtocol {
    var mapViewPresenter: MapPresenterProtocol?
}

class MapPresenterTests: XCTestCase {
    
    var view: MockMapView!
    var locationManager: MockLocationManager!
    var presenter: MapPresenter!
    
    
    override func setUpWithError() throws {
        
        view = MockMapView()
        locationManager = MockLocationManager()
        presenter = MapPresenter(view: view, locationManager: locationManager)
        
    }
    
    override func tearDownWithError() throws {
        view = nil
        locationManager = nil
        presenter = nil
    }
    
    func testGetLocation() {
        let location = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        presenter.getLocation(location)
        XCTAssertNotNil(view.location)
        XCTAssertEqual(view.location?.latitude, location.latitude)
        XCTAssertEqual(view.location?.longitude, location.longitude)
    }
    
    func testcantUpdateLocation() {
        
        //When denied
        presenter.cantUpdateLocation(.denied)
        XCTAssertNotNil(view.message)
        XCTAssertEqual(view.message, LocationAuthStatus.denied.status)
        
        //When not determined
        presenter.cantUpdateLocation(.notDetermined)
        XCTAssertEqual(view.message, LocationAuthStatus.notDetermined.status)
        
        //When granted
        presenter.cantUpdateLocation(.granted)
        XCTAssertEqual(view.message, LocationAuthStatus.granted.status)
    }
    
}
