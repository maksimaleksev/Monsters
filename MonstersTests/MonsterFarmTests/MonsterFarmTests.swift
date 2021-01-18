//
//  MonsterFarmTests.swift
//  MonstersTests
//
//  Created by Maxim Alekseev on 07.01.2021.
//

import XCTest
import CoreLocation
@testable import Monsters

class MonsterFarmTests: XCTestCase {
    
    var monsterFarm: MonsterFarm!
    
    override func setUpWithError() throws {
        monsterFarm = MonsterFarm.shared
    }

    override func tearDownWithError() throws {
        monsterFarm = nil
    }
    
    func testMakeCoordinate() {
        
        let userLocation = CLLocationCoordinate2D(latitude: 1, longitude: 1)
        let coordinate = monsterFarm.makeCoordinate(from: userLocation)
        let delta = 0.01
        
        //Chechk Latitude
        XCTAssertTrue(coordinate.latitude <= (userLocation.latitude + delta ), "Monster latitude: \(coordinate.latitude), User latiude: \(userLocation.latitude)")
        XCTAssertTrue(coordinate.latitude >= (userLocation.latitude - delta ), "Monster Latitude: \(coordinate.latitude), User latiude: \(userLocation.latitude)")
        
        //Check longitude
        
        XCTAssertTrue(coordinate.longitude <= (userLocation.longitude + delta), "Monster latitude: \(coordinate.longitude), User latiude: \(userLocation.longitude)")
        XCTAssertTrue(coordinate.longitude >= (userLocation.longitude - delta), "Monster Latitude: \(coordinate.longitude), User latiude: \(userLocation.longitude)")
    }
    
    func testMakeMonsters() {
        let userLocation = CLLocationCoordinate2D(latitude: 1, longitude: 1)
        let monsters = monsterFarm.makeMonsters(from: userLocation)
        
        XCTAssertEqual(monsters.count, 30)
    }
    
}
