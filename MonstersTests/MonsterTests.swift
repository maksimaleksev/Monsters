//
//  MonsterTests.swift
//  MonstersTests
//
//  Created by Maxim Alekseev on 04.01.2021.
//

import XCTest
import CoreLocation
@testable import Monsters

class MonsterTests: XCTestCase {

    var monster: Monster!

    override func setUpWithError() throws {
        monster = Monster(name: "Foo",
                          imageName: "foo",
                          level: 1,
                          coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 1))
    }

    override func tearDownWithError() throws {
        monster = nil
    }

    func testSetNewLocation() {
        
        let newLocation = CLLocationCoordinate2D(latitude: 3, longitude: 4)
        
        monster.setNewLocation(newLocation)
        
        XCTAssertEqual(monster.coordinate.latitude, 3)
        XCTAssertEqual(monster.coordinate.longitude, 4)
    }
    
    func testGetDistanceFromUser() {
        let userLocation = CLLocationCoordinate2D(latitude: 1.001, longitude: 1.001)
        
        let distance = monster.getDistance(from: userLocation)
        
        XCTAssertTrue(distance < 200)
    }
}
 
