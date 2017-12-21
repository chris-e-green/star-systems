//
//  Dice.swift
//  StarSystems
//
//  Created by Christopher Green on 24/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation


class Dice {
    var sides = 6
    
    static func roll(_ count: Int = 1, sides: Int = 6) -> Int {
        var total = 0
        for _ in 0..<count {
            total = total + Int(arc4random_uniform(UInt32(sides)) + 1)
        }
        return total
    }
    
    func roll() -> Int {
        return Int(arc4random_uniform(UInt32(self.sides)) + 1)
    }
    
    func roll(_ count: Int) -> Int {
        var total = 0
        for _ in 0..<count {
            total = total + roll()
        }
        return total
    }
    
    init(sides: Int = 6) {
        self.sides = sides
    }
    
}

