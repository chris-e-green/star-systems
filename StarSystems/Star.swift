//
//  Star.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation

/// Possible star spectral types
enum StarType:String/*, CustomStringConvertible */{
    case O
    case B
    case A
    case F
    case G
    case K
    case M
    case Z
//    var description:String { return self.rawValue }
//        switch self {
//        case .O : return "O"
//        case .B : return "B"
//        case .A : return "A"
//        case .F : return "F"
//        case .G : return "G"
//        case .K : return "K"
//        case .M : return "M"
//        case .Z : return "Undefined"
//        }
//    }
}

/// Possible star sizes
enum StarSize:String,CustomStringConvertible {
    case Ia
    case Ib
    case II
    case III
    case IV
    case V
    case D
    case Z
//    var description:String { return self.rawValue }
//        switch self {
//        case Ia: return "Ia"
//        case Ib: return "Ib"
//        case II: return "II"
//        case III: return "III"
//        case IV: return "IV"
//        case V: return "V"
//        case D: return "D"
//        case Z: return ""
//        }
//    }
    var description:String {
        switch self {
        case Ia: return "Bright Supergiant"
        case Ib: return "Weaker Supergiant"
        case II: return "Bright Giant"
        case III: return "Giant"
        case IV: return "Subgiant"
        case V: return "Main Sequence"
        case D: return "White Dwarf"
        case Z: return "Undefined"
        }
    }
}

/// Possible orbit zones around a star
enum Zone: String, CustomStringConvertible {
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

/// the defined zones for each star type and size
let tableOfZones:[Star:[Zone]] = [
    //                           0  1  2  3  4  5  6  7  8  9 10 11 12 13 14
    Star(t: .B, d: 0, s: .Ia): [.W,.U,.U,.U,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O],
    Star(t: .B, d: 5, s: .Ia): [.W,.U,.U,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O],
    Star(t: .A, d: 0, s: .Ia): [.W,.W,.U,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O],
    Star(t: .A, d: 5, s: .Ia): [.W,.W,.U,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O],
    Star(t: .F, d: 0, s: .Ia): [.W,.W,.W,.U,.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O],
    Star(t: .F, d: 5, s: .Ia): [.W,.W,.W,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O,.O],
    Star(t: .G, d: 0, s: .Ia): [.W,.W,.W,.W,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O],
    Star(t: .G, d: 5, s: .Ia): [.W,.W,.W,.W,.W,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O],
    Star(t: .K, d: 0, s: .Ia): [.W,.W,.W,.W,.W,.W,.U,.I,.I,.I,.I,.I,.H,.O,.O],
    Star(t: .K, d: 5, s: .Ia): [.W,.W,.W,.W,.W,.W,.U,.I,.I,.I,.I,.I,.H,.O,.O],
    Star(t: .M, d: 0, s: .Ia): [.W,.W,.W,.W,.W,.W,.W,.I,.I,.I,.I,.I,.H,.O,.O],
    Star(t: .M, d: 5, s: .Ia): [.W,.W,.W,.W,.W,.W,.W,.W,.I,.I,.I,.I,.H,.O,.O],
    Star(t: .M, d: 9, s: .Ia): [.W,.W,.W,.W,.W,.W,.W,.W,.I,.I,.I,.I,.H,.O,.O],
    //                           0  1  2  3  4  5  6  7  8  9 10 11 12 13 14
    Star(t: .B, d: 0, s: .Ib): [.U,.U,.U,.U,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O],
    Star(t: .B, d: 5, s: .Ib): [.U,.U,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O,.O],
    Star(t: .A, d: 0, s: .Ib): [.W,.U,.U,.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O],
    Star(t: .A, d: 5, s: .Ib): [.W,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    Star(t: .F, d: 0, s: .Ib): [.W,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    Star(t: .F, d: 5, s: .Ib): [.W,.U,.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    Star(t: .G, d: 0, s: .Ib): [.W,.U,.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    Star(t: .G, d: 5, s: .Ib): [.W,.W,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    Star(t: .K, d: 0, s: .Ib): [.W,.W,.W,.W,.U,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    Star(t: .K, d: 5, s: .Ib): [.W,.W,.W,.W,.W,.U,.I,.I,.I,.I,.I,.H,.O,.O,.O],
    Star(t: .M, d: 0, s: .Ib): [.W,.W,.W,.W,.W,.W,.I,.I,.I,.I,.I,.H,.O,.O,.O],
    Star(t: .M, d: 5, s: .Ib): [.W,.W,.W,.W,.W,.W,.W,.I,.I,.I,.I,.I,.H,.O,.O],
    Star(t: .M, d: 9, s: .Ib): [.W,.W,.W,.W,.W,.W,.W,.W,.I,.I,.I,.I,.H,.O,.O],
    //                           0  1  2  3  4  5  6  7  8  9 10 11 12 13
    Star(t: .B, d: 0, s: .II): [.U,.U,.U,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O],
    Star(t: .B, d: 5, s: .II): [.U,.U,.U,.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O],
    Star(t: .A, d: 0, s: .II): [.U,.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    Star(t: .A, d: 5, s: .II): [.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O],
    Star(t: .F, d: 0, s: .II): [.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O],
    Star(t: .F, d: 5, s: .II): [.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O],
    Star(t: .G, d: 0, s: .II): [.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O],
    Star(t: .G, d: 5, s: .II): [.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O],
    Star(t: .K, d: 0, s: .II): [.W,.U,.I,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    Star(t: .K, d: 5, s: .II): [.W,.W,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    Star(t: .M, d: 0, s: .II): [.W,.W,.W,.W,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O],
    Star(t: .M, d: 5, s: .II): [.W,.W,.W,.W,.W,.W,.I,.I,.I,.I,.I,.H,.O,.O],
    Star(t: .M, d: 9, s: .II): [.W,.W,.W,.W,.W,.W,.I,.I,.I,.I,.I,.H,.O,.O],
    //                            0  1  2  3  4  5  6  7  8  9 10 11 12 13
    Star(t: .A, d: 0, s: .III): [.I,.I,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O],
    Star(t: .A, d: 5, s: .III): [.I,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O],
    Star(t: .F, d: 0, s: .III): [.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O],
    Star(t: .F, d: 5, s: .III): [.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O],
    Star(t: .G, d: 0, s: .III): [.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O],
    Star(t: .G, d: 5, s: .III): [.I,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O],
    Star(t: .K, d: 0, s: .III): [.I,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O],
    Star(t: .K, d: 5, s: .III): [.W,.I,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O],
    Star(t: .M, d: 0, s: .III): [.W,.W,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O],
    Star(t: .M, d: 5, s: .III): [.W,.W,.W,.W,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    Star(t: .M, d: 9, s: .III): [.W,.W,.W,.W,.W,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    //                           0  1  2  3  4  5  6  7  8  9 10 11 12 13
    Star(t: .A, d: 0, s: .IV): [.W,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O],
    Star(t: .A, d: 5, s: .IV): [.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O],
    Star(t: .F, d: 0, s: .IV): [.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O],
    Star(t: .F, d: 5, s: .IV): [.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O],
    Star(t: .G, d: 0, s: .IV): [.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O],
    Star(t: .G, d: 5, s: .IV): [.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O],
    Star(t: .K, d: 0, s: .IV): [.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    //                          0  1  2  3  4  5  6  7  8  9 10 11 12 13
    Star(t: .A, d: 0, s: .V): [.I,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O],
    Star(t: .A, d: 5, s: .V): [.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O],
    Star(t: .F, d: 0, s: .V): [.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O],
    Star(t: .F, d: 5, s: .V): [.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    Star(t: .G, d: 0, s: .V): [.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    Star(t: .G, d: 5, s: .V): [.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    Star(t: .K, d: 0, s: .V): [.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    Star(t: .K, d: 5, s: .V): [.H,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    Star(t: .M, d: 0, s: .V): [.H,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    Star(t: .M, d: 5, s: .V): [.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    Star(t: .M, d: 9, s: .V): [.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    
    Star(t: .B, d: 0, s: .D): [.H,.O,.O,.O,.O],
    Star(t: .B, d: 5, s: .D): [.H,.O,.O,.O,.O],
    Star(t: .B, d: 9, s: .D): [.H,.O,.O,.O,.O],
    
    Star(t: .A, d: 0, s: .D): [.O,.O,.O,.O,.O],
    Star(t: .A, d: 5, s: .D): [.O,.O,.O,.O,.O],
    Star(t: .A, d: 9, s: .D): [.O,.O,.O,.O,.O],
    
    Star(t: .F, d: 0, s: .D): [.O,.O,.O,.O,.O],
    Star(t: .F, d: 5, s: .D): [.O,.O,.O,.O,.O],
    Star(t: .F, d: 9, s: .D): [.O,.O,.O,.O,.O],
    
    Star(t: .G, d: 0, s: .D): [.O,.O,.O,.O,.O],
    Star(t: .G, d: 5, s: .D): [.O,.O,.O,.O,.O],
    Star(t: .G, d: 9, s: .D): [.O,.O,.O,.O,.O],
    
    Star(t: .K, d: 0, s: .D): [.O,.O,.O,.O,.O],
    Star(t: .K, d: 5, s: .D): [.O,.O,.O,.O,.O],
    Star(t: .K, d: 9, s: .D): [.O,.O,.O,.O,.O],
    
    Star(t: .M, d: 0, s: .D): [.O,.O,.O,.O,.O],
    Star(t: .M, d: 5, s: .D): [.O,.O,.O,.O,.O],
    Star(t: .M, d: 9, s: .D): [.O,.O,.O,.O,.O],
]

/// The class that defines all stars.
class Star : Satellite, Hashable, Equatable, CustomStringConvertible {
    var type: StarType = .A
    var decimal: Int = 0
    var size: StarSize = .Ia
    var maxOrbits: Int = 0
    var hashValue: Int {get {return self.type.hashValue * 100 + self.decimal * 10 + self.size.hashValue}}
    var description : String {
        var d: String = ""
        let pad = String(count: depth, repeatedValue: Character(" "))
        d += pad
        if size == .D { d += "\(size.rawValue)\(type) " }
        else { d += "\(type)\(decimal)\(size.rawValue) " }
        d += "(\(size.description))\n"
        d += "Max orbits = \(maxOrbits)\n"
        d += "\(satDesc)"
        return d
    }

    convenience init(type: StarType, decimal: Int, size: StarSize, parent: Star? = nil) {
        self.init(t: type, d: decimal, s: size)
        self.type = type
        self.decimal = decimal
        self.size = size
        self.parent = parent
    }
    
    init(t: StarType = .A, d: Int = 0, s: StarSize = .Ia, p: Star? = nil) {
        super.init(parent:p)
        self.type = t
        self.decimal = d
        self.size = s
    }

    convenience init(companion: Bool, typeRoll:Int, sizeRoll:Int, parent: Star? = nil) {
        self.init()
        self.parent = parent
        if companion {
        switch typeRoll {
            case 1:   self.type = .B
            case 2:   self.type = .A
            case 3,4: self.type = .F
            case 5,6: self.type = .G
            case 7,8: self.type = .K
            default:  self.type = .M
            }
        } else {
            switch typeRoll {
            case 2:     self.type = .A
            case 3...7: self.type = .M
            case 8:     self.type = .K
            case 9,10:  self.type = .G
            default:    self.type = .F
            }
        }
        
        if Dice.roll(1) <= 3 { self.decimal = 0 } else { self.decimal = 5}
            
        if companion {
            switch sizeRoll {
            case 0: self.size = .Ia
            case 1: self.size = .Ib
            case 2: self.size = .II
            case 3: self.size = .III
            case 4: self.size = .IV
            case 5...11: self.size = .V
            default: self.size = .D
            }
        } else {
            switch sizeRoll {
            case 2: self.size = .II
            case 3: self.size = .III
            case 4: self.size = .IV
            default: self.size = .V
            }
        }
        if ((self.type == .K && self.decimal == 5) || (self.type == .M)) && (self.size == .IV) {
                self.size = .V
        }
    }

/// Get the main world of this system (if such a thing exists). 
/// The main world is the planet with the highest population, and if there's more than
/// one, by preference one in the habitable zone, otherwise the one closest to the sun.
///
/// - returns: 
///      The planet (if one exists) that matches the criteria.
    func getMainWorld()->Planet? {
        var mainWorld: Planet?
        var minOrbit: Float = Float.infinity
        let (worlds, _) = getMaxPop()  // worlds is an array of worlds that have the maximum population.
        // now we need to weed out to find the actual mainworld.
        for planet in worlds {
            if let p1 = planet {
                // habitable is first preference
                if p1.zone == Zone.H {
                    mainWorld = planet
                } else {
                    if p1.orbit < minOrbit {
                        mainWorld = planet
                        minOrbit = p1.orbit
                    }
                }
            }
        }
        return mainWorld
    }
    
/// Obtain a random orbit number in the inner, habitable or outer zone.
/// - Returns: A random available inner, habitable or outer orbit number.
    func getAvailOrbit() -> Float? {
        var o:Float?
        var possibilities = getAvailOrbits(Set<Zone>([Zone.H, Zone.O, Zone.I]))
        if possibilities.count > 0 {
            let r = Dice.roll(1, sides:possibilities.count)
            o = possibilities[r-1]
        }
        return o
    }
    
/// Obtain all available orbits within the supplied zones.
///
/// - parameters:
///     - zones: The `Zone`s that the orbit must be within
///
/// - Returns: An array of empty orbits that are within the requested `Zone`s.
    func getAvailOrbits(zones:Set<Zone>)->[Float] {
        var orbits:[Float] = []
        for i in 0..<maxOrbits {
            if zones.contains(getZone(i)!) && getSatellite(i) == nil {
                orbits.append(Float(i))
            }
        }
        return orbits
    }

/// Obtain a random available habitable or outer orbit.
/// 
/// - Returns: A random unoccupied orbit within the habitable and outer zones.
    func getAvailHabitableOrOuterOrbit()->Float? {
        // returns a random available habitable or outer orbit number.
        var o:Float?
        var possibilities = getAvailOrbits(Set<Zone>([Zone.H, Zone.O]))
        if possibilities.count > 0 {
            let r = Dice.roll(1, sides:possibilities.count)
            o = possibilities[r-1]
        }
        return o
    }
    
/// Return the number of available habitable and outer orbits.
///
/// - Returns: The number of available orbits in the habitable and outer zones.
    func getAvailHabOuterOrbits()->Int {
        return getAvailOrbits(Set<Zone>([Zone.H, Zone.O])).count
    }

    func getMaxOrbits() -> Int {
        // determine maximum orbits
        var orbitDM : Int = 0
        var result: Int
        if size == .III { orbitDM += 4}
        if size == .II { orbitDM += 8}
        if type == .M { orbitDM -= 4}
        if type == .K { orbitDM -= 2}
        result = Dice.roll(2) + orbitDM
        if result < 0 { result = 0 }
        // maximum orbits is open-ended so no need to place upper limits.
        return result
    }
    
/// Obtain a random orbit for a companion star.
/// 
/// - parameters: 
///     - dm: The dice modifier for the throw.
/// - Returns:
///     A tuple containing
///     - orbitNum: The orbit number.
///     - inFarOrbit: True if the orbit number is Far, and thus the companion could have its own companion.
    func getCompanionOrbit(dm: Int)->(orbitNum: Float, inFarOrbit: Bool) {
        /* curiously, the distribution of possible companion orbits is seemingly quite
         arbitrary.
         
         orbit 4 is not possible(!);
         orbit 14 has about 1% chance;
         orbit 13 has a 2% chance;
         orbit 5 has a 3% chance;
         orbit 12 has a 4% chance;
         orbit 6 has a 5% chance;
         orbit 11 has a 6% chance;
         orbit 7 has a 7% chance;
         orbits 0, 1 and 8 have about 8% chance each;
         orbits 9 and 10 have a 9% chance each;
         orbit 2 has an 11% chance;
         orbit 3 has a 14% chance;
         
         However, this implementation is based on the rules as written, so the
         weirdness remains. The only thing I've done is to turn the "far" orbits into
         real ones: under the rules as written, "far" is 1D6 * 1,000 AU. This puts
         1 at about orbit 13.7, 
         2 at about orbit 14.7, 
         3 at about orbit 15.3, 
         4 at about orbit 15.7, 
         5 at about orbit 16 and 
         6 at about orbit 16.3.
         */
        
        var farOrbit: Bool = false
        var orbit: Float
        
        switch Dice.roll(2) + dm {
        case 0..<4: orbit = 0 // aka 'close' orbit
        case 4:     orbit = 1
        case 5:     orbit = 2
        case 6:     orbit = 3
        case 7:     orbit = 4 + Float(Dice.roll(1))
        case 8:     orbit = 5 + Float(Dice.roll(1))
        case 9:     orbit = 6 + Float(Dice.roll(1))
        case 10:    orbit = 7 + Float(Dice.roll(1))
        case 11:    orbit = 8 + Float(Dice.roll(1))
        default: // if its not one of the above it's "far".
            farOrbit = true
            switch Dice.roll() {
            case 1: orbit = 13.7
            case 2: orbit = 14.7
            case 3: orbit = 15.3
            case 4: orbit = 15.7
            case 5: orbit = 16
            default:orbit = 16.3
            }
        }
        return (orbit, farOrbit)
    }

}
func ==(lhs: Star, rhs: Star) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
