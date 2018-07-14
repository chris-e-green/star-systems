//
//  StarSystem.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//
//  The Traveller game in all forms is owned by Far Future Enterprises.
//  Copyright 1977 - 2008 Far Future Enterprises.
//

import Foundation

enum SystemNature: Int, CustomStringConvertible {
    case solo = 0 // leaving this as Int because it makes it simple to do some DM work later
    case binary
    case trinary
    var description:String {
        switch self {
        case .solo: return "Solo"
        case .binary: return "Binary"
        case .trinary: return "Trinary"
        }
    }
}

class StarSystem : CustomStringConvertible {
    var basicNature:     SystemNature
    var subsectorName:   String = ""
    var primary:         Star   = Star()  // the primary star. Companions are satellites.
    var stars:           [Star] = []      // all *orbitable* stars in the system.
//    var starCount:       Int    = 0       // The number of stars, including non-orbital (close) companions.
    var mainWorld:       Planet?          // the main world. Can be supplied, or generated.
                                          // It will ultimately be a link to a satellite.
    var gasGiants:       Bool   = false   // per system
    var gasGiantCount:   Int    = 0       // per system
    var gasGiantSizes =  [GasGiantEnum]() // per system
    var planetoids:      Bool   = false   // per system
    var planetoidBelts:  Int    = 0       // per system
    var emptyOrbits:     Int    = 0       // per star
    var capturedPlanets: Int    = 0       // per star
    var coordinateX:     Int    = 0
    var coordinateY:     Int    = 0
    
    var mainWorldPlaced: Bool   = false
    
    var allHabitable:[(Star, Float)] {
        var result: [(Star, Float)] = []
        for star in stars {
            if let h = star.getHabOrbit() {
                result.append((star, h))
            }
        }
        return result
    }
    
    var allPlanets:[Planet] {
        var result: [Planet] = []
        for star in stars {
            let h = star.getPlanets()
            result.append(contentsOf: h)
            if DEBUG { print("added \(h) to allPlanets") }
        }
        return result
    }
    
    func getAllAvailOrbits(_ zones: Set<Zone>)->[(Star, Float)] {
        var result: [(Star, Float)] = []
        for star in stars {
            let s1 = star.getAvailOrbits(zones, createIfNone: false)
            for i in s1 {
                result.append((star, i))
            }
        }
        return result
    }
    var allAvailHabitable:[(Star, Float)] {
        return getAllAvailOrbits(Set<Zone>([Zone.H]))
    }
    
    var allAvailOrbits:[(Star, Float)] {
        return getAllAvailOrbits(Set<Zone>([Zone.H, Zone.I, Zone.O]))
    }
    
    var allAvailInOuterOrbits:[(Star, Float)] {
        return getAllAvailOrbits(Set<Zone>([Zone.I, Zone.O]))
    }
    
    var allAvailHabOuterOrbits:[(Star, Float)] {
        return getAllAvailOrbits(Set<Zone>([Zone.H, Zone.O]))
    }
    
    func availOrbit(_ zones:Set<Zone>)->(Star, Float)? {
        let allAvail = getAllAvailOrbits(zones)
        let possCount = allAvail.count
        if possCount == 0 {
            return nil
        } else {
            return allAvail[Dice.roll(1, sides: possCount)-1]
        }
    }
    
    var allGGinHabOrbits:[GasGiant] {
        var result: [GasGiant] = []
        for (s, o) in allHabitable {
            if s.getSatellite(o) is GasGiant {
                if DEBUG { print("found a gas giant") }
                let g = s.getSatellite(o) as! GasGiant
                result.append(g)
            }
        }
        return result
    }
    
    var allNavalBaseCandidates:[Planet] {
        var result: [Planet] = []
        for p in allPlanets {
            if p._population >= 3 && p != mainWorld! {
                result.append(p)
                if DEBUG { print("added \(p) to naval base candidates") }
            } else {
                if DEBUG {
                    if p == mainWorld! {
                        print("\(p) is the mainworld, not added to candidates.")
                    }
                }
            }
        }
        return result
    }
    
    var allScoutBaseCandidates:[Planet] {
        var result: [Planet] = []
        for p in allPlanets {
            if p._population >= 2 && p != mainWorld! {
                result.append(p)
                if DEBUG { print("added \(p) to scout base candidates") }
            } else {
                if DEBUG {
                    if p == mainWorld! {
                        print("\(p) is the mainworld, not added to candidates.")
                    }
                }
            }
        }
        return result
    }
    var availHabOuterOrbit:(Star, Float)? {
        return availOrbit(Set<Zone>([Zone.H, Zone.O]))
    }
    
    var availOrbit:(Star, Float)? {
        return availOrbit(Set<Zone>([Zone.H, Zone.O, Zone.I]))
    }
    
    var availHabOrbit:(Star, Float)? {
        return availOrbit(Set<Zone>([Zone.H]))
    }
    
    var availInOutOrbit:(Star, Float)? {
        return availOrbit(Set<Zone>([Zone.I, Zone.O]))
    }
    
    var availGGHabOrbit:GasGiant? {
        let possCount = allGGinHabOrbits.count
        if DEBUG { print("possible GGs count=\(possCount)") }
        if possCount == 0 { return nil } else {
            return allGGinHabOrbits[Dice.roll(1, sides: possCount)-1]
        }
    }
    
    let d : Dice = Dice()
    
    init(newWorld: Planet? = nil) {
        
        var dmRequired = false
        var mainWorldNeedsHabitable = true
        var mainWorldSupplied = false
        var unavailable = [(min: Float, max: Float)]()
        if newWorld != nil {
            mainWorldSupplied = true
            if (newWorld!._atmosphere >= 4 && newWorld!._atmosphere <= 9) || newWorld!._population >= 8 {
                dmRequired = true
            }
            // most of the time the main world must be placed in a habitable zone, except in the following cases.
            if newWorld!._atmosphere <= 1 || newWorld!._atmosphere >= 10 || newWorld!._size == 0 {
                if DEBUG { print("mainworld does not need habitable zone") }
                mainWorldNeedsHabitable = false
            }
            
            mainWorld = newWorld
            
            // move coordinates to star system level.
            coordinateX = mainWorld!.coordinateX
            coordinateY = mainWorld!.coordinateY
            mainWorld!.coordinateY = 0
            mainWorld!.coordinateX = 0
            
            // move gas giant value to star system level.
            gasGiants = mainWorld!.gasGiant
            mainWorld!.gasGiant = false
        }
        
        repeat {
            // empty the stars array.
            stars.removeAll()
            // roll system basic nature
            switch Dice.roll(2) {
            case 2 ..<  8: basicNature = .solo
            case 8 ..< 12: basicNature = .binary
            case 12: basicNature = .trinary
            default: basicNature = .solo
            }
            
            /* determine primary type and size. Keep type and size rolls as they
             are DMs for any companions. */
            
            let typeRoll : Int = d.roll(2)
            let sizeRoll : Int = d.roll(2)
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
                if orbit != -1 { // close orbits don't get their own satellites.
                    stars.append(companion)
                }
                companion.maxOrbitNum = companion.getMaxOrbitNum()
                if companion.maxOrbitNum > Int(orbit / 2) { companion.maxOrbitNum = Int(orbit / 2) }
                if DEBUG { print("companion \(companion.name) maxOrbitNum started at \(companion.maxOrbitNum)") }
                if farCompanion {
                    var farOrbit : Float
                    repeat {
                        (farOrbit,_) = companion.getCompanionOrbit(-4)
                    } while companion.getSatellite(farOrbit) != nil // we need an unassigned orbit
                    // place far companion in orbit
                    let farComp = Star(companion: true, typeRoll: d.roll(2) + typeRoll, sizeRoll: d.roll(2) + sizeRoll, parent: companion)
                    stars.append(farComp)
                    farComp.maxOrbitNum = farComp.getMaxOrbitNum()
                    if farComp.maxOrbitNum > Int(farOrbit / 2) { farComp.maxOrbitNum = Int(farOrbit / 2) }
                    if DEBUG { print("far companion \(farComp.name) maxOrbitNum started at \(farComp.maxOrbitNum)") }
                    companion.addToOrbit(farOrbit, newSatellite: farComp)
                }
                // add the companion to the primary's orbit
                primary.addToOrbit(orbit, newSatellite: companion)
                if DEBUG { print("companion added at orbit \(orbit) on primary") }
            }
            
            // determine maximum orbits for primary
            //        let rolledMaxOrbits = primary.getMaxOrbitNum()
            //        // make sure we have at least the max orbits produced from companion calculations
            //        if rolledMaxOrbits > primary.maxOrbitNum { primary.maxOrbitNum = rolledMaxOrbits }
            primary.maxOrbitNum = primary.getMaxOrbitNum()
            if DEBUG { print("primary \(primary.name) maxOrbitNum started at \(primary.maxOrbitNum)") }
            
            // we need to mark unavailable any orbits that conflict with a companion
            // first we need the companion orbits.
            
            for f in compOrbits {
                // mark orbits between companion and halfway to primary as unavailable
                let compOrb = Int(f)
                if f > 0 { // close orbits don't make sense for this bit.
                    let unavailableOrbits = Int(f / 2) + 1 // numbered no more than half, so 'half' is ok
                    for u in unavailableOrbits..<compOrb {
                        if primary.getSatellite(u) == nil {
                            primary.addToOrbit(Float(u), newSatellite: EmptyOrbit(parent: primary))
                            if DEBUG { print("companion; emptied orbit \(u) on primary") }
                        }
                    }
                    // make sure that no captured planet ends up within the range of the companion star
                    unavailable.append((min: Float(unavailableOrbits), max: Float(compOrb + 1)))
                }
                // mark next-outer orbit as unavailable
                primary.addToOrbit(Float(compOrb + 1), newSatellite: EmptyOrbit(parent: primary))
                if DEBUG { print("companion; emptied orbit \(Float(compOrb + 1)) on primary") }
            }
            if DEBUG { if allAvailHabitable.count == 0 && mainWorldSupplied { print("no habitable zones, regenerating!") } }
        } while (allAvailHabitable.count == 0 && mainWorldSupplied) // try again if there are no habitable orbits at all but one is needed.
        // TODO: also, far companions that can have their own companions - their unavailable orbit calculations are wrong, because they should be based on their own star not on the primary.
        // TODO: if we are doing a continuation, we must have a habitable orbit. I guess if we end up without one at all, we
        //       will just regenerate the stars until we do!
        
        
        // now, for each star in the system, we can determine captured planets and empty orbits.
        
        for star in stars {
            let emptyCapturedDM : Int = ((star.starDetail.t == .B || star.starDetail.t == .A) ? 1 : 0)
            // roll empty orbits
            if d.roll(1) + emptyCapturedDM > 4 {
                switch d.roll(1) + emptyCapturedDM {
                case 1,2:   emptyOrbits = 1
                case 3:     emptyOrbits = 2
                default:    emptyOrbits = 3
                }
            }
            if DEBUG { print("rolled \(emptyOrbits) empty orbits on \(star.name)") }
            // don't try to have more empty orbits than actually exist.
            let usableOrbits = star.availOrbits - (mainWorldNeedsHabitable ? 1 : 0)
            if emptyOrbits > usableOrbits {
                emptyOrbits = usableOrbits
                if DEBUG { print("reduced empty orbits to \(emptyOrbits)") }
            }
            // TODO: It's evidently possible to end up with negative empty orbits and negative usable orbits. Need to trap this.

            if star.maxOrbitNum >= 2 {
                for i in 0 ..< emptyOrbits {
                    var orbit : Float = 0.0
                    repeat {
                        //                    orbit = Float(d.roll(2))
                        orbit = star.getAnyAvailOrbit()
                        if DEBUG {
                            print("rolled empty orbit \(i) candidate \(orbit) on star \(star.name)")
                            if star.getSatellite(orbit) != nil { print("orbit occupied.") }
                            if Int(orbit) > star.maxOrbitNum { print("orbit > max orbit number") }
                            if mainWorldSupplied && star.getZone(orbit) == Zone.H && mainWorldNeedsHabitable { print("habitable and we need it") }
                            if star.availOrbits > 0 { print("avail orbits > 0") } else { print("avail orbits <= 0") }
                        }
                    } while (star.getSatellite(orbit) != nil || Int(orbit) > star.maxOrbitNum || (mainWorldSupplied && star.getZone(orbit) == Zone.H && mainWorldNeedsHabitable)) && star.availOrbits > 0 // this stops our habitable zone (if we have one) being filled with an empty orbit, if this is a system with a supplied world.. we also want to stop if we run out of orbits.
                    star.addToOrbit(orbit, newSatellite: EmptyOrbit(parent:star))
                    if DEBUG { print("emptied orbit \(orbit) on star \(star.name)") }
                }
            } else {
                if DEBUG { print("max orbit number less than two, so impossible to roll one on 2D") }
            }
            // roll captured planets
            if d.roll(1) + emptyCapturedDM > 4 {
                switch d.roll(1) + emptyCapturedDM {
                case 1,2:  capturedPlanets = 1
                case 3,4:  capturedPlanets = 2
                default:   capturedPlanets = 3
                }
            }
            
            if DEBUG { print("rolled \(capturedPlanets) captured planets on \(star.name)") }
            
            //TODO: Captured planets can't possibly be found within the enforced empty range caused by companion stars!
            // However, there's no good reason why they can't be in otherwise empty orbits.... so we need a way to distinguish
            // randomly empty from forced empty. Perhaps we set up an array of minEmpty and maxEmpty orbits for forced empty orbits.
            
            for i in 0 ..< capturedPlanets {
                var orbit : Float
                var avail: Bool = true
                repeat {
                    orbit = Float(d.roll(2)) + Float(d.roll(2) - 7) / 10
                    for (min, max) in unavailable {
                        if orbit >= min && orbit <= max { avail = false }
                    }
                    if DEBUG {
                        print("rolled captured orbit \(i) candidate \(orbit) on star \(star.name)")
                        if star.getSatellite(orbit) != nil { print("orbit not vacant") }
                        if orbit < 0 { print("orbit < 0") }
                        if mainWorldSupplied && star.getZone(orbit) == Zone.H && mainWorldNeedsHabitable { print("habitable and we need it") }
                        for (min, max) in unavailable {
                            if orbit >= min && orbit <= max { print("orbit within unavailable zone") }
                        }
                    }
                } while !avail && star.getSatellite(orbit) != nil || orbit < 0 || (mainWorldSupplied && star.getZone(orbit) == Zone.H && mainWorldNeedsHabitable) // just to make sure we didn't end up with two identical captured orbits... and that we haven't ended up with a negative orbit number, and we don't use a habitable orbit that we might want.
                let p : Planet = Planet(orbit: orbit, starType: star.starDetail.t, zone: star.getZone(Int(orbit))!,planetoid:false, parent: star)
                star.addToOrbit(orbit, newSatellite: p)
                if DEBUG { print("captured planet in orbit \(orbit) on star \(star.name)") }
            }
        }
        
        // get all of the zones we might need to use on a per-system basis.
        var allOrbits: [(Star, Float)] = []
        var allHabitable: [(Star, Float)] = []
        var allHabOuter: [(Star, Float)] = []
        for star in stars {
            let s = star.getAvailOrbits(Set<Zone>([Zone.H, Zone.I, Zone.O]),createIfNone: false)
            let s1 = star.getAvailOrbits(Set<Zone>([Zone.H]),createIfNone: false)
            let s2 = star.getAvailOrbits(Set<Zone>([Zone.H, Zone.O]),createIfNone: false)
            for i in s {
                allOrbits.append((star, i))
                if DEBUG { print("added \(star.name), orbit \(i) to all list") }
            }
            for i in s1 {
                allHabitable.append((star, i))
                if DEBUG { print("added \(star.name), orbit \(i) to habitable list") }
            }
            for i in s2 {
                allHabOuter.append((star, i))
                if DEBUG { print("added \(star.name), orbit \(i) to hab/outer list") }
            }
        }
        if DEBUG {
            print("All orbits count=\(allOrbits.count)")
            print("Hab orbits count=\(allHabitable.count)")
            print("HabOuter orbits count=\(allHabOuter.count)")
        }
        
        // roll gas giants - unless we are continuing from an existing planet, in which case we were told if GG's are here.
        if !mainWorldSupplied {
            if d.roll(2) <= 9 { gasGiants = true } else { gasGiants = false }
        }
        
        // need to count available non-empty orbits in habitable and outer zones.
        var avail = allHabOuter.count
        if DEBUG { print("gg: \(avail) available habitable and outer orbits") }
        /* - TODO: if we need to add an orbit for a gas giant, we need to make sure it's an OUTER orbit.
         I guess we need to populate orbits between the current maximum number and the new outer orbit with empty orbits.
         The rules say (potentially confusingly):
         1. "The number present may not exceed the number of available and non-empty orbits in the habitable and outer
         zones in the system" but then says
         2. "if the table calls for a gas giant and there is no orbit available for it, create an orbit in the outer
         zone for it."
         I'm interpreting this as meaning if the table indicates the presence of a gas giant, then there must be a minimum
         of one, and if there is no suitable zone for that one GG, create an outer zone to hold it. If there are multiple stars,
         I'll just put it on the primary. Although it would probably be fair to put it on any of them really.
         */
        if gasGiants {
            switch d.roll(2) {
            case  2 ..<  4: gasGiantCount = 1
            case  4 ..<  6: gasGiantCount = 2
            case  6 ..<  8: gasGiantCount = 3
            case  8 ..< 11: gasGiantCount = 4
            case 11,    12: gasGiantCount = 5
            default: break
            }
            
            if DEBUG { print("rolled \(gasGiantCount) gas giants") }
            
            if gasGiantCount > avail {
                gasGiantCount = avail
                if DEBUG { print("reduced gas giant count to \(gasGiantCount)") }
            }
            avail -= gasGiantCount
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
            if DEBUG { print("rolled \(planetoidBelts) planetoid belts") }
            
        }
        
        if gasGiants && gasGiantCount == 0 {
            // pick a random star out of what we have
            let ggStar = stars[Dice.roll(1, sides: stars.count)-1]
            let orbit = ggStar.createOuterZone()
            let gg = GasGiant(size: d.roll(1) <= 3 ? GasGiantEnum.Large : GasGiantEnum.Small, parent: ggStar)
            ggStar.addToOrbit(orbit, newSatellite: gg)
            if DEBUG { print("added only gas giant \(gg.name) to new orbit \(orbit) on \(ggStar.name)") }
        } else {
            for _ in 0..<gasGiantCount {
                if let (star, orbit) = availHabOuterOrbit {
                    let gg = GasGiant(size: d.roll(1) <= 3 ? GasGiantEnum.Large : GasGiantEnum.Small, parent: star)
                    star.addToOrbit(orbit, newSatellite: gg)
                    if DEBUG { print("added gas giant \(gg.name) to orbit \(orbit) on \(star.name)") }
                } else {
                    if DEBUG { print("got no place for gg") }
                }
                
            }
        }
        
        for _ in 0..<planetoidBelts {
            //            if let orbit = newWorld == nil ? star.getAvailOrbit() : star.getAvailInOutOrbit() {
            if let (star, orbit) = !mainWorldSupplied ? availOrbit : availInOutOrbit {
                let pb = Planet(orbit: orbit, starType: star.starDetail.t, zone: star.getZone(orbit)!, planetoid: true, parent: star)
                star.addToOrbit(orbit, newSatellite: pb)
                if DEBUG { print("added planetoid to \(orbit) on \(star.name)") }
            } else {
                if DEBUG { print("Got no place for planetoid") }
            }
            //            }
        }
        
        // we were supplied a world, so we need to place it.
        if mainWorldSupplied && !mainWorldPlaced {
            if let (star, mwOrbit) = mainWorldNeedsHabitable ? availHabOrbit : availOrbit {
                star.addToOrbit(mwOrbit, newSatellite: mainWorld!)
                mainWorld!.parent = star // we need to set the parent otherwise it goes pear-shaped.
                mainWorldPlaced = true // don't place the mainworld on each star...
                if DEBUG { print("placed main world as satellite of \(star.name) in orbit \(mwOrbit)") }
            } else {
                if let gasGiant = availGGHabOrbit {
                    gasGiant.addToOrbit(gasGiant.getMoonOrbit(0), newSatellite: mainWorld!)
                    mainWorld!.parent = gasGiant // we need to set the parent otherwise it goes pear-shaped.
                    mainWorldPlaced = true // don't place the mainworld on each star...
                    if DEBUG { print("placed main world as satellite of gas giant \(gasGiant.name)") }
                    
                } else {
                    if DEBUG { print("didn't find an available habitable orbit") }
                }
            }
        }
        
        for star in stars {
            // now create planets for all remaining orbits
            for orbit in star.getAvailOrbits(Set<Zone>([Zone.H, Zone.I, Zone.O])) {
                let planet = Planet(orbit: orbit, starType: star.starDetail.t, zone: star.getZone(orbit)!, planetoid: false, parent: star)
                if let mw = mainWorld {
                    planet.checkPopulation(mw._population)
                }
                star.addToOrbit(orbit, newSatellite: planet)
                if DEBUG { print("Added planet to orbit \(orbit) on star \(star.name)") }
            }
            
            // now create satellites for all relevant planets/gas giants
            for (orbitIdx, satellite) in star.satellites.orbits {
                var moonCount = 0
                let orbit = Float(orbitIdx) / 10
                if satellite is Planet {
                    if (satellite as! Planet)._size > 0 {
                        moonCount = d.roll() - 3
                    }
                } else if satellite is GasGiant {
                    let gasGiant = satellite as! GasGiant
                    if gasGiant.size == GasGiantEnum.Small {
                        moonCount = d.roll(2) - 4
                    } else {
                        moonCount = d.roll(2)
                    }
                }
                if moonCount < 0 {moonCount = 0}
                var dm = 0
                var ringCount = 0 // we can't have more than three because there are only three ring orbits.
                for _ in 0..<moonCount {
                    var moon : Planet
                    repeat {
                        moon = Planet(orbit: orbit, starType: star.starDetail.t, zone: star.getZone(orbit)!, planetoid: false, parent: satellite)
                        if moon.size == "R" { ringCount += 1 }
                    } while ringCount > 3 && moon.size == "R"
                    if let mw = mainWorld {
                        moon.checkPopulation(mw._population)
                    }
                    
                    var sOrbit:Float = 0
                    if moon.size == "R" { // rings are handled differently
                        //TODO: System can't deal with more than three generated rings.
                        // the rules don't cater for the possibility that orbits 1,2 and 3 are occupied already. I have to!
                        if satellite.getSatellite(1) == nil || satellite.getSatellite(2) == nil || satellite.getSatellite(3) == nil {
                            repeat {
                                switch d.roll() {
                                case 1...3: sOrbit = 1
                                case 4, 5:  sOrbit = 2
                                default:    sOrbit = 3
                                }
                            } while satellite.getSatellite(sOrbit) != nil
                        }
                    } else {
                        sOrbit = satellite.getMoonOrbit(dm)
                    }
                    satellite.addToOrbit(Float(sOrbit), newSatellite: moon)
                    dm += 1
                }
            }
        }
        if !mainWorldSupplied {
            // now we need to find the main world = highest population
            mainWorld = primary.getMainWorld()
        }
        if let mw = mainWorld {
            if !mainWorldSupplied {
                mw.rollGovernment()
                mw.rollLawLevel()
                mw.rollStarport()
                mw.rollTechLevel()
                mw.setTradeClassifications()
                mw.rollNavalBase()
                mw.rollScoutBase()
            }

            // now we determine stats for all other planets and satellites
            if DEBUG { print("Primary contains \(primary.getPlanets().count) planets.") }

            for p in primary.getPlanets() {
                if p != mw { // don't mess with the mainworld...
                    if p._size != -2 { // Rings don't get satellite attribs
                        p.setSatelliteAttribs(mw)
                    } else {
                        p.starport = "Y" // set rings with no spaceport
                    }
                    switch p._size {
                    case -2: p.name = "Ring System"
                    case 0: p.name = "Planetoid Belt"
                    default: p.name = Name.init(maxLength: p.maxNameLength).description
                    }
                    // if the planet has no population, clearly it has no trade.
                    if p._population > 0 { p.setTradeClassifications() }
                }
                if mw.name.isEmpty {
                    mw.name = Name.init(maxLength: p.maxNameLength).description
                }
            }
            if mw.bases.contains(.S) { // can't have additional bases if we don't have one on the main world.
            let additionalScoutBases = Dice.roll() - 4
            if additionalScoutBases > 0 {
                let c = allScoutBaseCandidates
                if c.count > 0 { // no point in continuing if there are no candidates.
                    for _ in 0..<additionalScoutBases {
                        let p = c[Dice.roll(1, sides:c.count)-1]
                        p.bases.insert(.S)
                    }
                }
            }
            }
            if mw.bases.contains(.N) { // can't have additional bases if we don't have one on the main world.
            let additionalNavalBases = Dice.roll() - 3
            if additionalNavalBases > 0 {
                let c = allNavalBaseCandidates
                if c.count > 0 { // no point in continuing if there are no candidates.
                    for _ in 0..<additionalNavalBases {
                        let p = c[Dice.roll(1, sides:c.count)-1]
                        p.bases.insert(.N)
                    }
                }
            }
            }
        }
    }
    
    var description:String {
        var result: String = ""
        if let m = mainWorld { result += "\(m)\n\(m.name) " } else { result += "This " }
        result += "is a \(basicNature) Star System"
        if basicNature.rawValue != stars.count - 1 {
            result += ", but has \(stars.count) stars"
        }
        result += ".\n"
        //        result += "The primary star is \(primary)\n"
        for star in stars {
            result += String(repeating: "-", count: 70)
            result += "\n"
            if star.parent == nil {
                result += "Primary ".padding(10)
            } else {
                result += "Companion ".padding(10)
            }
//            if let p = star.parent { if let n = p.name { result += "(p=\(n))" } }
            result += "\t\t\(star)\n"
            result += String(repeating: "=", count: 70)
            result += "\n"
        }
        //        result += "Primary \(primary)\n"
        //        result += "There " + capturedPlanets.strord("captured planet") + ".\n"
        //        result += "There " + emptyOrbits.strord("empty orbit") + ".\n"
        //        result += "There " + gasGiantCount.strord("gas giant") + ".\n"
        //        result += "There " + planetoidBelts.strord("planetoid belt") + ".\n"
        //        result += "The main world is \(mainWorld!.uwp).\n"
        return result
    }
    
    var json: String {
        var result: String = "{\n"
        result += primary.json
        result += "}\n"
        return result
    }
}

