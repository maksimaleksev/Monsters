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

fileprivate class MockMapView: MapViewProtocol {
    
    var scale = 0.0

    var message: String?

    var scaleCounter: Int = 0
    
    var annotations: [MonsterAnnotation] = []
    
    func setAnnotations(_ annotations: [MonsterAnnotation]) {
        self.annotations = annotations
    }
    
        
    func show(region: MKCoordinateRegion) {
        
    }
    
                
    func showLocationSettingsAlert(title: String, message: String) {
        self.message = message
    }
    
    func animateWarningDistanceViewAppear() {
        
    }
}


private class MockRouter: RouterProtocol {
       
    var navigationController: UINavigationController?
    
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    var mapPresenter: MapPresenterProtocol?
    
    var monster: MonsterModelProtocol?
    
    var showMonstersTeamModuleTest: String?
    
    required init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        
    }
    
    func showMonsterModule(_ monster: MonsterModelProtocol) {
        self.monster = monster
    }
    
    func popToMapViewController(_ case: SegueCases) {
        
    }
    
    func showMonstersTeamModule() {
        showMonstersTeamModuleTest = "Foo"
    }
    
    
    
}

fileprivate class MockLocationManager: LocationManagerProtocol {
    var mapViewPresenter: MapPresenterProtocol?
}

class MapPresenterTests: XCTestCase {
    
    fileprivate var view: MockMapView!
    fileprivate var locationManager: MockLocationManager!
    var presenter: MapPresenter!
    
    
    override func setUpWithError() throws {
        
        view = MockMapView()
        locationManager = MockLocationManager()
        presenter = MapPresenter(view: view,
                                 locationManager: locationManager,
                                 router: MockRouter(navigationController: UINavigationController(),
                                                    assemblyBuilder: AssemblyBuilder()))
        presenter.monsters = [ Monster(name: "Foo",
                                       imageName: "foo",
                                       level: 1,
                                       coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 1)),
                               Monster(name: "Bar",
                                       imageName: "bar",
                                       level: 2,
                                       coordinate: CLLocationCoordinate2D(latitude: 2, longitude: 2)),
                               Monster(name: "Buz", imageName: "Buz", level: 3,
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
    
    //Get location tests
    
    func testGetLocation() {
        presenter.userLocation = CLLocationCoordinate2D(latitude: 2, longitude: 1)
        let location = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        
        //if mapViewIsLoaded && isInitialSetup
        presenter.isInitialSetup  = true
        presenter.mapViewIsLoaded = true
        presenter.getLocation(location)
                
        XCTAssertNotNil(presenter.userLocation)
        XCTAssertEqual(presenter.userLocation?.latitude, location.latitude)
        XCTAssertEqual(presenter.userLocation?.longitude, location.longitude)
        XCTAssertFalse(presenter.isInitialSetup)
        XCTAssertEqual(presenter.monsters.count, 30 - UserDefaults.standard.savedMonsters().count)
                
        let newlocation = CLLocationCoordinate2D(latitude: 3, longitude: 4)
        presenter.getLocation(newlocation)
        
        XCTAssertNotNil(presenter.userLocation)
        XCTAssertEqual(presenter.userLocation?.latitude, newlocation.latitude)
        XCTAssertEqual(presenter.userLocation?.longitude, newlocation.longitude)
    }
    
    //CantUpdateLocation tests
    func testCantUpdateLocation() {
        
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
    
    //Make region with span tests
    
    func testMakeRegion() {
        var region: MKCoordinateRegion?

        region = presenter.makeRegion(center: presenter.userLocation!, scale: 0.25)
        XCTAssertNotNil(region)
        XCTAssertEqual(region!.span.latitudeDelta, 0.25)
        XCTAssertEqual(region!.span.longitudeDelta, 0.25)
        
        }
    //Timer start tests
    func testStartTimer() {
     
        presenter.startTimer()
        XCTAssertNotNil(presenter.timer)
    }
    
    //Timer stop tests
    
    func testStopTimer() {
        presenter.startTimer()
        presenter.stopTimer()
        XCTAssertNil(presenter.timer)
    }
    
    //showMonster tests
    func testShowMonster() {
        
        let monster  = Monster(name: "Foo",
                               imageName: "foo",
                               level: 1,
                               coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 1))
        
        let monster1 = Monster(name: "Bar",
                               imageName: "bar",
                               level: 2,
                               coordinate: CLLocationCoordinate2D(latitude: 3, longitude: 4))
        
        presenter.showMonster(monster)
        let router = presenter.router as! MockRouter
        XCTAssertNotNil(router.monster)
        XCTAssertEqual(router.monster?.name, monster.name)
        router.monster = nil
        
        presenter.showMonster(monster1)
        XCTAssertNil(router.monster)
    }
    
    //catchedMonsterHandler tests
    func testCatchedMonsterHandler() {
        
        let monster = Monster(name: "Foo",
                              imageName: "foo",
                              level: 1,
                              coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 1))
        
        presenter.catchedMonsterHandler(monster)
        
        XCTAssertEqual(presenter.monsters.count, 2)
        XCTAssertNil(presenter.monsters.first(where: { $0 == monster }))
    }
    
    func testShowMyTeam() {
        
        let router = presenter.router as! MockRouter
        presenter.showMyTeam()
        XCTAssertNotNil(router.showMonstersTeamModuleTest)
        XCTAssertEqual(router.showMonstersTeamModuleTest, "Foo")
    }
}
