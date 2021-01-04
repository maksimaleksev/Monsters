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

    var builder: MonsterBuilder!
    
    override func setUpWithError() throws {
        builder = MonsterBuilder.shared
    }

    override func tearDownWithError() throws {
        builder = nil
    }

    func testSetNewLocation() {
        let location = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        let newLocation = CLLocationCoordinate2D(latitude: 3, longitude: 4)
        builder.set()
        builder.setMonsterLocation(location)
        
        var monster = builder.makeMonster()
        monster?.setNewLocation(newLocation)
        XCTAssertNotNil(monster)
        XCTAssertEqual(monster?.location?.latitude, newLocation.latitude)
        XCTAssertEqual(monster?.location?.longitude, newLocation.longitude)
    }
}
