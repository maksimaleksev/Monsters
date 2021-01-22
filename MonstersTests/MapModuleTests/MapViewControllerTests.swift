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
        
    var isTeamEmpty: Bool {
        return UserDefaults.standard.savedMonsters().isEmpty
    }
       
    var router: RouterProtocol?
            
    var timer: Timer?
               
    var mapViewIsLoaded: Bool = true
       
    var view: MapViewProtocol?
    
    var userLocation: CLLocationCoordinate2D?
    
    var locationManager: LocationManagerProtocol?
    
    var showMyTeamTest: String?
    
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
    
    func catchedMonsterHandler(_ monster: MonsterModelProtocol) {
        
    }
    
    func showMyTeam() {
        self.showMyTeamTest = "Foo"
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
    
    //Zoom out tests
    func testZoomOut() {
        mapVC.loadView()
        mapVC.zoomOutButtonTapped(UIButton())
        XCTAssertEqual(mapVC.scale, 0.025)
        
        mapVC.zoomOutButtonTapped(UIButton())
        XCTAssertEqual(mapVC.scale, 0.05)
    }
    
    //Zoom In tests
    func testZoomIn() {
        mapVC.loadView()
        mapVC.scale = 0.01
        mapVC.zoomInButtonTapped(UIButton())
        XCTAssertEqual(mapVC.scale, 0.0)
        
        mapVC.scale = 1
        mapVC.zoomInButtonTapped(UIButton())
        XCTAssertEqual(mapVC.scale, 0.5)
        
    }
    
    //showMyTeamButtonTapped Test
    func testCenterMapOnUserButtonTapped() {
        mapVC.loadView()
        mapVC.centerMapOnUserButtonTapped(UIButton())
        
        XCTAssertEqual(mapVC.scale, 0)
    }
    
    
    func testShowMyTeamButtonTapped() {
        mapVC.loadView()
        mapVC.showMyTeamButtonTapped(UIButton())
        
        let p = presenter as! MockPresenter
        
        XCTAssertEqual(p.showMyTeamTest, "Foo")
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
