//
//  RouterTests.swift
//  MonstersTests
//
//  Created by Maxim Alekseev on 08.01.2021.
//

import XCTest
import CoreLocation
@testable import Monsters

class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: true)
    }
}


class RouterTests: XCTestCase {
    
    var router: RouterProtocol!
    var navigationController = MockNavigationController()

    override func setUpWithError() throws {
        let assembly = AssemblyBuilder()
        router = Router(navigationController: navigationController, assemblyBuilder: assembly)
    }

    override func tearDownWithError() throws {
        router = nil
    }

    func testShowMonster() {
        
        let monster = Monster(name: "Foo", imageName: "foo", level: 1, coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 1) )
        router.showMonsterModule(monster)
        let monsterVC = navigationController.presentedVC
        XCTAssertTrue(monsterVC is MonsterViewController)
    }
    
}
