//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation

class RTTPlanet: Entity, CustomStringConvertible {
    let baseTL = 15 // one day it might be worth allowing this to be set.
    let settlement = 10 // how many centuries the region has been settled
    var type: PlanetType
    var satellites: [RTTPlanet] = []
    var parent: Entity
    var star: RTTStar
    var age: Int
    var satellite: Bool
    var orbit: PlanetOrbit
    var rings: String = ""
    var size: Int = 0
    var atmosphere: Int = 0
    var hydrosphere: Int = 0
    var biosphere: Int = 0
    var chemistry: Chemistry?
    var population: Int = 0
    var government: Int = 0
    var lawLevel: Int = 0
    var industry: Int = 0
    var desirability: Int = 0
    var techLevel: Int = 0
    var habitation: Habitation = .uninhabited
    var tradeCodes = Set<TradeCodes>()
    var bases = Set<RTTBases>()
    var starport: String = ""
    var longDescription: String {
        var result = ""
        result += "\(type) in \(orbit) orbit.\n"
        result += "Size: \(size.b36) (\(sizeDescription))\n"
        result += "Atmosphere: \(atmosphere.b36) (\(atmDescription))\n"
        result += "Hydrosphere: \(hydrosphere.b36) (\(hydDescription))\n"
        result += "Biosphere: \(biosphere.b36) (\(bioDescription))\n"
        if chemistry != nil { result += "Chemistry: \(chemistry!)\n" }
        result += "Population: \(population.b36) (\(popDescription))\n"
        result += "Government: \(government.b36) (\(govDescription))\n"
        result += "Law Level: \(lawLevel.b36) (\(lawDescription))\n"
        result += "Industry: \(industry.b36) (\(indDescription))\n"
        result += "Desirability: \(desirability)\n"
        result += "Habitation: \(habitation)\n"
        result += "Trade Codes: \(tradeCodes)\n"
        result += "Bases: "
        if bases.count == 0 {
            result += "none\n"
        } else {
            result += "\n"
            for base in bases {
                result += "\t\(base.longDescription)\n"
            }
        }
        if satellites.count > 0 {
            result += ", satellites are:\n"
            for satellite in satellites {
                result += "\t\t\t\(satellite)"
            }
        }
        return result
    }
    var description: String {
        var result = "\(type), \(orbit) orbit, \(uwp), Bio:\(biosphere.b36)"
        if chemistry != nil { result += " Chem:\(chemistry!)" }
        result += " Ind:\(industry.b36) Des:\(desirability) Hab:\(habitation) TC:\(tradeCodes) Bases:\(bases)"
        result += ")"
        if satellites.count > 0 {
            result += ", satellites are:\n"
            for satellite in satellites {
                result += "\t\t\t\(satellite)"
            }
        } else {
            result += "\n"
        }
        return result
    }

    var uwp: String {
        var result: String = ""
        if bases.contains(RTTBases.A) {
            result += "A"
        } else if bases.contains(RTTBases.B) {
            result += "B"
        } else if bases.contains(RTTBases.C) {
            result += "C"
        } else if bases.contains(RTTBases.D) {
            result += "D"
        } else if bases.contains(RTTBases.E) {
            result += "E"
        } else if bases.contains(RTTBases.X) {
            result += "X"
        }
        result += size.b36
        result += atmosphere.b36
        result += hydrosphere.b36
        result += population.b36
        result += government.b36
        result += lawLevel.b36
        return result
    }

    var sizeDescription: String {
        switch size {
        case 0: return "≤800 km, neg. gravity"
        case 1: return "1,600 km, 0.05 G"
        case 2: return "3,200 km, 0.15 G (Triton, Luna, Europa)"
        case 3: return "4,800 km, 0.25 G (Mercury, Ganymede)"
        case 4: return "6,400 km, 0.35 G (Mars)"
        case 5: return "8,000 km, 0.45 G"
        case 6: return "9,600 km, 0.70 G"
        case 7: return "11,200 km, 0.9 G"
        case 8: return "12,800 km, 1.0 G (Terra)"
        case 9: return "14,400 km, 1.25 G"
        case 10: return "≥16,000 km, ≥1.4 G"
        case 11...14: return "Helian size"
        case 16: return "Jovian size"
        case 33: return "Planetary-Mass Artifact"
        case 34: return "Asteroid Belt"
        default: return ""
        }
    }

    var atmDescription: String {
        switch atmosphere {
        case 0: return "Vacuum"
        case 1: return "Trace"
        case 2: return "Very Thin Tainted"
        case 3: return "Very Thin Breathable"
        case 4: return "Thin Tainted"
        case 5: return "Thin Breathable"
        case 6: return "Standard Breathable"
        case 7: return "Standard Tainted"
        case 8: return "Dense Breathable"
        case 9: return "Dense Tainted"
        case 10: return "Exotic"
        case 11: return "Corrosive"
        case 12: return "Insidious"
        case 13: return "Super-High Density"
        case 16: return "Gas Giant Envelope"
        default: return ""
        }
    }

    var hydDescription: String {
        switch hydrosphere {
        case 0: return "≤5% (Trace)"
        case 1: return "≤15% (Dry / tiny ice caps)"
        case 2: return "≤25% (Small seas / ice caps)"
        case 3: return "≤35% (Small oceans / large ice caps)"
        case 4: return "≤45% (Wet)"
        case 5: return "≤55% (Large oceans)"
        case 6: return "≤65%"
        case 7: return "≤75% (Terra)"
        case 8: return "≤85% (Water world)"
        case 9: return "≤95% (No continents)"
        case 10: return "≤100% (Total coverage)"
        case 11: return "Superdense (incredibly deep world oceans)"
        case 15: return "Intense Volcanism (molten surface)"
        case 16: return "Gas Giant Core"
        default: return ""
        }
    }

    var bioDescription: String {
        switch biosphere {
        case 0: return "Sterile"
        case 1: return "Building Blocks (amino acids, or equivalent)"
        case 2: return "Single-celled organisms"
        case 3: return "Producers (atmosphere begins to transform)"
        case 4: return "Multi-cellular organisms"
        case 5: return "Complex single-celled life (nucleic cells, or equivalent)"
        case 6: return "Complex multi-cellular life (microscopic animals)"
        case 7: return "Small macroscopic life"
        case 8: return "Large macroscopic life"
        case 9: return "Simple global ecology (life goes out of the oceans and onto land or into the air, etc.)"
        case 10: return "Complex global ecology"
        case 11: return "Proto-sapience"
        case 12: return "Full sapience"
        case 13: return "Trans-sapience (able to deliberately alter their own evolution, minimum Tech Level C)"
        default: return ""
        }
    }

    var popDescription: String {
        switch population {
        case 0: return "Uninhabited"
        case 1: return "Few"
        case 2: return "Hundreds"
        case 3: return "Thousands"
        case 4: return "Tens of thousands"
        case 5: return "Hundreds of thousands"
        case 6: return "Millions"
        case 7: return "Tens of millions"
        case 8: return "Hundreds of millions"
        case 9: return "Billions"
        case 10: return "Tens of billions"
        case 11: return "Hundreds of billions"
        case 12: return "Trillions"
        default: return ""
        }
    }

    var govDescription: String {
        switch government {
        case 0: return "None (tends toward family/clan/tribal)"
        case 1: return "Company or corporation"
        case 2: return "Participatory democracy"
        case 3: return "Self-perpetuating oligarchy"
        case 4: return "Representative democracy"
        case 5: return "Feudal technocracy"
        case 6: return "Captive government (colony or conquered territory)"
        case 7: return "Balkanized"
        case 8: return "Civil service bureaucracy"
        case 9: return "Impersonal bureaucracy"
        case 10: return "Charismatic dictator"
        case 11: return "Non-charismatic dictator"
        case 12: return "Charismatic oligarchy"
        case 13: return "Theocracy"
        case 14: return "Supreme authority"
        case 15: return "Hive-mind collective"
        default: return ""
        }
    }

    var lawDescription: String {
        switch lawLevel {
        case 0: return "No restrictions"
        case 1: return "Only restrictions upon WMD and other dangerous technologies"
        case 2...4: return "Light restrictions: heavy weapons, narcotics, alien technology"
        case 5...7: return "Heavy restrictions: most weapons, specialized tools and information, foreigners"
        default: return "Extreme restrictions: extensive monitoring and limitations, free speech curtailed"
        }
    }
    var indDescription: String {
        switch industry {
        case 0: return "No industry. Everything must be imported."
        case 1...3: return "Primitive. Mostly only raw materials made locally."
        case 4...6: return "Industrial. Local tools maintained, some produced."
        case 7...9: return "Pre-Stellar. Production and maintenance of space technologies."
        case 10, 11: return "Early Stellar. Support for A.I. and local starship production."
        case 12...14: return "Average Stellar. Support for terraforming, flying cities, clones."
        case 15: return "High Stellar. Support for highest of the high tech."

        default: return ""
        }
    }

    init(type: PlanetType, orbit: PlanetOrbit, star: RTTStar, parent: Entity, age: Int, satellite: Bool = false) {
        self.type = type
        self.orbit = orbit
        self.satellite = satellite
        self.parent = parent
        self.star = star
        self.age = age
        super.init()
        if !satellite { // we don't want satellites to have satellites.
            determineSatellites(type: type)
        }

        // World Type
        // ==========
        determineWorldType(type: type, orbit: orbit, parent: parent, satellite: satellite)

        // World Generation
        // ================
        generateWorld(star: star, orbit: orbit, age: age)

        // calculate desirability score
        calculateDesirability(star: star, orbit: orbit)
        // habitation
        calculateHabitation()
        determinePopulationAndGovernment()
        determineLawLevel()
        // industrial base
        determineIndustry()
        if population < 0 { population = 0 }
        if government < 0 { government = 0 }
        if lawLevel < 0 { lawLevel = 0 }
        if industry < 0 { industry = 0 }
        // Trade codes
        determineTradeCodes()

        bases.removeAll()

        // starport
        determineBases()
    }

    private func determineBases() {
        var roll = Dice.roll(2) + industry - 7
        if tradeCodes.contains(.Ag) { roll += 1 }
        if tradeCodes.contains(.Ga) { roll += 1 }
        if tradeCodes.contains(.Hi) { roll += 1 }
        if tradeCodes.contains(.Ht) { roll += 1 }
        if tradeCodes.contains(.In) { roll += 1 }
        if tradeCodes.contains(.Na) { roll += 1 }
        if tradeCodes.contains(.Ri) { roll += 1 }
        if baseTL >= 12 && baseTL <= 14 { roll += 1 }
        if baseTL >= 15 { roll += 2 }
        if tradeCodes.contains(.Lo) { roll -= 1 }
        if tradeCodes.contains(.Po) { roll -= 1 }
        if baseTL <= 9 { roll -= 1 }
        if roll < 0 { roll = 0 }
        switch roll {
        case 0...2: starport = "X"
        case 3, 4: starport = "E"
        case 5, 6: starport = "D"
        case 7, 8: starport = "C"
        case 9, 10: starport = "B"
        default: starport = "A"
        }
        if habitation == .outpost && population == 0 {
            starport = "E"
        }
        if industry >= 5 && (starport == "" || starport == "X") { starport = "E"
        }
        if (size < 1 || size > 11 || atmosphere < 2 || atmosphere > 9) && population > 0 && (starport == "" || starport == "X") {
            starport = "E"
        }
        // bases
        if starport == "A" { bases.insert(.A) }
        if starport == "B" { bases.insert(.B) }
        if starport == "C" { bases.insert(.C) }
        if starport == "D" { bases.insert(.D) }
        if starport == "E" { bases.insert(.E) }
        if starport == "X" { bases.insert(.X) }
        if bases.contains(.A) {
            var roll = Dice.roll(2)
            if roll >= 6 { bases.insert(.G) }
            if roll >= 9 { bases.insert(.F) }
            if roll == 12 { bases.insert(.GC) }
            roll = Dice.roll(2)
            if roll >= 6 { bases.insert(.M) }
            if roll >= 9 { bases.insert(.Y) }
            if roll == 12 { bases.insert(.MH) }
            roll = Dice.roll(2)
            if roll >= 10 { bases.insert(.TC) } else if roll >= 7 { bases.insert(.TA) } else if roll >= 4 { bases.insert(.T) }
        }
        if bases.contains(.B) {
            var roll = Dice.roll(2)
            if roll >= 8 { bases.insert(.G) }
            if roll >= 11 { bases.insert(.F) }
            roll = Dice.roll(2)
            if roll >= 8 { bases.insert(.M) }
            if roll >= 11 {bases.insert(.Y) }
            roll = Dice.roll(2)
            if roll >= 9 { bases.insert(.TC) } else if roll >= 6 { bases.insert(.T) }
        }
        if bases.contains(.C) {
            if Dice.roll(2) >= 10 {
                bases.insert(.G)
            }
            if Dice.roll(2) >= 10 {
                bases.insert(.M)
            }
            if Dice.roll(2) >= 10 { bases.insert(.T) }
        }
        if bases.contains(.A) || bases.contains(.B) || bases.contains(.C) {
            roll = Dice.roll(2)
            if roll >= 8 { bases.insert(.N) }
            if roll >= 11 {
                if bases.contains(.Y) { bases.insert(.H) } else { bases.insert(.Y) }
            }
        }
        if bases.contains(.B) && Dice.roll(2) == 12 { bases.insert(.P) }
        if bases.contains(.C) && Dice.roll(2) >= 10 {
            bases.insert(.P) }
        if bases.contains(.D) || bases.contains(.E) {
            bases.insert(.P)}
        if population > 0 && Dice.roll(2) == 12 {
            bases.insert(.Z)
        }
        if bases.contains(.A) {
            let roll = Dice.roll(2)
            if roll >= 8 { bases.insert(.R) }
            if roll >= 11 {
                let specialBaseRoll = Dice.roll(1, sides: 3)
                if specialBaseRoll == 1 {
                    bases.insert(.H)
                } else if specialBaseRoll == 2 {
                    bases.insert(.U)
                } else {
                    bases.insert(.L)
                }
            }
        }
        if (bases.contains(.B) || bases.contains(.C)) &&
                   Dice.roll(2) >= 10 { bases.insert(.R) }
        if habitation == .outpost {
            let roll = Dice.roll(2)
            if roll >= 9 { bases.insert(.R) }
            if roll == 12 { bases.insert(.L) }
        }
        if population > 1 && Dice.roll(2) <= population { bases.insert(.K) }
        if bases.contains(.A) {
            let roll = Dice.roll(2)
            if roll >= 10 {bases.insert(.S)}
        }
        if bases.contains(.B) || bases.contains(.C) {
            let roll = Dice.roll(2)
            if roll >= 8 { bases.insert(.S) }
            if roll >= 11 { bases.insert(.SH) }
        }
        if bases.contains(.D) {
            let roll = Dice.roll(2)
            if roll >= 7 { bases.insert(.S) }
            if roll >= 10 { bases.insert(.SH) }
        }
        if (population >= 1 || biosphere >= 1) && Dice.roll(2) >= 10 {
            bases.insert(.V)
        }
    }

    private func determineTradeCodes() {
        tradeCodes.removeAll()
        if atmosphere >= 4 && atmosphere <= 9 && hydrosphere >= 4 && hydrosphere <= 8 && population >= 5 && population <= 7 {
            tradeCodes.insert(.Ag)
        }
        if self.type == .asteroidBelt {
            tradeCodes.insert(.As)
        }
        if atmosphere >= 2 && atmosphere <= 13 && hydrosphere == 0 {
            tradeCodes.insert(.De)
        }

        if (atmosphere >= 10 || chemistry != .water) && hydrosphere >= 1 && hydrosphere <= 11 {
            tradeCodes.insert(.Fl)
        }
        if size >= 5 && size <= 10 && atmosphere >= 4 && atmosphere <= 9 && hydrosphere >= 4 && hydrosphere <= 8 {
            tradeCodes.insert(.Ga)
        }
        if population >= 9 { tradeCodes.insert(.Hi) }
        if industry >= baseTL - 3 { tradeCodes.insert(.Ht) }
        if (atmosphere == 0 || atmosphere == 1) && hydrosphere >= 1 {
            tradeCodes.insert(.Ic)
        }
        if population >= 9 && industry >= 6 { tradeCodes.insert(.In) }
        if population >= 1 && population <= 3 { tradeCodes.insert(.Lo) }
        if industry <= 5 { tradeCodes.insert(.Lt) }
        if (atmosphere <= 3 || atmosphere >= 11) && (hydrosphere <= 3 || hydrosphere >= 11) && population >= 6 { tradeCodes.insert(.Na) }
        if population >= 4 && population <= 6 { tradeCodes.insert(.Ni) }
        if atmosphere >= 2 && atmosphere <= 5 && hydrosphere <= 3 { tradeCodes.insert(.Po) }
        if (atmosphere == 6 || atmosphere == 8) && population >= 6 && population <= 8 { tradeCodes.insert(.Ri) }
        if biosphere == 0 { tradeCodes.insert(.St) }
        if atmosphere >= 2 && (hydrosphere == 10 || hydrosphere == 11) {
            tradeCodes.insert(.Wa) }
        if atmosphere == 0 { tradeCodes.insert(.Va) }
        if biosphere >= 7 { tradeCodes.insert(.Zo) }
    }

    private func determineIndustry() {
        if population == 0 { industry = 0 } else {
            industry = population + Dice.roll(2) - 7
            if lawLevel >= 1 && lawLevel <= 3 { industry += 1 }
            if lawLevel >= 6 && lawLevel <= 9 { industry -= 1 }
            if lawLevel >= 10 && lawLevel <= 12 { industry -= 2 }
            if lawLevel >= 13 { industry -= 3 }
            if atmosphere <= 4 || atmosphere == 7 || atmosphere >= 9 || hydrosphere == 15 { industry += 1 }
            if baseTL >= 12 && baseTL <= 14 { industry += 1 }
            if baseTL > 15 { industry += 2 }
        }
        if industry == 0 { population -= 1 }
        if industry >= 4 && industry <= 9 {
            population += 1
            if atmosphere == 3 { atmosphere = 2 } else if atmosphere == 5 { atmosphere = 4 } else if atmosphere == 6 { atmosphere = 7 } else if atmosphere == 8 { atmosphere = 9 }
        }
        if industry >= 10 {
            if Dice.roll() > 3 {
                population += 2
                if atmosphere == 3 { atmosphere = 2 } else if atmosphere == 5 { atmosphere = 4 } else if atmosphere == 6 { atmosphere = 7 } else if atmosphere == 8 { atmosphere = 9 }
            } else {
                population += 1
            }
        }
    }

    private func determineLawLevel() {
        if government == 0 { lawLevel = 0 } else { lawLevel = government + Dice.roll(2) - 7 }
        // law level
        if lawLevel < 0 { lawLevel = 0 }
    }

    private func determinePopulationAndGovernment() {
        switch habitation {
        case .homeworld:
            population = desirability + Dice.roll(1, sides: 3) - Dice.roll(1, sides: 3)
            if population < 0 { population = 0 }
            if baseTL == 0 { government = 0 } else {
                if Dice.roll() <= baseTL - 9 { government = 7 } else {
                    government = population + Dice.roll(2) - 7
                    if government < 0 { government = 0 }
                }
            }
        case .colony:
            population = baseTL + settlement - 9
            let maxPop = desirability + Dice.roll(1, sides: 3) - Dice.roll(1, sides: 3)
            if population > maxPop { population = maxPop }
            if population < 4 { population = 4 }
            government = population + Dice.roll(2) - 7
            if government < 0 { government = 0 }
            // colonists may seed world
            if size >= 1 && size <= 11 && atmosphere >= 2 &&
                       atmosphere <= 9 && biosphere <= 2 {
                biosphere = Dice.roll() + 5
            }
        case .outpost:
            population = Dice.roll(1, sides: 3) + desirability
            if population > 4 { population = 4 }
            if population < 0 { population = 0 }
            if population == 0 { government = 0 } else {
                government = population + Dice.roll(2) - 7
                if government > 6 {government = 6}
                if government < 0 {government = 0}
            }
        case .uninhabited:
            population = 0
            government = 0
        }
    }

    private func calculateHabitation() {
        if biosphere >= 12 {
            habitation = .homeworld
        } else if Dice.roll(2) - 2 <= desirability {
            habitation = .colony
        } else if Dice.roll() < baseTL - 9 {
            habitation = .outpost
        }
    }

    private func calculateDesirability(star: RTTStar, orbit: PlanetOrbit) {
        if self.type == .asteroidBelt {
            desirability = Dice.roll() - Dice.roll()
            if star.spectrum == .M && star.luminosity == .typeVe {
                desirability -= Dice.roll(1, sides: 3)
                if self.orbit == .inner {
                    if star.spectrum == .M && star.luminosity == .typeV {
                        desirability += 1
                    }
                    if star.luminosity == .typeIV { desirability += 2 }
                }
            }
        } else {
            // dry world
            if hydrosphere == 0 { desirability -= 1 }
            // extreme environment
            if size >= 13 || (atmosphere >= 12 && atmosphere <= 16) || hydrosphere == 15 { desirability -= 2 }
            // flare star
            if star.spectrum == .M && star.luminosity == .typeVe {
                desirability -= Dice.roll(1, sides: 3)
            }
            // habitable world
            if size >= 1 && size <= 11 && atmosphere >= 2 && atmosphere <= 9 && hydrosphere <= 11 {
                // garden world
                if size >= 5 && size <= 10 && atmosphere >= 4 &&
                           atmosphere <= 9 && hydrosphere >= 4 &&
                           hydrosphere <= 8 { desirability += 5 }
                // water world
                else if hydrosphere >= 10 && hydrosphere <= 11 { desirability += 3 }
                // poor world
                else if atmosphere >= 2 && atmosphere <= 6 &&
                                hydrosphere <= 3 { desirability += 2 } else { desirability += 4 }
            }
            // high gravity
            if size >= 10 && atmosphere <= 15 { desirability -= 1 }
            // lifebelt
            if orbit == .inner {
                if star.spectrum == .M && star.luminosity == .typeV {
                    desirability += 1
                }
                if star.luminosity == .typeIV { desirability += 2 }
            }
            // tiny world
            if size == 0 { desirability -= 1 }
            // t-prime atmosphere
            if atmosphere == 6 || atmosphere == 8 { desirability += 1 }
        }
    }

    private func generateWorld(star: RTTStar, orbit: PlanetOrbit, age: Int) {
        if self.type == .acheronian {
            size = Dice.roll() + 4
            atmosphere = 1
            hydrosphere = 0
            biosphere = 0
        }
        if self.type == .arean {
            size = Dice.roll() - 1
            var roll = Dice.roll() - (star.spectrum == .D ? 2 : 0)
            if roll < 4 { atmosphere = 1 } else { atmosphere = 10 }
            hydrosphere = Dice.roll(2) + size - 7 - (atmosphere == 1 ? 4 : 0)
            if hydrosphere < 0 { hydrosphere = 0 }
            roll = Dice.roll()
            var diceMod = 0
            if star.spectrum == .L { diceMod += 2 }
            if orbit == .outer { diceMod += 2 }
            var ageMod = 0
            switch roll + diceMod {
            case 1...4: chemistry = .water
            case 5, 6: chemistry = .ammonia ; ageMod = 1
            default: chemistry = .methane ; ageMod = 3
            }
            if age >= (Dice.roll(1, sides: 3) + ageMod) && atmosphere == 1 {
                biosphere = Dice.roll() - 4
            }
            if age >= (Dice.roll(1, sides: 3) + ageMod) && atmosphere == 10 {
                biosphere = Dice.roll(1, sides: 3)
            }
            if age >= (4 + ageMod) && atmosphere == 10 {
                biosphere = Dice.roll() + size - 2
            }
            if biosphere < 0 { biosphere = 0 }

        }
        if self.type == .arid {
            size = Dice.roll() + 4
            let roll = Dice.roll()
            var diceMod = 0
            if star.spectrum == .K && star.luminosity == .typeV { diceMod += 2 }
            if star.spectrum == .M && star.luminosity == .typeV { diceMod += 4 }
            if star.spectrum == .L { diceMod += 5 }
            if orbit == .outer { diceMod += 2 }
            var ageMod = 0
            switch roll + diceMod {
            case 1...6: chemistry = .water
            case 7, 8: chemistry = .ammonia ; ageMod = 1
            default: chemistry = .methane ; ageMod = 3
            }
            if age >= (Dice.roll(1, sides: 3) + ageMod) {
                biosphere = Dice.roll(1, sides: 3)
            }
            if age >= (4 + ageMod) {
                biosphere = Dice.roll(2) - (star.spectrum == .D ? 3 : 0)
            }
            if biosphere < 0 { biosphere = 0 }
            if biosphere >= 3 && chemistry == .water {
                atmosphere = Dice.roll(2) - 7 + size
                if atmosphere < 2 { atmosphere = 2 }
                if atmosphere > 9 { atmosphere = 9 }
            } else {
                atmosphere = 10
            }
            hydrosphere = Dice.roll(1, sides: 3)
        }
        if self.type == .asphodelian {
            size = Dice.roll() + 9
            atmosphere = 1
            hydrosphere = 0
            biosphere = 0
        }
        if self.type == .chthonian {
            size = 16
            atmosphere = 1
            hydrosphere = 0
            biosphere = 0
        }
        if self.type == .hebean {
            size = Dice.roll() - 1
            atmosphere = Dice.roll() + size - 6
            if atmosphere < 0 { atmosphere = 0 }
            if atmosphere >= 2 { atmosphere = 10 }
            hydrosphere = Dice.roll(2) + size - 11
            if hydrosphere < 0 { hydrosphere = 0 }
            biosphere = 0
        }
        if self.type == .helian {
            size = Dice.roll() + 9
            atmosphere = 13
            switch Dice.roll() {
            case 3, 4: hydrosphere = Dice.roll(2) - 1
            case 5, 6: hydrosphere = 15
            default: hydrosphere = 0
            }
            biosphere = 0
        }
        if self.type == .janiLithic {
            size = Dice.roll() + 4
            let roll = Dice.roll()
            if roll < 4 { atmosphere = 1 } else { atmosphere = 10 }
            hydrosphere = 0
            biosphere = 0
        }
        if self.type == .jovian {
            size = 16
            atmosphere = 16
            hydrosphere = 16
            let roll = Dice.roll() + (orbit == .inner ? 2 : 0)
            if roll >= 6 {
                if age > Dice.roll() { biosphere = Dice.roll(1, sides: 3) }
                if age > 7 { biosphere = Dice.roll(2) - (star.spectrum == .D ? 3 : 0) }
                if biosphere < 0 { biosphere = 0 }
                var diceMod = Dice.roll()
                if star.spectrum == .L { diceMod += 1 }
                if orbit == .epistellar { diceMod -= 2 }
                if orbit == .outer { diceMod += 2 }
                if diceMod < 4 { chemistry = .water } else { chemistry = .ammonia }
            }
        }
        if self.type == .meltball {
            size = Dice.roll() - 1
            atmosphere = 1
            hydrosphere = 15
            biosphere = 0
        }
        if self.type == .oceanic {
            size = Dice.roll() + 4
            var roll = Dice.roll()
            if star.spectrum == .K && star.luminosity == .typeV { roll += 2 }
            if star.spectrum == .M && star.luminosity == .typeV { roll += 4 }
            if star.spectrum == .L { roll += 5 }
            if orbit == .outer { roll += 2 }
            var ageMod = 0
            switch roll {
            case 1...6: chemistry = .water
            case 7, 8: chemistry = .ammonia ; ageMod = 1
            default: chemistry = .methane ; ageMod = 3
            }
            if age >= Dice.roll(1, sides: 3) + ageMod { biosphere = Dice.roll(1, sides: 3)
            }
            if age >= 4 + ageMod { biosphere = Dice.roll(2) - (star.spectrum == .D ? 3 : 0)
            }
            if biosphere < 0 { biosphere = 0 }
            if chemistry == .water {
                var diceMod = 0
                if star.spectrum == .K && star.luminosity == .typeV { diceMod = -1 }
                if star.spectrum == .M && star.luminosity == .typeV { diceMod = -2 }
                if star.spectrum == .L { diceMod = -3 }
                if star.luminosity == .typeIV { diceMod = -1 }
                atmosphere = Dice.roll(2) + size - 6 + diceMod
                if atmosphere < 1 { atmosphere = 1 }
                if atmosphere > 12 { atmosphere = 12 }
            } else {
                switch Dice.roll() {
                case 1: atmosphere = 1
                case 2...4: atmosphere = 10
                default: atmosphere = 12
                }
            }
            hydrosphere = 11
        }
        if self.type == .panthalassic {
            size = Dice.roll() + 9
            atmosphere = Dice.roll() + 8
            if atmosphere > 13 { atmosphere = 13 }
            hydrosphere = 11
            var roll = Dice.roll()
            if star.spectrum == .K && star.luminosity == .typeV { roll += 2 }
            if star.spectrum == .M && star.luminosity == .typeV { roll += 4 }
            if star.spectrum == .L { roll += 5 }
            var ageMod = 0
            switch roll {
            case 1...6:
                switch Dice.roll(2) {
                case 2...8: chemistry = .water
                case 9...11: chemistry = .sulfur
                default: chemistry = .chlorine
                }
            case 7, 8: chemistry = .ammonia ; ageMod = 1
            default: chemistry = .methane ; ageMod = 3
            }
            if age >= Dice.roll(1, sides: 3) + ageMod {
                biosphere = Dice.roll(1, sides: 3)
            }
            if age >= 4 + ageMod {
                biosphere = Dice.roll(2)
            }

        }
        if self.type == .promethean {
            size = Dice.roll() - 1
            var roll = Dice.roll()
            if star.spectrum == .L { roll += 2 }
            if orbit == .epistellar { roll -= 2 }
            if orbit == .outer { roll += 2 }
            if roll < 1 { roll = 1 }
            var ageMod = 0
            switch roll {
            case 1...4: chemistry = .water
            case 5, 6: chemistry = .ammonia ; ageMod = 1
            default: chemistry = .methane ; ageMod = 3
            }
            if age >= Dice.roll(1, sides: 3) + ageMod {
                biosphere = Dice.roll(1, sides: 3)
            }
            if age >= 4 + ageMod {
                biosphere = Dice.roll(2) - (star.spectrum == .D ? 3 : 0)
            }
            if biosphere < 0 { biosphere = 0 }
            if biosphere >= 3 && chemistry == .water {
                atmosphere = Dice.roll(2) + size - 7
                if atmosphere < 2 { atmosphere = 2 }
                if atmosphere > 9 { atmosphere = 9 }
            } else { atmosphere = 10 }
            hydrosphere = Dice.roll(2) - 2
        }
        if self.type == .rockball {
            size = Dice.roll() - 1
            atmosphere = 0
            var roll = Dice.roll(2) + size - 11
            if star.spectrum == .L { roll += 1 }
            if orbit == .epistellar { roll -= 2 }
            if orbit == .outer { roll += 2 }
            if roll < 0 { roll = 0 }
            hydrosphere = roll
            biosphere = 0
        }
        if self.type == .smallBody {
            size = 0
            atmosphere = 0
            hydrosphere = 0
            biosphere = 0
        }
        if self.type == .snowball {
            size = Dice.roll() - 1
            var subsurfaceOceans = false
            if Dice.roll() < 5 { atmosphere = 0 } else { atmosphere = 1 }
            if Dice.roll() < 4 { hydrosphere = 10 ; subsurfaceOceans = true } else { hydrosphere = Dice.roll(2) - 2 }
            var roll = Dice.roll()
            if star.spectrum == .L { roll += 2 }
            if orbit == .outer { roll += 2 }
            var ageMod = 0
            switch roll {
            case 1...4: chemistry = .water
            case 5, 6: chemistry = .ammonia ; ageMod = 1
            default: chemistry = .methane ; ageMod = 3
            }
            if subsurfaceOceans {
                if age >= Dice.roll() + ageMod {
                    biosphere = Dice.roll() - 3
                }
                if age >= 6 + ageMod {
                    biosphere = Dice.roll() + size - 2
                }
                if biosphere < 0 { biosphere = 0 }
            }
        }
        if self.type == .stygian {
            size = Dice.roll() - 1
            atmosphere = 0
            hydrosphere = 0
            biosphere = 0
        }
        if self.type == .tectonic {
            size = Dice.roll() + 4
            var roll = Dice.roll()
            if star.spectrum == .K && star.luminosity == .typeV { roll += 2 }
            if star.spectrum == .M && star.luminosity == .typeV { roll += 4 }
            if star.spectrum == .L { roll += 5 }
            if orbit == .outer { roll += 2 }
            var ageMod = 0
            switch roll {
            case 1...6:
                switch Dice.roll(2) {
                case 2...8: chemistry = .water
                case 9...11: chemistry = .sulfur
                default: chemistry = .chlorine
                }
            case 7, 8: chemistry = .ammonia ; ageMod = 1
            default: chemistry = .methane ; ageMod = 3
            }
            if age >= Dice.roll(1, sides: 3) + ageMod {
                biosphere = Dice.roll(1, sides: 3)
            }
            if age >= 4 + ageMod {
                biosphere = Dice.roll(2) - (star.spectrum == .D ? 3 : 0)
            }
            if biosphere < 0 { biosphere = 0 }
            if biosphere >= 3 && chemistry == .water {
                atmosphere = Dice.roll(2) + size - 7
                if atmosphere < 2 { atmosphere = 2 }
                if atmosphere > 9 { atmosphere = 9 }
            } else if biosphere >= 3 && (chemistry == .sulfur || chemistry == .chlorine) { atmosphere = 11 } else { atmosphere = 10 }
            hydrosphere = Dice.roll(2) - 2
        }
        if self.type == .telluric {
            size = Dice.roll() + 4
            atmosphere = 12
            if Dice.roll() < 5 { hydrosphere = 0 } else { hydrosphere = 15 }
            biosphere = 0
        }
        if self.type == .vesperian {
            size = Dice.roll() + 4
            if Dice.roll(2) == 12 { chemistry = .chlorine } else { chemistry = .water }
            if age >= Dice.roll(1, sides: 3) {
                biosphere = Dice.roll(1, sides: 3)
            }
            if age >= 4 { biosphere = Dice.roll(2) }
            if biosphere >= 3 && chemistry == .water {
                atmosphere = Dice.roll(2) + size - 7
                if atmosphere < 2 { atmosphere = 2 }
                if atmosphere > 9 { atmosphere = 9 }
            } else if biosphere >= 3 && chemistry == .chlorine {
                atmosphere = 11
            } else { atmosphere = 10 }
            hydrosphere = Dice.roll(2) - 2
        }
    }

    private func determineWorldType(type: PlanetType, orbit: PlanetOrbit, parent: Entity, satellite: Bool) {
        switch type {
        case .dwarf:
            switch orbit {
            case .epistellar:
                var diceMod = 0
                if let planet = parent as? RTTPlanet {
                    if planet.type == .asteroidBelt { diceMod = -2 }
                }
                switch Dice.roll() + diceMod {
                case 1...3: self.type = .rockball
                case 4, 5: self.type = .meltball
                default:
                    if Dice.roll() < 5 {
                        self.type = .hebean
                    } else {
                        self.type = .promethean
                    }
                }
            case .inner:
                var diceMod = 0
                if let planet = parent as? RTTPlanet {
                    if planet.type == .asteroidBelt { diceMod -= 2 }
                    if planet.type == .helian { diceMod += 1 }
                    if planet.type == .jovian { diceMod += 1 }
                }
                var roll = Dice.roll() + diceMod
                if roll < 1 { roll = 1 }
                switch roll {
                case 1...4: self.type = .rockball
                case 5, 6: self.type = .arean
                case 7: self.type = .meltball
                default:
                    if Dice.roll() < 5 {
                        self.type = .hebean
                    } else {
                        self.type = .promethean
                    }
                }
            case .outer:
                var diceMod = 0
                if let planet = parent as? RTTPlanet {
                    if planet.type == .asteroidBelt { diceMod -= 1 }
                    if planet.type == .helian { diceMod += 1 }
                    if planet.type == .jovian { diceMod += 2 }
                }
                var roll = Dice.roll() + diceMod
                if roll < 0 { roll = 0 }
                switch roll {
                case 0: self.type = .rockball
                case 1...4: self.type = .snowball
                case 5, 6: self.type = .rockball
                case 7: self.type = .meltball
                default:
                    switch Dice.roll() {
                    case 1...3: self.type = .hebean
                    case 4, 5: self.type = .arean
                    default: self.type = .promethean
                    }
                }
            }
        case .terrestrial:
            switch orbit {
            case .epistellar:
                switch Dice.roll() {
                case 1...4: self.type = .janiLithic
                case 5: self.type = .vesperian
                default: self.type = .telluric
                }
            case .inner:
                switch Dice.roll(2) {
                case 2...4: self.type = .telluric
                case 5, 6: self.type = .arid
                case 7: self.type = .tectonic
                case 8, 9: self.type = .oceanic
                case 10:  self.type = .tectonic
                default: self.type = .telluric
                }
            case .outer:
                switch Dice.roll() + (satellite ? 2 : 0) {
                case 1...4: self.type = .arid
                case 5, 6: self.type = .tectonic
                default: self.type = .oceanic
                }
            }
        case .helian:
            switch orbit {
            case .epistellar:
                if Dice.roll() == 6 {
                    self.type = .asphodelian
                }
            case .inner:
                if Dice.roll() > 4 {
                    self.type = .panthalassic
                }
            default: break
            }
        case .jovian:
            if orbit == .epistellar && Dice.roll() == 6 {
                self.type = .chthonian
            }
        default: break
        }
    }

    private func determineSatellites(type: PlanetType) {
        switch type {
        case .asteroidBelt:
            satellites.append(RTTPlanet(type: .smallBody, orbit: self.orbit, star: self.star, parent: self, age: self.age, satellite: true))
            if Dice.roll() > 4 {
                satellites.append(RTTPlanet(type: .dwarf, orbit: self.orbit, star: self.star, parent: self, age: self.age, satellite: true))
            }
        case .dwarf:
            if Dice.roll() == 6 {
                satellites.append(RTTPlanet(type: .dwarf, orbit: self.orbit, star: self.star, parent: self, age: self.age, satellite: true))
            }
        case .terrestrial:
            if Dice.roll() > 4 {
                satellites.append(RTTPlanet(type: .dwarf, orbit: self.orbit, star: self.star, parent: self, age: self.age, satellite: true))
            }
        case .helian:
            var count = Dice.roll() - 3
            if count < 0 { count = 0 }
            if count > 0 {
                if Dice.roll() < 6 {
                    for _ in 1...count {
                        satellites.append(RTTPlanet(type: .dwarf, orbit: self.orbit, star: self.star, parent: self, age: self.age, satellite: true))
                    }
                } else {
                    for index in 1...count {
                        if index == 1 {
                            satellites.append(RTTPlanet(type: .terrestrial, orbit: self.orbit, star: self.star, parent: self, age: self.age, satellite: true))
                        } else {
                            satellites.append(RTTPlanet(type: .dwarf, orbit: self.orbit, star: self.star, parent: self, age: self.age, satellite: true))
                        }
                    }
                }
            }

        case .jovian:
            let count = Dice.roll()
            if Dice.roll() < 6 {
                for _ in 1...count {
                    satellites.append(RTTPlanet(type: .dwarf, orbit: self.orbit, star: self.star, parent: self, age: self.age, satellite: true))
                }
            } else {
                if Dice.roll() < 6 {
                    for index in 1...count {
                        if index == 1 {
                            satellites.append(RTTPlanet(type: .terrestrial, orbit: self.orbit, star: self.star, parent: self, age: self.age, satellite: true))
                        } else {
                            satellites.append(RTTPlanet(type: .dwarf, orbit: self.orbit, star: self.star, parent: self, age: self.age, satellite: true))
                        }
                    }
                } else {
                    for index in 1...count {
                        if index == 1 {
                            satellites.append(RTTPlanet(type: .helian, orbit: self.orbit, star: self.star, parent: self, age: self.age, satellite: true))
                        } else {
                            satellites.append(RTTPlanet(type: .dwarf, orbit: self.orbit, star: self.star, parent: self, age: self.age, satellite: true))
                        }
                    }
                }
            }
            if Dice.roll() < 5 {
                rings = "Minor ring system"
            } else {
                rings = "Complex ring system"
            }
        case .smallBody:
            break
        default:
            break
        }
    } // end of init
} // end of RTTPlanet class
