//
//  ModeleSceneTests.swift
//  MonstersTests
//
//  Created by Maxim Alekseev on 22.01.2021.
//

import XCTest
@testable import Monsters

class ModeleSceneTests: XCTestCase {
    
    var modeleScene: ModelScene!

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        modeleScene = nil
    }
    
    func testConfigureAsPokeBall() {
        
        modeleScene = ModelScene(named: "pokeball")
        
        XCTAssertNotNil(modeleScene.scene)
        XCTAssertNotNil(modeleScene.node)
        XCTAssertTrue(modeleScene.node?.name == "PokeBall")
        
    }
    
    func testConfigureAsMonster() {
        
        modeleScene = ModelScene(named: "altair")
        
        XCTAssertNotNil(modeleScene.scene)
        XCTAssertNotNil(modeleScene.node)
        XCTAssertTrue(modeleScene.node?.name == "Monster")
        
    }
}
