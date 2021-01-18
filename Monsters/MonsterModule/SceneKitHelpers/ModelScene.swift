//
//  MonsterScene.swift
//  Monsters
//
//  Created by Maxim Alekseev on 17.01.2021.
//

import Foundation
import SceneKit

class ModelScene {
    
    let scene: SCNScene?
    
    var node: SCNNode? {
        return scene?.rootNode.childNodes.first
    }
    
    init?(named: String) {
        
        self.scene = SCNScene(named: "art.scnassets/\(named).scn")
        
        if named == "pokeball" {
            
            configureAsPokeball()
            
        } else {
            
            self.configureAsMonster()
            
        }
    }
    
    private func configureAsPokeball() {
        
        guard node != nil else { return }
        
        node?.name = "PokeBall"
        node?.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node?.physicsBody?.categoryBitMask = BitMaskCategory.pokeBall
        
        node?.physicsBody?.collisionBitMask = BitMaskCategory.monster |
            BitMaskCategory.pokeBall |
            BitMaskCategory.plane
        
        node?.physicsBody?.contactTestBitMask = BitMaskCategory.monster
        node?.physicsBody?.angularDamping = 0.9
        
    }
    
    private func configureAsMonster() {
        
        guard node != nil else { return }
        
        node?.name = "Monster"
        node?.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        node?.physicsBody?.categoryBitMask = BitMaskCategory.monster
        node?.physicsBody?.collisionBitMask = BitMaskCategory.pokeBall
        node?.physicsBody?.contactTestBitMask = BitMaskCategory.pokeBall
        
    }
}
