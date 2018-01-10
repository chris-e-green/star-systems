//
//  Satellite.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation

/// Possible errors when creating a satellite
enum SatelliteError:Error {
    case orbitInUse
}

/**
 Represents a collection of satellites (planets, moons, companion stars)
 
 - note:
 Orbits are stored as orbit * 10 to accommodate for captured
 orbits while still being efficiently indexable.
 While it's ambiguous in the written rules, I treat 'Close' and
 'Orbit 0' as two distinct orbits. Close is designated orbit -1.
 */
class Satellites {
    
    /// Stores the satellite in each of the orbits (the orbit is stored as an Int, 10 times the actual orbit number (e.g. orbit 3.1 is stored as 31)
    var orbits: [Int:Satellite] = [:]
    
    /**
     Add a Satellite at the given orbit.
     - parameters:
     - orbit:
     The orbit at which to add the new satellite.
     - newSatellite:
     The satellite to be added.
     */
    func addSatelliteAtOrbit(_ orbit: Float, newSatellite: Satellite) throws {
        let intOrbit:Int = Int(orbit * 10)
        guard orbits[intOrbit] == nil else { throw SatelliteError.orbitInUse }
        orbits[intOrbit] = newSatellite
    }
    /**
     Retrieve the Satellite, if any, that is at the given orbit.
     - parameters:
     - orbit:
     The orbit in question.
     */
    func getSatelliteAtOrbit(_ orbit: Float) -> Satellite? {
        let intOrbit:Int = Int(orbit * 10)
        return orbits[intOrbit]
    }
    
    var count: Int {
        return orbits.count
    }
    var enumerated: EnumeratedSequence<[Int: Satellite]> {
        return orbits.enumerated()
    }
    func byIndex(_ index: Int) -> Satellite? {
        let s = Array(orbits.keys.sorted())
        let r = s[index]
        return orbits[r]
    }
}

/**
 Represents a generic satellite (companion star, planet, moon).
 */
class Satellite {
    /// The satellites orbiting this satellite.
    var satellites = Satellites()
    /// The parent satellite of this satellite. Everything except the primary will have a parent.
    var parent: Satellite?
    /// The name of this satellite.
    var name: String
    /// The maximum name length for a satellite.
    let maxNameLength = 15 // this lets names fit on the map!

    /// A textual description of this Satellite, including any satellites
    /// that orbit it.
    var satDesc: String {
        var result: String = ""
        let pad = String(repeating: "\t", count: solarDepth)
        let rpad = String(repeating: "\t", count: 2 - solarDepth)
        
        let sortedArray = satellites.orbits.sorted(by: {$0.0 < $1.0})
        
        for (i,o) in sortedArray {
            result += "\n\(pad)"
            if i != -10 {
                let orbitstr = (Float(i) / 10)~
//                var orbitstr = String(format:"%5.1f", arguments:[Float(i) / 10])
//                if orbitstr[orbitstr.index(orbitstr.endIndex, offsetBy: -2)...orbitstr.index(orbitstr.endIndex, offsetBy: -1)] == ".0" {
//                    orbitstr = orbitstr[orbitstr.startIndex...orbitstr.index(orbitstr.endIndex, offsetBy: -3)] + "  "
//                }
                if o.zone == .H { result += "*" } else { result += " " }
                result += orbitstr
            } else {
                result += "Close".padding(10)
            }
            //            result += " (\(o.zone!))".padding(14)
            result += rpad
            if o is Star {
                let s = o as! Star
                result += "\(s.starDesc)"
            } else {
                result += "\(o)"
            }
        }
        return result
    }
    /// This is expected to be overridden by descendants of this class.
    var json: String { return "" }
    
    /// A JSON string representation of the satellite.
    var satJSON: String {
        var result: String = ""
        let sorted = satellites.orbits.sorted(by: {$0.0 < $1.0})
        
        for (i, o) in sorted {
            //            result += "\t\"\(jsonLabels.sat)\": {\n"
            result += "\t{\n"
            result += "\t\t\"\(jsonLabels.orbit)\": \(Float(i) / 10),\n"
            //            result += "\"\(jsonLabels.name)\": \"\(name)\",\n"
            //            result += "\"\(jsonLabels.sat)\": {\n"
            if o is Star {
                result += "\t\t\(o.json)\n"
            } else {
                result += "\t\t\(o.json)\n"
                result += "\(o.satJSON)"
            }
            result += "\t},\n"
            //            result += "}\n"
        }
        return result
    }
    /// Initializer with optional parent satellite.
    init(parent:Satellite? = nil) {
        self.parent = parent
        self.name = ""
    }
    
    /**
     Attempts to add a new satellite to the given orbit of this
     satellite. If the orbit is occupied, currently just logs the
     inability and continues.
     - parameters:
     - orbit:
     The orbit at which to add the satellite.
     - newSatellite:
     The satellite to add.
     */
    func addToOrbit(_ orbit: Float, newSatellite: Satellite)  {
        do {
            try satellites.addSatelliteAtOrbit(orbit, newSatellite: newSatellite)
            //            if self is Star {
            //                let s = self as! Star
            //                // if the new satellite is a star, don't change the maximum orbit number.
            //                if !(newSatellite is Star) {
            //                    if s.maxOrbitNum < Int(orbit) {
            //                        s.maxOrbitNum = Int(orbit + 1)
            //                        if DEBUG { print("Increased max orbits to \(s.maxOrbitNum) on \(s.name!)") }
            //                    }
            //                }
            //            }
        } catch SatelliteError.orbitInUse {
            if (getSatellite(orbit) is EmptyOrbit || getSatellite(orbit) is Star) && newSatellite is EmptyOrbit {
                if DEBUG { print("Tried to add an empty orbit and collided with another companion") }
            } else {
                print("EXCEPTION: Orbit \(orbit) in use, can't add \(newSatellite)!")
            }
        } catch {
            print("EXCEPTION: Something unexpected happened, \(error)")
        }
    }
    
    /// Returns the satellite (if any) at the given floating-point orbit.
    func getSatellite(_ orbit: Float) -> Satellite? {
        return satellites.getSatelliteAtOrbit(orbit)
    }
    
    /// Returns the satellite (if any) at the given integer (internal) orbit.
    func getSatellite(_ orbit: Int) -> Satellite? {
        return getSatellite(Float(orbit))
    }
    
    /**
     Returns the Zone in which the supplied orbit is contained. If this is
     a request for the Zone of an orbit of a non-star, return the Zone for
     the parent instead.
     - parameters:
     - orbit:
     The orbit to check.
     - returns:
     The Zone in which *orbit* is contained.
     */
    func getZone(_ orbit: Float) -> Zone? {
        if self is Star {
            let s = self as! Star
            if let zones:[Zone] = tableOfZones[s.starDetail] {
                let i = Int(round(orbit)) // decimal zones go to nearest whole zone
                if i >= zones.count {
                    return Zone.O
                } else if i == -1 { // close orbit
                    return Zone.C
                } else {
                    return zones[i]
                }
            }
        } else if parent != nil {
            return parent?.getZone(orbit)
        }
        return nil
    }
    
    /// Returns the zone at this (integer/internal) orbit.
    func getZone(_ orbit: Int) -> Zone? {
        return getZone(Float(orbit))
    }
    
    
    /// The orbit of this satellite relative to the parent star.
    var stellarOrbit: Float {
        var result:Float = 0.0
        if parent == nil { result = 0.0 } // must be the primary star - no point in going further.
        else {
            var p: Satellite? = self
            // get up to the parent star
            repeat {
                p = p!.parent
            } while !(p is Star) && p != nil
            for (orbitInt, orbitingObject) in (p?.satellites.orbits)! {
                if orbitingObject === self { result = Float(orbitInt) / 10.0 }
            }
        }
        return result
    }
    
    /// The orbit of this satellite relative to its parent (as a string).
    var orbit: String {
        var result: String = ""
        if parent == nil { result = "Primary" }
        else {
            for (orbitInt, orbitingObject) in (parent?.satellites.orbits)! {
                if orbitingObject === self {
                    if orbitInt == -10 { result = "Close" }
                    else { result = (Float(orbitInt) / 10.0)~ }
                }
            }
        }
        return result
        
    }
    /// The Zone of this satellite, relative to its parent star.
    var zone: Zone? {
        var z: Zone?
        if parent is Star { z = parent?.getZone(stellarOrbit) }
        else {
            z = parent?.zone
        }
        return z
    }
    
    /// Returns an array of the planets orbiting this Satellite.
    func getPlanets()->[Planet] {
        var result: [Planet] = []
        for (_,s) in satellites.orbits {
            if s is Planet {
                result.append(s as! Planet)
            } else { if DEBUG { print("\(s.name) is not a planet") } }
            result.append(contentsOf: s.getPlanets())
        }
        return result
    }
    
    /// Rolls for a valid moon orbit around this satellite. Keeps
    /// trying until it finds an empty orbit.
    func getMoonOrbit(_ dm: Int) -> Float {
        var orbit : Int
        repeat {
            switch Dice.roll(2) + dm {
            case 2...7: // close
                orbit = Dice.roll(2) + 1
            case 8...11: // far
                orbit = Dice.roll(2) * 5 + 5
            default:
                if self is GasGiant {
                    orbit = Dice.roll(2) * 25 + 25
                } else {
                    orbit = Dice.roll(2) * 5 + 5
                }
            }
        } while getSatellite(orbit) != nil
        return Float(orbit)
    }
    
    /// Return a tuple containing the planet(s) that have the highest
    /// population orbiting this satellite.
    func getMaxPop()->(planets:[Planet?], pop: Int) {
        var maxPlanets: (planets:[Planet?], pop: Int)
        maxPlanets.pop = 0
        maxPlanets.planets = []
        for (_,s) in satellites.orbits {
            if s is Planet {
                let p = s as! Planet
                if p._population > maxPlanets.pop {
                    maxPlanets.planets.removeAll()
                    maxPlanets.planets.append(p)
                    maxPlanets.pop = p._population
                } else if p._population == maxPlanets.pop {
                    maxPlanets.planets.append(p)
                }
            }
            
            if s.satellites.orbits.count > 0 {
                let (pa, p) = s.getMaxPop()
                if p > maxPlanets.pop {
                    maxPlanets.planets.removeAll()
                    maxPlanets.planets.append(contentsOf: pa)
                    maxPlanets.pop = p
                } else if p == maxPlanets.pop {
                    maxPlanets.planets.append(contentsOf: pa)
                }
            }
        }
        return maxPlanets
    }
    
    /// Orbital depth of satellite from primary star
    var depth: Int {
        if self is Star && self.parent == nil {
            return 0
        } else {
            return (parent?.depth)! + 1
        }
    }
    
    /// Orbital depth of satellite from nearest star
    var solarDepth: Int {
        if self is Star {
            return 0
        } else {
            return (parent?.solarDepth)! + 1
        }
    }
    
    /// A string describing the type of this satellite
    var type: String {
        if self is Star { return "Star" }
        if self is GasGiant { return "Gas Giant" }
        if self is Planet { return "Planet" }
        if self is EmptyOrbit { return "Empty Orbit" }
        return "Unknown Satellite"
    }
    var nameAndType: String {
        return "\(type.lowercased()) \(name)"
    }
}

