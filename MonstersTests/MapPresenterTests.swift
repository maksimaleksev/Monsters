//
//  MapPresenterTests.swift
//  MonstersTests
//
//  Created by Maxim Alekseev on 03.01.2021.
//

import XCTest
import CoreLocation
import MapKit
@testable import Monsters

class MockMapView: MapViewProtocol {
    func setAnnotations(_ annotations: [MonsterAnnotation]) {
        
    }
    
    var scale = 0.0
    
    func show(region: MKCoordinateRegion) {
        
    }
    
    var message: String?
            
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
        presenter.monsters = [ Monster(name: "Foo",
                                       imageName: "foo",
                                       level: 1,
                                       coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 1)),
                               Monster(name: "Bar",
                                       imageName: "bar",
                                       level: 2,
                                       coordinate: CLLocationCoordinate2D(latitude: 2, longitude: 2)),
                               Monster(name: "Foo", imageName: "foo", level: 3,
                                       coordinate: CLLocationCoordinate2D(latitude: 1.0001, longitude: 1.0001))
        ]
        presenter.userLocation = CLLocationCoordinate2D(latitude: 1, longitude: 1)
        
    }
    
    override func tearDownWithError() throws {
        view = nil
        locationManager = nil
        presenter.stopTimer()
        presenter = nil
    }
    
    func testGetLocation() {
        presenter.userLocation = CLLocationCoordinate2D(latitude: 2, longitude: 1)
        let location = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        presenter.getLocation(location)
        presenter.isInitialSetup = false
        XCTAssertNotNil(presenter.userLocation)
        XCTAssertEqual(presenter.userLocation?.latitude, location.latitude)
        XCTAssertEqual(presenter.userLocation?.longitude, location.longitude)
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
    
    func testMakeRegion() {
        var region: MKCoordinateRegion?

        region = presenter.makeRegion(center: presenter.userLocation!, scale: 0.25)
        XCTAssertNotNil(region)
        XCTAssertEqual(region!.span.latitudeDelta, 0.25)
        XCTAssertEqual(region!.span.longitudeDelta, 0.25)
        
        }
    
    func testMakeAnnotations() {
        
        let annotations = presenter.makeAnnotations()
        
        XCTAssertEqual(annotations.count, 2)
    }
    
    func testStartTimer() {
     
        presenter.startTimer()
        XCTAssertNotNil(presenter.timer)
    }
    
    func testStopTimer() {
        presenter.startTimer()
        presenter.stopTimer()
        XCTAssertNil(presenter.timer)
    }
}
