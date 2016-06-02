//
//  StarSystem.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation
enum SystemNature: Int, CustomStringConvertible {
    case Solo = 1
    case Binary
    case Trinary
    var description:String {
        switch self {
        case .Solo: return "Solo"
        case .Binary: return "Binary"
        case .Trinary: return "Trinary"
        }
    }
//    func starCount()->Int {
//        switch self {
//        case .Solo: return 1
//        case .Binary: return 2
//        case .Trinary: return 3
//        }
//    }
}
enum GasGiant : CustomStringConvertible {
    case Small
    case Large
    var description:String {
        switch self {
        case Small: return "Small"
        case Large: return "Large"
        }
    }
}

let tableOfZones:[Star:[Zone]] = [
    //                               0  1  2  3  4  5  6  7  8  9 10 11 12 13 14
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
    //                               0  1  2  3  4  5  6  7  8  9 10 11 12 13 14
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
    //                               0  1  2  3  4  5  6  7  8  9 10 11 12 13
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
    //                                0  1  2  3  4  5  6  7  8  9 10 11 12 13
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
    //                               0  1  2  3  4  5  6  7  8  9 10 11 12 13
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
]

class StarSystem : CustomStringConvertible {
    var basicNature:    SystemNature
    var star : Star = Star()
    //    var primary =       Star(type: .A, decimal: 0, size: .Ia, orbit: -1)
    
    var maxOrbits:      Int = 0
    var gasGiants:      Bool=false
    var gasGiantCount:  Int = 0
    var gasGiantSizes = [GasGiant]()
    var planetoids:     Bool=false
    var planetoidBelts: Int = 0
    var emptyOrbits:    Int = 0
    var capturedPlanets:Int = 0

    let d : Dice = Dice(sides: 6)
    
    func rollPrimaryStar(typeRoll: Int, sizeRoll: Int)->Star {
        let star : Star = Star()
        switch typeRoll {
        case 2: star.type = .A
        case 3..<8:star.type = .M
        case 8:star.type = .K
        case 9,10: star.type = .G
        case 11,12: star.type = .F
        default:star.type = .B
        }
        if d.roll(1) <= 3 { star.decimal = 0 } else { star.decimal = 5}
        switch sizeRoll {
        case 2: star.size = .II
        case 3: star.size = .III
        case 4: star.size = .IV
        default: star.size = .V
        }
        if ((star.type == .K && star.decimal == 5) || (star.type == .M)) && (star.size == .IV) {star.size = .V}
        return star
    }
    
    func rollCompanionStar(typeDM:Int,sizeDM:Int)->Star {
        let star : Star = Star()
        switch d.roll(2) + typeDM {
        case 1:   star.type = .B
        case 2:   star.type = .A
        case 3,4: star.type = .F
        case 5,6: star.type = .G
        case 7,8: star.type = .K
        default:  star.type = .M
        }
        if d.roll(1) <= 3 { star.decimal = 0 } else { star.decimal = 5}
        switch d.roll(2) + sizeDM {
        case 0: star.size = .Ia
        case 1: star.size = .Ib
        case 2: star.size = .II
        case 3: star.size = .III
        case 4: star.size = .IV
        default: star.size = .V
        }
        if ((star.type == .K && star.decimal == 5) || (star.type == .M)) && (star.size == .IV) {star.size = .V}
        return star
    }
    
    init(planet: Planet) {
            basicNature = StarSystem.rollBasicNature(((planet.atmosphere >= 4 && planet.atmosphere <= 9) || planet.population >= 8))
    }
    
    static func rollBasicNature(mainDMRequired: Bool) -> SystemNature {
        // roll system basic nature
        switch Dice.roll(2, sides: 6) + (mainDMRequired ? 5 : 0) {
        case 2..<8: return .Solo
        case 8..<12: return .Binary
        case 12: return .Trinary
        default: return .Solo
        }
    }
    
    init() {
        basicNature = StarSystem.rollBasicNature(false)
        /* determine primary type and size. Keep type and size rolls as they
           are DMs for any companions. */
        let typeRoll : Int = d.roll(2)
        let sizeRoll : Int = d.roll(2)
        star=rollPrimaryStar(typeRoll, sizeRoll: sizeRoll)
        // roll companions, if any
        for i in 1..<basicNature.rawValue {
            // determine the orbit for the companion
            var orbit: Int = 0
            repeat {
                switch d.roll(2) + (i-1)*4 {
                case 0..<4: orbit = 0
                case 4:     orbit = 10
                case 5:     orbit = 20
                case 6:     orbit = 30
                case 7:     orbit = 40 + d.roll(1)*10
                case 8:     orbit = 50 + d.roll(1)*10
                case 9:     orbit = 60 + d.roll(1)*10
                case 10:    orbit = 70 + d.roll(1)*10
                case 11:    orbit = 80 + d.roll(1)*10
                case 12:    orbit = 150
                default:    orbit = 150
                }
            } while star.satellites[orbit] != nil // we need an unassigned orbit
            // place companion in its orbit
            star.satellites[orbit]=rollCompanionStar(typeRoll, sizeDM: sizeRoll)
        }
        // determine maximum orbits for primary
        var orbitDM : Int = 0
        if star.size == .III { orbitDM += 4}
        if star.size == .II { orbitDM += 8}
        if star.type == .M { orbitDM -= 4}
        if star.type == .K { orbitDM -= 2}
        maxOrbits = d.roll(2)+orbitDM
        if maxOrbits < 0 {maxOrbits = 0}
        if maxOrbits > 12 {maxOrbits = 12}
        
        for i in 0 ..< maxOrbits  {
            star.zones[i] = getZone(star, orbit: i)
        }
        let sortedArray = star.zones.sort({$0.0 < $1.0})
        print(sortedArray)
        let emptyCapturedDM : Int = ((star.type == .B || star.type == .A) ? 1 : 0)
        // roll empty orbits
        if d.roll(1) + emptyCapturedDM > 4 {
            switch d.roll(1) + emptyCapturedDM {
            case 1,2:   emptyOrbits = 1
            case 3:     emptyOrbits = 2
            default:    emptyOrbits = 3
            }
        }
        for _ in 0 ..< emptyOrbits {
            var orbit : Int = 0
            repeat {
                orbit = d.roll(2)*10
            } while star.satellites[orbit] != nil
            star.satellites[orbit] = EmptyOrbit()
        }
        // roll captured planets
        if d.roll(1) + emptyCapturedDM > 4 {
            switch d.roll(1) + emptyCapturedDM {
            case 1,2:  capturedPlanets = 1
            case 3,4:  capturedPlanets = 2
            default:   capturedPlanets = 3
            }
        }
        for _ in 0 ..< capturedPlanets {
            var orbit : Int = 0
            repeat {
                orbit = (d.roll(2)*10) + (d.roll(2) - 7)
            } while star.satellites[orbit] != nil
            star.zones[orbit] = getZone(star, orbit: orbit/10)
            let p : Planet = Planet()
            p.generateRandomPlanet(orbit, starType: star.type, zone: star.zones[orbit]!)
            star.satellites[orbit] = p
        }
        // roll gas giants
        if d.roll(2) <= 9 { gasGiants = true } else { gasGiants = false }
        if gasGiants {
            switch d.roll(2) {
            case 2..<4: gasGiantCount = 1
            case 4..<6: gasGiantCount = 2
            case 6..<8: gasGiantCount = 3
            case 8..<11: gasGiantCount = 4
            case 11, 12: gasGiantCount = 5
            default: break
            }
            // need to count available non-empty orbits in habitable and outer zones.
            
            if gasGiantCount > maxOrbits {gasGiantCount = maxOrbits}
        }
        for _ in 0..<gasGiantCount {
            if d.roll(1) <= 3 { gasGiantSizes.append(.Large) } else { gasGiantSizes.append(.Small) }
        }
        // roll planetoids
        if d.roll(2) - gasGiantCount <= 6 { planetoids = true } else { planetoids = false }
        if planetoids {
            var planetoidRoll : Int = d.roll(2) - gasGiantCount
            if planetoidRoll < 0 { planetoidRoll = 0 }
            switch planetoidRoll {
            case 0: planetoidBelts = 3
            case 1..<7: planetoidBelts = 2
            default: planetoidBelts = 1
            }
        }
    }
    
    func getZone(star: Star, orbit: Int) -> Zone {
        var zone : Zone? = tableOfZones[star]?[orbit]
        if zone == nil { zone = Zone.O }
        return zone!
    }
    
    var description:String {
        let sortedArray = star.satellites.sort({$0.0 < $1.0})
        var satelliteStr : String = ""
        for i in sortedArray {
            satelliteStr += "\(star.zones[i.0/10]!)\t\(Double(i.0) / 10.0)\t\(i.1)\n"
        }
      
        return "\nThis is a \(basicNature) system.\n" +
        "The primary star is \(star).\n" +
        "Possible zones are: \(tableOfZones[star]?.description)!)\n" +
            "There " + (star.satellites.count == 1 ? "is" : "are") + " \(star.satellites.count) satellite" + (star.satellites.count != 1 ? "s" : "") + ":\n\(satelliteStr)\n" +
        "The system has \(maxOrbits) maximum orbits.\n" +
        "There are \(gasGiantCount) gas giants: \(gasGiantSizes).\n" +
        "There are \(planetoidBelts) planetoid belts."
    }
}

