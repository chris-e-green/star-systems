//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class RTTSystem: CustomStringConvertible {
    var stars:[RTTStar] = []
    var age:Int // system age in billions of years
    var present = Set<StarOrbits>()
    var description: String {
        var result: String = ""
        result += "System is \(age) billion years old, there \(stars.count.strord("star")):\n"
        for s in stars {
            result += "\t\(s)"
        }
        result += "Orbits present: \(present)\n"
        return result
    }
    var verboseDesc: String {
        var result: String = ""
        result += "System is \(age) billion years old, there \(stars.count.strord("star")):\n"
        for s in stars {
            result += "\t\(s.verboseDesc)"
        }
        result += "Orbits present: \(present)\n"
        return result
    }

    init() {
        age = Dice.roll(3) - 3  // this is more useful to know in advance.
        if Dice.roll(1, sides: 2) == 2 {
            // brown dwarf somewhere
            stars.append(RTTStar(spectrum: .L, orbit:.BrownDwarf, age: age))
        }

        if Dice.roll(1, sides: 2) == 2 {
            // star system present
            let ssRoll = Dice.roll(3)
            let spec = Dice.roll(2)
            let primary = RTTStar(specRoll: spec, age: age)
            stars.append(primary)

            if ssRoll >= 11 {
                // binary or ternary
                let secondary = RTTStar(specRoll: spec + Dice.roll(1) - 1, age: age, companion:true)
                present.insert(secondary.orbit)
                stars.append(secondary)
            }

            if ssRoll >= 16 {
                // ternary
                let ternary = RTTStar(specRoll: spec + Dice.roll(1) - 1, age: age, companion:true)
                present.insert(ternary.orbit)
                stars.append(ternary)
            }
        }

        // we need to have generated all stars before we can establish
        // what planets could exist.
        for s in stars
        {
            var orbitCount:[PlanetOrbit:Int] = [.Epistellar:0, .Inner:0, .Outer: 0]
            if s.orbit == .Primary ||
                    s.orbit == .Distant ||
                    s.orbit == .BrownDwarf
            {
                var curr: PlanetOrbit = .Epistellar
                // epistellar orbits
                if s.luminosity != .III &&
                        s.spectrum != .D &&
                        s.spectrum != .L
                {
                    orbitCount[curr] = Dice.roll() - 3
                    if orbitCount[curr] > 2 { orbitCount[curr] = 2 }
                    if s.spectrum == .M && s.luminosity == .V
                    {
                        orbitCount[curr]! -= 1
                    }
                    if orbitCount[curr] < 0 { orbitCount[curr] = 0 }
                }

                s.populatePlanets(orbitCount[curr]!, orbit:curr)

                curr = .Inner

                // inner orbits
                if !present.contains(.Close) || s.orbit == .BrownDwarf
                {
                    if s.spectrum == .L
                    {
                        orbitCount[curr] = Dice.roll(1, sides: 3) - 1
                    } else {
                        orbitCount[curr] = Dice.roll() - 1
                        if s.spectrum == .M && s.luminosity == .V
                        {
                            orbitCount[curr]! -= 1
                        }
                    }
                }

                if orbitCount[curr] < 0 { orbitCount[curr] = 0 }

                s.populatePlanets(orbitCount[curr]!, orbit:curr)

                curr = .Outer

                // outer orbits
                if !present.contains(.Moderate) || s.orbit == .BrownDwarf
                {
                    orbitCount[curr] = Dice.roll() - 1
                    if (s.spectrum == .M && s.luminosity == .V) ||
                            s.spectrum == .L
                    {
                        orbitCount[curr]! -= 1
                    }
                }

                if orbitCount[curr] < 0 { orbitCount[curr] = 0 }

                s.populatePlanets(orbitCount[curr]!, orbit:curr)
            }
            if s.spectrum == .D || s.luminosity == .III {
                let affectedOrbits = Dice.roll()
                var i = 0
                repeat {
                    if i < s.planets.count - 1 {
                        switch s.planets[i].type {
                        case .dwarf: s.planets[i].type = .stygian
                        case .terrestrial: s.planets[i].type = .acheronian
                        case .helian: s.planets[i].type = .asphodelian
                        case .jovian: s.planets[i].type = .chthonian
                        default: break
                        }
                    }
                    i += 1
                } while i < affectedOrbits
            }
        }
    }
}
