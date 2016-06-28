//
//  StarSystem.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation

enum SystemNature: Int, CustomStringConvertible {
    case Solo = 0
    case Binary
    case Trinary
    var description:String {
        switch self {
        case .Solo: return "Solo"
        case .Binary: return "Binary"
        case .Trinary: return "Trinary"
        }
    }
}

class StarSystem : CustomStringConvertible {
    var basicNature:    SystemNature
    var primary : Star = Star() // the primary star. Companions are satellites.
    var stars : [Star] = [] // all stars in the system.
    var mainWorld:      Planet? // the main world. Can be supplied, or generated.
    // It will ultimately be a link to a satellite.
    //    var maxOrbits:      Int = 0
    var gasGiants:      Bool=false
    var gasGiantCount:  Int = 0
    var gasGiantSizes = [GasGiantEnum]()
    var planetoids:     Bool=false
    var planetoidBelts: Int = 0
    var emptyOrbits:    Int = 0
    var capturedPlanets:Int = 0
    
    let d : Dice = Dice()
    
    init(newWorld: Planet? = nil) {

        // roll system basic nature
        switch Dice.roll(2) {
        case 2 ..<  8: basicNature = .Solo
        case 8 ..< 12: basicNature = .Binary
        case 12: basicNature = .Trinary
        default: basicNature = .Solo
        }
        
        /* determine primary type and size. Keep type and size rolls as they
         are DMs for any companions. */
        
        let typeRoll : Int = d.roll(2)
        let sizeRoll : Int = d.roll(2)
        var dmRequired = false
        if newWorld != nil {
            if (newWorld!.atmosphere >= 4 && newWorld!.atmosphere <= 9) || newWorld!.population >= 8 {
                dmRequired = true
            }
            mainWorld = newWorld
        }
        primary = Star(companion: false, typeRoll: typeRoll + (dmRequired ? 5 : 0), sizeRoll: sizeRoll + (dmRequired ? 5 : 0))
        stars.append(primary)
        // roll companions, if any
        var farCompanion = false // will be set to true if the companion is in a far orbit and has a companion of its own
        
        var compOrbits = Set<Float>()
        for companionIdx in 0..<basicNature.rawValue {
            // determine the orbit for the companion
            var orbit: Float = 0.0
            repeat {
                (orbit,farCompanion) = primary.getCompanionOrbit(companionIdx * 4)
            } while primary.getSatellite(orbit) != nil // we need an unassigned orbit
            // place companion in its orbit
            compOrbits.insert(orbit)
            let companion = Star(companion: true, typeRoll: d.roll(2) + typeRoll, sizeRoll: d.roll(2) + sizeRoll, parent: primary)
            stars.append(companion)
            companion.maxOrbits = companion.getMaxOrbits()
            if companion.maxOrbits > Int(orbit / 2) { companion.maxOrbits = Int(orbit / 2) }
            if farCompanion {
                var farOrbit : Float
                repeat {
                    (farOrbit,_) = companion.getCompanionOrbit(-4)
                } while companion.getSatellite(farOrbit) != nil // we need an unassigned orbit
                // place far companion in orbit
                let farComp = Star(companion: true, typeRoll: d.roll(2) + typeRoll, sizeRoll: d.roll(2) + sizeRoll, parent: companion)
                stars.append(farComp)
                farComp.maxOrbits = farComp.getMaxOrbits()
                if farComp.maxOrbits > Int(farOrbit / 2) { farComp.maxOrbits = Int(farOrbit / 2) }
                companion.addToOrbit(farOrbit, newSatellite: farComp)
            }
            // add the companion to the primary's orbit
            primary.addToOrbit(orbit, newSatellite: companion)
        }
        
        // determine maximum orbits for primary
        primary.maxOrbits = primary.getMaxOrbits()
        
        // we need to mark unavailable any orbits that conflict with a companion
        // first we need the companion orbits.
        
        for f in compOrbits {
            // mark orbits between companion and halfway to primary as unavailable
            if f > 0 { // close orbits don't make sense for this bit.
                let compOrb = Int(f)
                let unavailableOrbits = Int(f / 2) + 1 // numbered no more than half, so 'half' is ok
                for u in unavailableOrbits..<compOrb {
                    if primary.getSatellite(u) == nil {
                        primary.addToOrbit(Float(u), newSatellite: EmptyOrbit(parent: primary))
                    }
                }
            }
            // mark next-outer orbit as unavailable
            primary.addToOrbit(f + 1, newSatellite: EmptyOrbit(parent: primary))
        }

        // now, for each star in the system, we can determine planets and satellites.
        
        for star in stars {
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
            var orbit : Float = 0.0
            repeat {
                orbit = Float(d.roll(2))
            } while star.getSatellite(orbit) != nil
            star.addToOrbit(orbit, newSatellite: EmptyOrbit(parent:star))
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
            var orbit : Float
            // we should be able to unwrap here, as there would have to be at least some orbits available!
            repeat {
                orbit = star.getAvailOrbit()! + Float(d.roll(2) - 7) / 10
            } while star.getSatellite(orbit) != nil // just to make sure we didn't end up with two identical captured orbits...
            let p : Planet = Planet(orbit: orbit, starType: star.type, zone: star.getZone(Int(orbit))!,planetoid:false, parent: star)
            star.addToOrbit(orbit, newSatellite: p)
        }
        
        // roll gas giants
        if d.roll(2) <= 9 { gasGiants = true } else { gasGiants = false }

        // need to count available non-empty orbits in habitable and outer zones.
        var avail = star.getAvailHabOuterOrbits()

        if gasGiants {
            switch d.roll(2) {
            case  2 ..<  4: gasGiantCount = 1
            case  4 ..<  6: gasGiantCount = 2
            case  6 ..<  8: gasGiantCount = 3
            case  8 ..< 11: gasGiantCount = 4
            case 11,    12: gasGiantCount = 5
            default: break
            }
            
            if gasGiantCount > avail { // add necessary orbits to maximum
                star.maxOrbits += (gasGiantCount - avail)
                avail = gasGiantCount // and increase max non-empty orbits.
            }
            avail -= gasGiantCount
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
            if planetoidBelts > avail { planetoidBelts = avail }
            
        }
        for g in gasGiantSizes {
            if let orbit = star.getAvailHabitableOrOuterOrbit() {
                star.addToOrbit(orbit, newSatellite: GasGiant(size: g, parent: star))
            }
        }
        for _ in 0..<planetoidBelts {
            if let orbit = star.getAvailOrbit() {
                star.addToOrbit(orbit, newSatellite: Planet(orbit: orbit, starType: star.type, zone: star.getZone(orbit)!, planetoid: true, parent: star))
            }
        }
        for orbit in star.getAvailOrbits(Set<Zone>([Zone.H, Zone.I, Zone.O])) {
            star.addToOrbit(orbit, newSatellite: Planet(orbit: orbit, starType: star.type, zone: star.getZone(orbit)!, planetoid: false, parent: star))
        }
        for (o,p) in star.satellites.orbits {
            var s = 0
            let orbit = Float(o) / 10
            if p is Planet {
                if (p as! Planet).size > 0 {
                    s = d.roll() - 3
                }
            } else if p is GasGiant {
                let g = p as! GasGiant
                if g.size == GasGiantEnum.Small {
                    s = d.roll(2) - 4
                } else {
                    s = d.roll(2)
                }
            }
            if s < 0 {s = 0}
            //            print ("planetary satellite count=\(s)")
            var dm = 0
            for _ in 0..<s {
                let moon = Planet(orbit: orbit, starType: star.type, zone: star.getZone(orbit)!, planetoid: false, parent: p)
                var sOrbit = 0
                if moon.getSize() == "R" { // rings are handled differently
                    repeat {
                        switch d.roll() {
                        case 1...3: sOrbit = 1
                        case 4, 5:  sOrbit = 2
                        default:    sOrbit = 3
                        }
                    } while p.getSatellite(sOrbit) != nil
                } else {
                    repeat {
                        switch d.roll(2) + dm {
                        case 2...7: // close
                            sOrbit = d.roll(2) + 1
                        case 8...11: // far
                            sOrbit = d.roll(2) * 5 + 5
                        default:
                            if p is GasGiant {
                                sOrbit = d.roll(2) * 25 + 25
                            } else {
                                sOrbit = d.roll(2) * 5 + 5
                            }
                        }
                    } while p.getSatellite(sOrbit) != nil
                }
                p.addToOrbit(Float(sOrbit), newSatellite: moon)
                dm += 1
            }
        }
        }
        // now we need to find the main world = highest population
        mainWorld = primary.getMainWorld()
        if let mw = mainWorld {
            mw.rollGovernment()
            mw.rollLawLevel()
            mw.rollStarport()
            mw.rollTechLevel()
            mw.setTradeClassifications()
            mw.rollNavalBase()
            mw.rollScoutBase()
            
            let planets = primary.getPlanets()
            print("There are \(planets.count) planets altogether")
            // now we determine stats for all other planets and satellites
            for p in primary.getPlanets() {
                if p != mw { // don't mess with the mainworld...
                    p.setSatelliteAttribs(mw)
                }
            }
        }
    }
    
    func strord(count: Int, things: String)->String {
        var result = ""
        if count == 1 {
            result += "is "
        } else {
            result += "are "
        }
        result += String(count)
        result += " "
        result += things
        if count != 1 {
            result += "s"
        }
        return result
    }
    
    var description:String {
        
        var result: String = ""
        result += "This is a \(basicNature) system.\n"
        result += "The primary star is \(primary)\n"
        //        result += "Possible zones are: \(tableOfZones[primary]!.description))\n"
//        result += "The system has \(primary.maxOrbits) maximum orbits.\n"
        result += "There " + strord(capturedPlanets, things: "captured planet") + ".\n"
        result += "There " + strord(emptyOrbits, things: "empty orbit") + ".\n"
        result += "There " + strord(gasGiantCount, things: "gas giant") + ".\n"
        result += "There " + strord(planetoidBelts, things: "planetoid belt") + ".\n"
        result += "The main world is \(mainWorld!.uwp).\n"
        return result
    }
}

