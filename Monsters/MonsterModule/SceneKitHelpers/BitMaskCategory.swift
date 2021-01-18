//
//  BitMaskCategory.swift
//  Monsters
//
//  Created by Maxim Alekseev on 17.01.2021.
//

import Foundation

struct BitMaskCategory {
    
    static let none  = 0 << 0 // 00000000...0  0
    static let pokeBall = 1 << 0 // 00000000...1  1
    static let monster = 1 << 1 // 0000000...10  2
    static let plane = 1 << 2 // 0000000...10  3

}
