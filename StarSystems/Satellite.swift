//
//  Satellite.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation

extension Int {
    func strord(_ things: String)->String {
        var result = ""
        if self == 1 {
            result += "is "
        } else {
            result += "are "
        }
        result += String(self)
        result += " "
        result += things
        if self != 1 {
            result += "s"
        }
        return result
    }
    
    
}

enum SatelliteError:Error {
    case orbitInUse
}

class Satellites/* : CustomStringConvertible */{
    // orbits are stored as orbit * 10 to accommodate for captured orbits while still being efficiently indexable.
    // while it's ambiguous, I treat Close and orbit 0 as two distinct positions. Close is orbit -1.
    var orbits: [Int:Satellite] = [:]
    
    func addSatelliteAtOrbit(_ orbit: Float, newSatellite: Satellite) throws {
        let intOrbit:Int = Int(orbit * 10)
        guard orbits[intOrbit] == nil else { throw SatelliteError.orbitInUse }
        orbits[intOrbit] = newSatellite
    }
    func getSatelliteAtOrbit(_ orbit: Float) -> Satellite? {
        let intOrbit:Int = Int(orbit * 10)
        return orbits[intOrbit]
    }
}

class Satellite {
    var satellites = Satellites()
    var parent: Satellite? // everything except the primary will have a parent
    var name: String
    let maxNameLength = 15 // this lets names fit on the map!
    
    var satDesc: String {
        var result: String = ""
        let pad = String(repeating: "\t", count: solarDepth)
        let rpad = String(repeating: "\t", count: 2 - solarDepth)
        
        let sortedArray = satellites.orbits.sorted(by: {$0.0 < $1.0})
        
        for (i,o) in sortedArray {
            result += "\n\(pad)"
            if i != -10 {
                var orbitstr = String(format:"%5.1f", arguments:[Float(i) / 10])
                if orbitstr[orbitstr.characters.index(orbitstr.endIndex, offsetBy: -2)...orbitstr.characters.index(orbitstr.endIndex, offsetBy: -1)] == ".0" {
                    orbitstr = orbitstr[orbitstr.startIndex...orbitstr.characters.index(orbitstr.endIndex, offsetBy: -3)] + "  "
                }
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
    
    var json: String { return "" }
    
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
    init(parent:Satellite? = nil) {
        self.parent = parent
        self.name = ""
    }
    
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
    
    func getSatellite(_ orbit: Float) -> Satellite? {
        return satellites.getSatelliteAtOrbit(orbit)
    }
    
    func getSatellite(_ orbit: Int) -> Satellite? {
        return getSatellite(Float(orbit))
    }
    
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
    
    var orbit: Float {
        var o:Float = 0.0
        if parent == nil { o = 0.0 } // must be the primary star.
        var p: Satellite? = self
        // get up to the parent star
        repeat {
            p = p!.parent
        } while !(p is Star) && p != nil
        for (k, v) in (p?.satellites.orbits)! {
            if v === self { o = Float(k) / 10.0 }
        }
        return o
    }
    
    var zone: Zone? {
        var z: Zone?
        if parent is Star { z = parent?.getZone(orbit) }
        else {
            z = parent?.zone
        }
        return z
    }
    
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
    
    func getMaxPop()->(planets:[Planet?], pop: Int) {
        var maxPlanets: (planets:[Planet?], pop: Int)
        maxPlanets.pop = 0
        maxPlanets.planets = []
        for (_,s) in satellites.orbits {
            if s is Planet {
                let p = s as! Planet
                if p.population > maxPlanets.pop {
                    maxPlanets.planets.removeAll()
                    maxPlanets.planets.append(p)
                    maxPlanets.pop = p.population
                } else if p.population == maxPlanets.pop {
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
    
    func getZone(_ orbit: Int) -> Zone? {
        return getZone(Float(orbit))
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
    var type: String {
        if self is Star { return "Star" }
        if self is GasGiant { return "GasGiant" }
        if self is Planet { return "Planet" }
        if self is EmptyOrbit { return "EmptyOrbit" }
        return "Unknown Satellite"
    }
}

