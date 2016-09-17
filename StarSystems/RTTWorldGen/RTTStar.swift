//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation

class RTTStar: Entity, CustomStringConvertible {
    var spectrum:Spectrum
    var luminosity: Luminosity?
    var orbit: StarOrbits = .Primary
    var planets:[RTTPlanet] = []
    var age: Int
    var description: String {
        var result: String = ""
        result += String(spectrum)
        if let lum = luminosity {
            result += "-\(lum)"
        }
        if orbit != .Primary {
            result += " in \(orbit) orbit"
        } else {
            result += " (primary)"
        }
        if planets.count == 0
        {
            result += " with no planets\n"
        } else {
            result += ", there "
        }

        if planets.count > 0 {
            result += "\(planets.count.strord("planet")):\n"
            for p in planets {
                result += "\(p)"
            }
        }
        return result
    }
    var verboseDesc: String {
        var result: String = ""
        result += String(spectrum)
        if let lum = luminosity {
            result += "-\(lum)"
        }
        if orbit != .Primary {
            result += " in \(orbit) orbit"
        } else {
            result += " (primary)"
        }
        if planets.count == 0
        {
            result += " with no planets\n"
        } else {
            result += " with\n"
        }
        
        if planets.count > 0 {
            result += "\t\(planets.count) planet"
            if planets.count != 1 { result += "s" }
            result += ":\n"
            for p in planets {
                result += "\t\t\(p.longDescription)"
            }
        }
        return result
    }

    init(spectrum:Spectrum, orbit: StarOrbits, age: Int) {
        self.spectrum = spectrum
        self.orbit = orbit
        self.age = age
    }

    init(specRoll:Int, age: Int, companion: Bool = false) {
        self.age = age
        if companion {
            switch Dice.roll() {
            case 1, 2: orbit = .Tight
            case 3, 4: orbit = .Close
            case 5: orbit = .Moderate
            default: orbit = .Distant
            }
        }

        switch specRoll {
        case 2:
            switch age {
            case 0...2:
                spectrum = .A
                luminosity = .V
            case 3:
                switch Dice.roll(1) {
                case 1, 2:
                    spectrum = .F
                    luminosity = .IV
                case 3:
                    spectrum = .K
                    luminosity = .III
                default:
                    spectrum = .D
                }
            default: spectrum = .D
            }
        case 3:
            switch age {
            case 0...5:
                spectrum = .F
                luminosity = .V
            case 6:
                switch Dice.roll(1) {
                case 1...4:
                    spectrum = .G
                    luminosity = .IV
                default:
                    spectrum = .M
                    luminosity = .III
                }
            default: spectrum = .D
            }
        case 4:
            switch age {
            case 0...11:
                spectrum = .G
                luminosity = .V
            case 12, 13:
                switch Dice.roll(1) {
                case 1...3:
                    spectrum = .K
                    luminosity = .IV
                default:
                    spectrum = .M
                    luminosity = .III
                }
            default: spectrum = .D
            }
        case 5:
            spectrum = .K
            luminosity = .V
        case 6 ... 13:
            switch Dice.roll(2) + (companion ? 2 : 0) {
            case 2...9:
                spectrum = .M
                luminosity = .V
            case 10...12:
                spectrum = .M
                luminosity = .Ve
            default: spectrum = .L
            }
        default: spectrum = .L
        }
    }
    func populatePlanets(count: Int, orbit: PlanetOrbit) {
        if count > 0
        {
            for _ in 1...count
            {
                switch Dice.roll() - (spectrum == .L ? 1 : 0)
                {
                case 0, 1:
                    planets.append(RTTPlanet(type: .AsteroidBelt, orbit: orbit, star: self, parent: self, age: self.age))
                case 2:
                    planets.append(RTTPlanet(type: .Dwarf, orbit: orbit, star: self, parent: self, age: self.age))
                case 3:
                    planets.append(RTTPlanet(type: .Terrestrial, orbit: orbit, star: self, parent: self, age: self.age))
                case 4:
                    planets.append(RTTPlanet(type: .Helian, orbit: orbit, star: self, parent: self, age: self.age))
                default:
                    planets.append(RTTPlanet(type: .Jovian, orbit: orbit, star: self, parent: self, age: self.age))
                }
            }
        }
    }
}
