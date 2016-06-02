//
//  Star.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation

enum StarType:Int {
    case O = 1
    case B
    case A
    case F
    case G
    case K
    case M
    case Z
    func simpleDescription()->String {
        switch self {
        case .O : return "O"
        case .B : return "B"
        case .A : return "A"
        case .F : return "F"
        case .G : return "G"
        case .K : return "K"
        case .M : return "M"
        case .Z : return "Undefined"
        }
    }
}

enum StarSize:Int {
    case Ia = 1
    case Ib
    case II
    case III
    case IV
    case V
    case Z
    func simpleDescription()->String {
        switch self {
        case Ia: return "Ia (Bright Supergiant)"
        case Ib: return "Ib (Weaker Supergiant)"
        case II: return "II (Bright Giant)"
        case III: return "III (Giant)"
        case IV: return "IV (Subgiant)"
        case V: return "V (Main Sequence)"
        case Z: return "Undefined"
        }
    }
}

enum Zone: CustomStringConvertible {
    case O
    case H
    case I
    case U
    case W
    case Z
    var description:String {
        switch self {
        case O: return "Outer"
        case H: return "Habitable"
        case I: return "Inner"
        case U: return "Unavailable"
        case W: return "Within star"
        case Z: return "Undefined"
        }
    }
}


class Star : Satellite, CustomStringConvertible, Hashable, Equatable {
    var type: StarType = .A
    var decimal: Int = 0
    var size: StarSize = .Ia
    var hashValue: Int {get {return self.type.rawValue * 100 + self.decimal * 10 + self.size.rawValue}}
    var zones: [Int: Zone] = [:]
    var description : String {
        return "\(self.type.simpleDescription())\(self.decimal) \(self.size.simpleDescription())"
    }

    convenience init(type: StarType, decimal: Int, size: StarSize) {
        self.init()
        self.type = type
        self.decimal = decimal
        self.size = size
    }
    convenience init(t: StarType, d: Int, s: StarSize) {
        self.init(type:t,decimal:d,size:s)
    }
}
func ==(lhs: Star, rhs: Star) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
