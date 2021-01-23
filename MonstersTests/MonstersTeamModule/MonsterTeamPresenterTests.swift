//
//  MonsterTeamPresenterTests.swift
//  MonstersTests
//
//  Created by Maxim Alekseev on 23.01.2021.
//

import XCTest
@testable import Monsters

class MonsterTeamPresenterTests: XCTestCase {
    
    var presenter: MonsterTeamPresenter!

    override func setUpWithError() throws {
        
        let view = MonsterTeamViewController()
        let router = Router(navigationController: UINavigationController(), assemblyBuilder: AssemblyBuilder())
        presenter = MonsterTeamPresenter(view: view, router: router)
        
    }

    override func tearDownWithError() throws {
        presenter = nil
    }
    
    //monstersTeam test
    func testMonsterTeam() {
        let savedMonsters = UserDefaults.standard.savedMonsters()
        XCTAssertEqual(presenter.monstersTeam.count, savedMonsters.count)
    }
}
