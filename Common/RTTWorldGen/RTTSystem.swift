//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation
private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (left?, right?):
    return left < right
  case (nil, _?):
    return true
  default:
    return false
  }
}

private func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (left?, right?):
    return left > right
  default:
    return rhs < lhs
  }
}

class RTTSystem: CustomStringConvertible {
    var stars: [RTTStar] = []
    var age: Int // system age in billions of years
    var present = Set<StarOrbits>()
    var description: String {
        var result: String = ""
        result += "System is \(age) billion years old, there \(stars.count.strord("star")):\n"
        for star in stars {
            result += "\t\(star)"
        }
        result += "Orbits present: \(present)\n"
        return result
    }
    var verboseDesc: String {
        var result: String = ""
        result += "System is \(age) billion years old, there \(stars.count.strord("star")):\n"
        for star in stars {
            result += "\t\(star.verboseDesc)"
        }
        result += "Orbits present: \(present)\n"
        return result
    }

    init() {
        age = Dice.roll(3) - 3  // this is more useful to know in advance.
        if Dice.roll(1, sides: 2) == 2 {
            // brown dwarf somewhere
            stars.append(RTTStar(spectrum: .L, orbit: .brownDwarf, age: age))
        }

        if Dice.roll(1, sides: 2) == 2 {
            // star system present
            let ssRoll = Dice.roll(3)
            let spec = Dice.roll(2)
            let primary = RTTStar(specRoll: spec, age: age)
            stars.append(primary)

            if ssRoll >= 11 {
                // binary or ternary
                let secondary = RTTStar(specRoll: spec + Dice.roll(1) - 1, age: age, companion: true)
                present.insert(secondary.orbit)
                stars.append(secondary)
            }

            if ssRoll >= 16 {
                // ternary
                let ternary = RTTStar(specRoll: spec + Dice.roll(1) - 1, age: age, companion: true)
                present.insert(ternary.orbit)
                stars.append(ternary)
            }
        }

        // we need to have generated all stars before we can establish
        // what planets could exist.
        for star in stars {
            var orbitCount: [PlanetOrbit: Int] = [.epistellar: 0, .inner: 0, .outer: 0]
            if star.orbit == .primary || star.orbit == .distant || star.orbit == .brownDwarf {
                var curr: PlanetOrbit = .epistellar
                // epistellar orbits
                if star.luminosity != .typeIII && star.spectrum != .D && star.spectrum != .L {
                    orbitCount[curr] = Dice.roll() - 3
                    if orbitCount[curr] > 2 { orbitCount[curr] = 2 }
                    if star.spectrum == .M && star.luminosity == .typeV { orbitCount[curr]! -= 1 }
                    if orbitCount[curr] < 0 { orbitCount[curr] = 0 }
                }

                star.populatePlanets(orbitCount[curr]!, orbit: curr)

                curr = .inner

                // inner orbits
                if !present.contains(.close) || star.orbit == .brownDwarf {
                    if star.spectrum == .L {
                        orbitCount[curr] = Dice.roll(1, sides: 3) - 1
                    } else {
                        orbitCount[curr] = Dice.roll() - 1
                        if star.spectrum == .M && star.luminosity == .typeV { orbitCount[curr]! -= 1 }
                    }
                }

                if orbitCount[curr] < 0 { orbitCount[curr] = 0 }

                star.populatePlanets(orbitCount[curr]!, orbit: curr)

                curr = .outer

                // outer orbits
                if !present.contains(.moderate) || star.orbit == .brownDwarf {
                    orbitCount[curr] = Dice.roll() - 1
                    if (star.spectrum == .M && star.luminosity == .typeV) || star.spectrum == .L {
                        orbitCount[curr]! -= 1
                    }
                }

                if orbitCount[curr] < 0 { orbitCount[curr] = 0 }

                star.populatePlanets(orbitCount[curr]!, orbit: curr)
            }
            if star.spectrum == .D || star.luminosity == .typeIII {
                let affectedOrbits = Dice.roll()
                var index = 0
                repeat {
                    if index < star.planets.count - 1 {
                        switch star.planets[index].type {
                        case .dwarf: star.planets[index].type = .stygian
                        case .terrestrial: star.planets[index].type = .acheronian
                        case .helian: star.planets[index].type = .asphodelian
                        case .jovian: star.planets[index].type = .chthonian
                        default: break
                        }
                    }
                    index += 1
                } while index < affectedOrbits
            }
        }
    }
}
