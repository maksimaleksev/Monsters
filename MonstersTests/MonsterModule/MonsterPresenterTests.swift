//
//  MonsterPresenterTests.swift
//  MonstersTests
//
//  Created by Maxim Alekseev on 17.01.2021.
//

import XCTest
import CoreLocation
@testable import Monsters

class MonsterPresenterTests: XCTestCase {
    
    var presenter: MonsterPresenter!

    override func setUpWithError() throws {
        let vc = MonsterViewController()
        let monster = Monster(name: "Foo", imageName: "foo", level: 1, coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        let router = Router(navigationController: UINavigationController(),
                            assemblyBuilder: AssemblyBuilder())
        presenter = MonsterPresenter(view: vc, monster: monster, router: router)
    }

    override func tearDownWithError() throws {
        presenter = nil
    }

    func testCreateModelScene() {
        
        let monsterNames:[String:String] = ["altair": "Altair", "amyrose": "Amy Rose", "articuno": "Articuno", "bobby": "Bobby", "bulbasaur": "Bulbasaur", "charizard": "Charizard", "chicky": "Chicky", "connielyn": "Connie Lyn", "dragon": "Dragon", "dragonite": "Dragonite",
                                                    "freddy": "Freddy", "frizza": "Frizza", "gyrados": "Gyrados", "hulk": "Hulk", "mew-mewtwo": "Mew", "moltres": "Moltres", "mudkipz": "Mudkipz", "pikachu": "Pikachu", "pinky": "Pinky", "piplup": "Piplup", "queen": "Queen", "rabloox": "Rabloox", "robot": "Robot", "scyther": "Scyther", "sonic": "Sonic", "spiderman": "Spiderman", "squirtle": "Squirtle", "stormtrooper": "Storm trooper", "ur-draug": "Ur-Draug", "zapados": "Zapados"]
        
        for (key, _) in monsterNames {
            let modelScene = presenter.createScene(key)
            XCTAssertNotNil(modelScene)
            
        }
    }
}
