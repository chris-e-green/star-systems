//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation

class RTTStar: Entity, CustomStringConvertible {
    var spectrum: Spectrum
    var luminosity: Luminosity?
    var orbit: StarOrbits = .primary
    var planets: [RTTPlanet] = []
    var age: Int
    var description: String {
        var result: String = ""
        result += String(describing: spectrum)
        if let lum = luminosity {
            result += "-\(lum)"
        }
        if orbit != .primary {
            result += " in \(orbit) orbit"
        } else {
            result += " (primary)"
        }
        if planets.count == 0 {
            result += " with no planets\n"
        } else {
            result += ", there "
        }

        if planets.count > 0 {
            result += "\(planets.count.strord("planet")):\n"
            for planet in planets {
                result += "\(planet)"
            }
        }
        return result
    }
    var verboseDesc: String {
        var result: String = ""
        result += String(describing: spectrum)
        if let lum = luminosity {
            result += "-\(lum)"
        }
        if orbit != .primary {
            result += " in \(orbit) orbit"
        } else {
            result += " (primary)"
        }
        if planets.count == 0 {
            result += " with no planets\n"
        } else {
            result += " with\n"
        }

        if planets.count > 0 {
            result += "\t\(planets.count) planet"
            if planets.count != 1 { result += "s" }
            result += ":\n"
            for planet in planets {
                result += "\t\t\(planet.longDescription)"
            }
        }
        return result
    }

    init(spectrum: Spectrum, orbit: StarOrbits, age: Int) {
        self.spectrum = spectrum
        self.orbit = orbit
        self.age = age
    }

    init(specRoll: Int, age: Int, companion: Bool = false) {
        self.age = age
        if companion {
            switch Dice.roll() {
            case 1, 2: orbit = .tight
            case 3, 4: orbit = .close
            case 5: orbit = .moderate
            default: orbit = .distant
            }
        }

        switch specRoll {
        case 2:
            switch age {
            case 0...2:
                spectrum = .A
                luminosity = .typeV
            case 3:
                switch Dice.roll(1) {
                case 1, 2:
                    spectrum = .F
                    luminosity = .typeIV
                case 3:
                    spectrum = .K
                    luminosity = .typeIII
                default:
                    spectrum = .D
                }
            default: spectrum = .D
            }
        case 3:
            switch age {
            case 0...5:
                spectrum = .F
                luminosity = .typeV
            case 6:
                switch Dice.roll(1) {
                case 1...4:
                    spectrum = .G
                    luminosity = .typeIV
                default:
                    spectrum = .M
                    luminosity = .typeIII
                }
            default: spectrum = .D
            }
        case 4:
            switch age {
            case 0...11:
                spectrum = .G
                luminosity = .typeV
            case 12, 13:
                switch Dice.roll(1) {
                case 1...3:
                    spectrum = .K
                    luminosity = .typeIV
                default:
                    spectrum = .M
                    luminosity = .typeIII
                }
            default: spectrum = .D
            }
        case 5:
            spectrum = .K
            luminosity = .typeV
        case 6 ... 13:
            switch Dice.roll(2) + (companion ? 2 : 0) {
            case 2...9:
                spectrum = .M
                luminosity = .typeV
            case 10...12:
                spectrum = .M
                luminosity = .typeVe
            default: spectrum = .L
            }
        default: spectrum = .L
        }
    }
    
    func populatePlanets(_ count: Int, orbit: PlanetOrbit) {
        if count > 0 {
            for _ in 1...count {
                switch Dice.roll() - (spectrum == .L ? 1 : 0) {
                case 0, 1:
                    planets.append(RTTPlanet(type: .asteroidBelt, orbit: orbit, star: self, parent: self, age: age))
                case 2:
                    planets.append(RTTPlanet(type: .dwarf, orbit: orbit, star: self, parent: self, age: age))
                case 3:
                    planets.append(RTTPlanet(type: .terrestrial, orbit: orbit, star: self, parent: self, age: age))
                case 4:
                    planets.append(RTTPlanet(type: .helian, orbit: orbit, star: self, parent: self, age: age))
                default:
                    planets.append(RTTPlanet(type: .jovian, orbit: orbit, star: self, parent: self, age: age))
                }
            }
        }
    }
}
