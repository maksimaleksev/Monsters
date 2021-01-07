//
//  MonsterBuilderTests.swift
//  MonstersTests
//
//  Created by Maxim Alekseev on 04.01.2021.
//

//import XCTest
//import CoreLocation
//@testable import Monsters
//
//class MonsterBuilderTests: XCTestCase {
//
//    var builder: MonsterBuilder!
//
//    override func setUpWithError() throws {
//
//        builder = MonsterBuilder.shared
//    }
//
//    override func tearDownWithError() throws {
//        builder = nil
//    }
//
//    func testMakingMonster() {
//        let monsterName = "Foo"
//        let monsterImageName = "Buz"
//        let monsterLevel = 2
//        let location = CLLocationCoordinate2D(latitude: 1, longitude: 2)
//
//        var monster: Monster? = nil
//
//        builder.set()
//        builder.setMonsterName(monsterName)
//        builder.setMonsterImageName(monsterImageName)
//        builder.setMonsterLevel(monsterLevel)
//        builder.setMonsterLocation(location)
//        monster = builder.makeMonster()
//
//        XCTAssertNotNil(monster)
//        XCTAssertEqual(monster!.name, monsterName)
//        XCTAssertEqual(monster!.imageName, monsterImageName)
//        XCTAssertEqual(monster!.level, 2)
//        XCTAssertEqual(monster!.location!.latitude, location.latitude)
//        XCTAssertEqual(monster!.location!.longitude, location.longitude)
//    }
//}
