//
//  Satellite.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//
//  The Traveller game in all forms is owned by Far Future Enterprises.
//  Copyright 1977 - 2008 Far Future Enterprises.
//

import Foundation

/// Possible errors when creating a satellite
enum SatelliteError: Error {
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

    /// Stores the satellite in each of the orbits (the orbit is stored as an
    /// Int, 10 times the actual orbit number (e.g. orbit 3.1 is stored as 31)
    var orbits: [Int: Satellite] = [:]

    /**
     Add a Satellite at the given orbit.
     
     - parameters:
     
        - orbit:
     The orbit at which to add the new satellite.
        - newSatellite:
     The satellite to be added.
     */
    func addSatelliteAtOrbit(_ orbit: Float, newSatellite: Satellite) throws {
        let intOrbit: Int = Int(orbit * 10)
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
        let intOrbit: Int = Int(orbit * 10)
        return orbits[intOrbit]
    }

    var count: Int {
        orbits.count
    }

    var enumerated: EnumeratedSequence<[Int: Satellite]> {
        orbits.enumerated()
    }

    func byIndex(_ index: Int) -> Satellite? {
        let sortedOrbits = Array(orbits.keys.sorted())
        let sortedIndex = sortedOrbits[index]
        return orbits[sortedIndex]
    }
}

/**
 Represents a generic satellite (companion star, planet, moon).
 */
class Satellite {
    /// The satellites orbiting this satellite.
    var satellites = Satellites()
    /// The parent satellite of this satellite. Everything except the primary
    /// will have a parent.
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

        let sortedOrbits = satellites.orbits.sorted(by: {$0.0 < $1.0})

        for (orbitIndex, orbitEntity) in sortedOrbits {
            result += "\n\(pad)"
            if orbitIndex != -10 {
                let orbitstr = (Float(orbitIndex) / 10)~
                if orbitEntity.zone == .H { result += "*" } else { result += " " }
                result += orbitstr
            } else {
                result += "Close".padding(10)
            }
            result += rpad
            if let star = orbitEntity as? Star {
                result += "\(star.starDesc)"
            } else {
                result += "\(orbitEntity)"
            }
        }
        return result
    }
    /// This is expected to be overridden by descendants of this class.
    var json: String {
        ""
    }

    /// A JSON string representation of the satellite.
    var satJSON: String {
        var result: String = ""
        let sortedOrbits = satellites.orbits.sorted(by: {$0.0 < $1.0})

        for (orbitIndex, orbit) in sortedOrbits {
            result += "\t{\n"
            result += "\t\t\"\(JsonLabels.orbit)\": \(Float(orbitIndex) / 10),\n"
            if orbit is Star {
                result += "\t\t\(orbit.json)\n"
            } else {
                result += "\t\t\(orbit.json)\n"
                result += "\(orbit.satJSON)"
            }
            result += "\t},\n"
        }
        return result
    }
    /// Initializer with optional parent satellite.
    init(parent: Satellite? = nil) {
        self.parent = parent
        name = ""
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
    func addToOrbit(_ orbit: Float, newSatellite: Satellite) {
        do {
            try satellites.addSatelliteAtOrbit(orbit, newSatellite: newSatellite)
        } catch SatelliteError.orbitInUse {
            if (getSatellite(orbit) is EmptyOrbit ||
                getSatellite(orbit) is Star) &&
                newSatellite is EmptyOrbit {
                if DEBUG {
                    print("Tried to add an empty orbit and collided with another companion")
                }
            } else {
                print("EXCEPTION: Orbit \(orbit) in use, can't add \(newSatellite)!")
            }
        } catch {
            print("EXCEPTION: Something unexpected happened, \(error)")
        }
    }

    /// Returns the satellite (if any) at the given floating-point orbit.
    func getSatellite(_ orbit: Float) -> Satellite? {
        satellites.getSatelliteAtOrbit(orbit)
    }

    /// Returns the satellite (if any) at the given integer (internal) orbit.
    func getSatellite(_ orbit: Int) -> Satellite? {
        getSatellite(Float(orbit))
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
        if let star = self as? Star {
            if let zones: [Zone] = tableOfZones[star.starDetail] {
                let orbitInt = Int(round(orbit)) // zones round to nearest whole zone
                if orbitInt >= zones.count {
                    return Zone.O
                } else if orbitInt == -1 { // close orbit
                    return Zone.C
                } else {
                    return zones[orbitInt]
                }
            }
        } else if parent != nil {
            return parent?.getZone(orbit)
        }
        return nil
    }

    /// Returns the zone at this (integer/internal) orbit.
    func getZone(_ orbit: Int) -> Zone? {
        getZone(Float(orbit))
    }

    /// The orbit of this satellite relative to the parent star.
    var stellarOrbit: Float {
        var result: Float = 0.0
        if parent == nil {
            // must be the primary star - no point in going further.
            result = 0.0
        } else {
            var satellite: Satellite? = self
            // get up to the parent star
            repeat {
                satellite = satellite!.parent
            } while !(satellite is Star) && satellite != nil
            for (orbitInt, orbitingObject) in (satellite?.satellites.orbits)! where orbitingObject === self {
                result = Float(orbitInt) / 10.0
            }
        }
        return result
    }

    /// The orbit of this satellite relative to its parent (as a string).
    var orbit: String {
        var result: String = ""
        if parent == nil { result = "Primary" } else {
            for (orbitInt, orbitingObject) in (parent?.satellites.orbits)! where orbitingObject === self {
                if orbitInt == -10 { result = "Close" } else { result = (Float(orbitInt) / 10.0)~ }
            }
        }
        return result

    }
    /// The Zone of this satellite, relative to its parent star.
    var zone: Zone? {
        var finalZone: Zone?
        if parent is Star { finalZone = parent?.getZone(stellarOrbit) } else {
            finalZone = parent?.zone
        }
        return finalZone
    }

    /// Returns an array of the planets orbiting this Satellite.
    func getPlanets() -> [Planet] {
        var result: [Planet] = []
        for (_, satellite) in satellites.orbits {
            if let planet = satellite as? Planet {
                result.append(planet)
            } else {
                if DEBUG {
                    print("\(satellite.name) is not a planet")
                }
            }
            result.append(contentsOf: satellite.getPlanets())
        }
        return result
    }

    /// Rolls for a valid moon orbit around this satellite. Keeps
    /// trying until it finds an empty orbit.
    func getMoonOrbit(_ diceMod: Int) -> Float {
        var orbit: Int
        repeat {
            switch Dice.roll(2) + diceMod {
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
    func getMaxPop()->(planets: [Planet?], pop: Int) {
        var maxPlanets: (planets: [Planet?], pop: Int)
        maxPlanets.pop = 0
        maxPlanets.planets = []
        for (_, satellite) in satellites.orbits {
            if let planet = satellite as? Planet {
                if planet.internalPopulation > maxPlanets.pop {
                    maxPlanets.planets.removeAll()
                    maxPlanets.planets.append(planet)
                    maxPlanets.pop = planet.internalPopulation
                } else if planet.internalPopulation == maxPlanets.pop {
                    maxPlanets.planets.append(planet)
                }
            }

            if satellite.satellites.orbits.count > 0 {
                let (planetArray, maxPopulation) = satellite.getMaxPop()
                if maxPopulation > maxPlanets.pop {
                    maxPlanets.planets.removeAll()
                    maxPlanets.planets.append(contentsOf: planetArray)
                    maxPlanets.pop = maxPopulation
                } else if maxPopulation == maxPlanets.pop {
                    maxPlanets.planets.append(contentsOf: planetArray)
                }
            }
        }
        return maxPlanets
    }

    /// Orbital depth of satellite from primary star
    var depth: Int {
        if self is Star && parent == nil {
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
        "\(type.lowercased()) \(name)"
    }
}
