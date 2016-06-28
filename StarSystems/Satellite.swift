//
//  Satellite.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation

extension Int {
    func strord(things: String)->String {
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
//struct Orbit: CustomStringConvertible {
//    var satellite: Satellite?
//    var zone: Zone?
//    var description: String {
//        var result: String = "("
//        if let s = satellite { result += "\(s)" } else { result += "nil" }
//        result += ", "
//        if let z = zone { result += "\(z)" } else { result += "nil" }
//        result += ")"
//        return result
//    }
//}

class Satellites/* : CustomStringConvertible */{
    // orbits are stored as orbit * 10 to accommodate for captured orbits while still being indexable.
    var orbits: [Int:Satellite] = [:]
//    var description: String {
//        var result: String = ""
//        result += "There "
//        result += (orbits.count == 1 ? "is" : "are")
//        result += " \(orbits.count) orbit"
//        result += (orbits.count != 1 ? "s" : "")
//        result += ":\n"
//        let sortedArray = orbits.sort({$0.0 < $1.0})
//
//        for (i,o) in sortedArray {
//            result += "orbit "
//            if i != 0 {
//                result += "\(Float(i) / 10)"
//            } else {
//                result += "Close"
//            }
//            result += " = \(o)\n"
//        }
//        return result
//    }

    func addSatelliteAtOrbit(orbit: Float, newSatellite: Satellite) {
        let intOrbit:Int = Int(orbit * 10)
        orbits[intOrbit] = newSatellite
    }
    func getSatelliteAtOrbit(orbit: Float) -> Satellite? {
        let intOrbit:Int = Int(orbit * 10)
        return orbits[intOrbit]
    }
}

class Satellite {
    var satellites = Satellites()
    var parent: Satellite? // everything except the primary will have a parent

    var satDesc: String {
        var result: String = ""
        let pad = String(count: depth * 2, repeatedValue: Character("-"))

//        result += "\(pad)There "
//        var satType = ""
//        if self is Star { satType = "satellite" }
//        else { satType = "moon" }
//        result += satellites.orbits.count.strord(satType)
//        result += (satellites.orbits.count == 1 ? "is" : "are")
//        result += " \(satellites.orbits.count) orbit"
//        result += (satellites.orbits.count != 1 ? "s" : "")
//        result += ":\n"
        let sortedArray = satellites.orbits.sort({$0.0 < $1.0})
        
        for (i,o) in sortedArray {
            result += "\(pad)orbit "
            if i != 0 {
                result += String(format:"%5.1f", arguments:[Float(i) / 10])
            } else {
                result += "Close"
            }
            result += " (\(o.zone!))".padding(14)
            result += " = \(o)\n"
        }
        return result
    }

    init(parent:Satellite? = nil) {
        self.parent = parent
    }
    
    func addToOrbit(orbit: Float, newSatellite: Satellite) {
//        newSatellite.parent = self
        satellites.addSatelliteAtOrbit(orbit, newSatellite: newSatellite)
    }
    
    func getSatellite(orbit: Float) -> Satellite? {
        return satellites.getSatelliteAtOrbit(orbit)
    }
    
    func getSatellite(orbit: Int) -> Satellite? {
        return getSatellite(Float(orbit))
    }
    
//    func getOrbit(satellite: Satellite)->Float? {
//        var orbit: Float?
//        satellites.or
//    }

    func getZone(orbit: Float) -> Zone? {
        if self is Star {
            let s = self as! Star
            if let zones:[Zone] = tableOfZones[s] {
                let i = Int(round(orbit)) // decimal zones go to nearest whole zone
                if i >= zones.count {
                    return Zone.O
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
            }
            result.appendContentsOf(s.getPlanets())
        }
        return result
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
                    maxPlanets.planets.appendContentsOf(pa)
                    maxPlanets.pop = p
                } else if p == maxPlanets.pop {
                    maxPlanets.planets.appendContentsOf(pa)
                }
            }
        }
        return maxPlanets
    }
    
    func getZone(orbit: Int) -> Zone? {
        return getZone(Float(orbit))
    }
    
//    func getDepth()->Int {
//        if self is Star && self.parent == nil {
//            return 0
//        } else {
//            return (parent?.getDepth())! + 1
//        }
//    }
    var depth: Int {
        if self is Star && self.parent == nil {
            return 0
        } else {
            return (parent?.depth)! + 1
        }
    }
}


class EmptyOrbit: Satellite, CustomStringConvertible {
    var description: String {
        let pad = String(count: depth, repeatedValue: Character(" "))
        return "\(pad)Empty orbit"
    }
    // empty orbits only have parents that are stars.
    init(parent: Star) {
        super.init(parent:parent)
    }
}

enum GasGiantEnum: String, CustomStringConvertible {
    case Small
    case Large
    var description:String {
        return self.rawValue + " Gas Giant"
    }
}
class GasGiant : Satellite, CustomStringConvertible {
    var size:GasGiantEnum
    var description: String {
        let pad = String(count: depth, repeatedValue: Character(" "))
        return "\(pad)\(size)\n\(satDesc)"
    }
    // gas giants only have parents that are stars.
    init(size:GasGiantEnum = .Small, parent:Star) {
        self.size = size
        super.init(parent: parent)
    }
}

