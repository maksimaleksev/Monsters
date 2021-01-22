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
        
    }
}
