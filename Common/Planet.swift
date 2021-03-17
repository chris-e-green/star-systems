//
//  Planet.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//
//  The Traveller game in all forms is owned by Far Future Enterprises.
//  Copyright 1977 - 2008 Far Future Enterprises.
//

import Foundation

enum Facility: String, CustomStringConvertible {
    case farming
    case mining
    case colony
    case researchLaboratory
    case militaryBase
    var description: String {
        switch self {
        case .researchLaboratory: return "Research Laboratory"
        case .militaryBase: return "Military Base"
        default: return self.rawValue.uppercaseFirst
        }
    }
}

enum Base: String, CustomStringConvertible {
    case navalBase
    case scoutBase
    case navalDepot
    case scoutWayStation
    var description: String {
        switch self {
        case .navalBase:
            return "Naval Base"
        case .scoutBase:
            return "Scout Base"
        case .navalDepot:
            return "Naval Depot"
        case .scoutWayStation:
            return "Scout Way Station"
        }
    }
}
// swiftlint:disable identifier_name
enum TradeClass: String, CustomStringConvertible {
    case Ag
    case As
    case Ba
    case De
    case Fl
    case Hi
    case Ic
    case In
    case Lo
    case Na
    case Ni
    case Po
    case Ri
    case Va
    case Wa
    var description: String {
        switch self {
        case .Ag: return "Agric."
        case .As: return "Ast. Belt"
        case .Ba: return "Barren"
        case .De: return "Desert"
        case .Fl: return "Fluid Oceans"
        case .Hi: return "High Pop."
        case .Ic: return "Ice-capped"
        case .In: return "Indust."
        case .Lo: return "Low Pop."
        case .Na: return "Non-Agric."
        case .Ni: return "Non-Indust."
        case .Po: return "Poor"
        case .Ri: return "Rich"
        case .Va: return "Vacuum"
        case .Wa: return "Water World"
        }
    }
    var verboseDesc: String {
        switch self {
        case .Ag: return "agricultural"
        case .As: return "asteroid belt"
        case .Ba: return "barren"
        case .De: return "desert"
        case .Fl: return "fluid oceans" // with
        case .Hi: return "high population" // with
        case .Ic: return "ice-capped"
        case .In: return "industrial"
        case .Lo: return "low population" // with
        case .Na: return "non-agricultural"
        case .Ni: return "non-industrial"
        case .Po: return "poor"
        case .Ri: return "rich"
        case .Va: return "vacuum"
        case .Wa: return "water world"
        }
    }
    // swiftlint:enable identifier_name
}

class Planet: Satellite, CustomStringConvertible {
    // MARK: System-centric Variables
    var coordinateX: Int=0
    var coordinateY: Int=0
    var gasGiant: Bool = false
    var planetoids: Bool = false

    // MARK: Planet-centric Variables
    var starport: String = " "
    var bases = Set<Base>()
    var internalSize: Int = 0
    var internalAtmosphere: Int = 0
    var internalHydrographics: Int = 0
    var internalPopulation: Int = 0
    var internalGovernment: Int = 0
    var internalLawLevel: Int = 0
    var internalTechnologicalLevel: Int = 0
    var debugRolls = false
    var rollHistory: [String: Int] = [:]
    var tradeClassifications = Set<TradeClass>()
    var facilities = Set<Facility>()

    let die = Dice()

    // MARK: Calculated Variables
    var facilitiesStr: String {
        var result = ""
        var first = true
        for facility in facilities {
            if first { first = false } else { result += ", " }
            result += String(describing: facility)
        }
        return result
    }
    var shortTradeClassifications: String {
        var tradeClassificationString = ""
        var first = true
        for tradeClassification in tradeClassifications.sorted(by: {$0.description < $1.description}) {
            if first { first = false } else { tradeClassificationString += ", " }
            tradeClassificationString += tradeClassification.rawValue
        }
        return tradeClassificationString
    }
    var longTradeClassifications: String {
        var tradeClassificationString = ""
        var first = true
        for tradeClassification in tradeClassifications.sorted(by: {$0.description < $1.description}) {
            if first { first = false } else { tradeClassificationString += ", " }
            tradeClassificationString += String(describing: tradeClassification)
        }
        return tradeClassificationString
    }
    var baseStr: String {
        var result: String = ""
        if gasGiant {result += " G"} else {result += "  "}
        if bases.contains(.navalBase) && bases.contains(.scoutBase) {
            result += " A"
        } else if bases.contains(.navalBase) {
            result += " N"
        } else if bases.contains(.scoutBase) {
            result += " S"
        } else if facilities.contains(Facility.militaryBase) {
            result += " M"
        } else {
            result += "  "
        }
        return result
    }

    var description: String {
        var result = ""
        result += name.padding(maxNameLength)
        if coordinateX != 0 && coordinateY != 0 {
            result += String(format: "%02d%02d", arguments: [coordinateX, coordinateY])
            result += " "
        }
        result += uwp
        result += "\(baseStr) "
        result += "\(shortTradeClassifications)"
        result += "\(facilitiesStr)"
        if debugRolls { result += "\n\(rollHistory)\n" }
        if satellites.orbits.count > 0 {
            //            result += "2"
            result += "\(satDesc)"
        }
        return result
    }

    var uwp: String {
        String(format: "%@%@%@%@%@%@%@-%@", arguments: [starport, size, atmosphere, hydrographics, population, government, lawLevel, technologicalLevel])
    }

    var xml: String {
                """
                <planet>
                    <\(JsonLabels.name)>\(name)</\(JsonLabels.name)>
                    <\(JsonLabels.coords)>
                        <x>\(coordinateX)</x>
                        <y>\(coordinateY)</y>
                    </\(JsonLabels.coords)>
                    <\(JsonLabels.starport)>\(starport)</\(JsonLabels.starport)>
                    <\(JsonLabels.size)>\(size)</\(JsonLabels.size)>
                    <\(JsonLabels.atm)>\(atmosphere)</\(JsonLabels.atm)>
                    <\(JsonLabels.hyd)>\(hydrographics)</\(JsonLabels.hyd)>
                    <\(JsonLabels.pop)>\(population)</\(JsonLabels.pop)>
                    <\(JsonLabels.gov)>\(government)</\(JsonLabels.gov)>
                    <\(JsonLabels.law)>\(lawLevel)</\(JsonLabels.law)>
                    <\(JsonLabels.tech)>\(technologicalLevel)</\(JsonLabels.tech)>
                    <\(JsonLabels.naval)>\(bases.contains(.navalBase) ? "N" : "")</\(JsonLabels.naval)>
                    <\(JsonLabels.scout)>\(bases.contains(.scoutBase) ? "S" : "")</\(JsonLabels.scout)>
                    <\(JsonLabels.gas)>\(gasGiant)</\(JsonLabels.gas)>
                    <\(JsonLabels.trade)>\(shortTradeClassifications)</\(JsonLabels.trade)>
                </planet>
                """
    }

    override var json: String {
        var result =
                """
                 \"\(JsonLabels.planet)\": {
                 \"\(JsonLabels.name)\": \"\(name)\",
                """
        if parent == nil {
            // coordinates only make sense when planet=system so only add them when we have no parent star/gg.
            result += """
                       \"\(JsonLabels.coords)\": {
                        \"x\": \(coordinateX),
                        \"y\": \(coordinateY)
                      """
        }
        result += """
                   \"\(JsonLabels.starport)\": \"\(starport)\",
                   \"\(JsonLabels.size)\": \"\(size)\",
                   \"\(JsonLabels.atm)\": \(atmosphere),
                   \"\(JsonLabels.hyd)\": \(hydrographics),
                   \"\(JsonLabels.pop)\": \(population),
                   \"\(JsonLabels.gov)\": \(government),
                   \"\(JsonLabels.law)\": \(lawLevel),
                   \"\(JsonLabels.tech)\": \(technologicalLevel),
                   \"\(JsonLabels.naval)\": \(bases.contains(.navalBase)),
                   \"\(JsonLabels.scout)\": \(bases.contains(.scoutBase)),
                  """
        if parent == nil {
            // gas giant only makes sense when planet=system so only add it when we have no parent star/gg.
            result += " \"\(JsonLabels.gas)\": \(gasGiant),\n"
        }
        result += """
                   \"\(JsonLabels.trade)\": \"\(shortTradeClassifications)\",
                   \"\(JsonLabels.fac)\": \"\(facilitiesStr)\"
                  }
                  """
        return result
    }

    var sizeDescription: String {
        switch internalSize {
        case -2: return "Ring (around a world)"
        case -1: return "Small World (200 km)"
        case 0: return "Asteroid/Planetoid Belt"
        case 1: return "1,000 miles (1,600 km)"
        case 2: return "2,000 miles (3,200 km)"
        case 3: return "3,000 miles (4,800 km)"
        case 4: return "4,000 miles (6,400 km)"
        case 5: return "5,000 miles (8,000 km)"
        case 6: return "6,000 miles (9,600 km)"
        case 7: return "7,000 miles (11,200 km)"
        case 8: return "8,000 miles (12,800 km)"
        case 9: return "9,000 miles (14,400 km)"
        case 10: return "10,000 miles (16,000 km)"
        default: return ""
        }
    }

    var starportDescription: String {
        switch starport {
        case "A": return "Excellent quality with refined fuel, overhaul, shipyards"
        case "B": return "Good quality with refined fuel, overhaul, shipyards for non-starships"
        case "C": return "Routine quality with unrefined fuel, some repair facilities"
        case "D": return "Poor quality with unrefined fuel; no repair facilities"
        case "E": return "Frontier installation; no facilities"
        case "F": return "Good quality"
        case "G": return "Poor quality"
        case "H": return "Primitive facilities"
        case "X": return "No starport. Generally a red travel zone"
        case "Y": return "No spaceport"
        default: return ""
        }
    }

    var atmosphereDescription: String {
        switch internalAtmosphere {
        case 0: return "No atmosphere"
        case 1: return "Trace"
        case 2: return "Very thin, tainted"
        case 3: return "Very thin"
        case 4: return "Thin, tainted"
        case 5: return "Thin"
        case 6: return "Standard"
        case 7: return "Standard, tainted"
        case 8: return "Dense"
        case 9: return "Dense, tainted"
        case 10: return "Exotic"
        case 11: return "Corrosive"
        case 12: return "Insidious"
        case 13: return "Dense, high"
        case 14: return "Ellipsoid"
        case 15: return "Thin, low"
        default: return ""
        }
    }

    var hydrographicsDescription: String {
        switch internalHydrographics {
        case 0: return "No free standing water"
        case 1..<10: return "\(internalHydrographics*10)% water"
        case 10: return "No land masses"
        default: return ""
        }
    }

    var populationDescription: String {
        switch internalPopulation {
        case 0: return "No inhabitants"
        case 1: return "Tens of inhabitants"
        case 2: return "Hundreds of inhabitants"
        case 3: return "Thousands of inhabitants"
        case 4: return "Tens of thousands"
        case 5: return "Hundreds of thousands"
        case 6: return "Millions of inhabitants"
        case 7: return "Tens of millions"
        case 8: return "Hundreds of millions"
        case 9: return "Billions of inhabitants"
        case 10: return "Tens of billions"
        default: return ""
        }
    }

    var governmentDescription: String {
        switch internalGovernment {
        case 0: return "No government structure"
        case 1: return "Company/Corporation"
        case 2: return "Participating Democracy"
        case 3: return "Self-Perpetuating Oligarchy"
        case 4: return "Representative Democracy"
        case 5: return "Feudal Technocracy"
        case 6: return "Captive Government"
        case 7: return "Balkanization"
        case 8: return "Civil Service Bureaucracy"
        case 9: return "Impersonal Bureacracy"
        case 10: return "Charismatic Dictator"
        case 11: return "Non-Charismatic Leader"
        case 12: return "Charismatic Oligarchy"
        case 13: return "Religious Dictatorship"
        default:return ""
        }
    }

    var lawLevelDescription: String {
        switch internalLawLevel {
        case 0: return "No prohibitions"
        case 1: return "Body pistols undetectable by standard detectors, explosives (bombs, grenades), and poison gas prohibited"
        case 2: return "Portable energy weapons (laser carbine, laser rifle) prohibited. Ship's gunnery not affected"
        case 3: return "Weapons of a strict military nature (machine guns, automatic rifles) prohibited"
        case 4: return "Light assault weapons (sub-machineguns) prohibited"
        case 5: return "Personal concealable firearms (pistols, revolvers) prohibited"
        case 6: return "Most firearms (all except shotguns) prohibited. The carrying of any type of weapon openly is discouraged"
        case 7: return "Shotguns are prohibited"
        case 8: return "Long bladed weapons (all but daggers) are controlled, and open possession is prohibited"
        case 9: return "Possession of any weapon outside one's residence is prohibited"
        default:return "Weapon possession is prohibited"
        }
    }

    var techLevelDescription: String {
        switch internalTechnologicalLevel {
        case 0: return "Stone Age. Primitive"
        case 1: return "Bronze Age to Middle Ages"
        case 2: return "circa 1400 to 1700"
        case 3: return "circa 1700 to 1860"
        case 4: return "circa 1860 to 1900"
        case 5: return "circa 1900 to 1939"
        case 6: return "circa 1940 to 1969"
        case 7: return "circa 1970 to 1979"
        case 8: return "circa 1980 to 1989"
        case 9: return "circa 1990 to 2000"
        case 10: return "Interstellar community"
        case 11: return "Average Imperial"
        case 12: return "Average Imperial"
        case 13: return "Above average Imperial"
        case 14: return "Above average Imperial"
        case 15: return "Technical maximum Imperial"
        default: return ""
        }
    }

    var verboseBases: String {
        var result = ""
        // verbose bases string
        if bases.count > 0 {
            result += "There is a "
            var baseString = ""
            for base in bases {
                if bases.index(bases.firstIndex(of: base)!, offsetBy: 1) == bases.endIndex && bases.count != 1 {
                    baseString += "and a \(base.description.lowercased()) "
                } else if bases.firstIndex(of: base) == bases.startIndex {
                    baseString += "\(base.description.lowercased()) "
                } else {
                    baseString += ", a \(base.description.lowercased()) "
                }
            }
            result += baseString
            result += "present. "
        }
        return result
    }

    var verboseFacilities: String {
        var result = ""
        if facilities.count > 0 {
            result += "There is a "
            var facilityString = ""
            for facility in facilities {
                if facilities.index(facilities.firstIndex(of: facility)!, offsetBy: 1) == facilities.endIndex && facilities.count != 1 {
                    facilityString += "and a \(facility.description.lowercased()) "
                } else if facilities.firstIndex(of: facility) == facilities.startIndex {
                    facilityString += "\(facility.description.lowercased()) "
                } else {
                    facilityString += ", a \(facility.description.lowercased()) "
                }
            }
            result += facilityString
            result += "present. "
        }
        return result
    }

    var verboseTradeClassifications: String {
        var result = ""
        let nonWithTC = tradeClassifications.filter({$0 != .Lo && $0 != .Fl && $0 != .Hi})
        let withTC = tradeClassifications.subtracting(nonWithTC)
        if tradeClassifications.count > 0 {
            result += "\(name) is a"
            for tradeClassification in nonWithTC {
                if nonWithTC.firstIndex(of: tradeClassification) != nonWithTC.startIndex {
                    result += ","
                }
                result += " \(tradeClassification.verboseDesc.lowercased())"
            }
            result += " world"
            var with = ""
            if withTC.count > 0 {
                for tradeClassification in withTC {
                    if with.isEmpty { with = " with"} else { with += " and"}
                    with += " \(tradeClassification.verboseDesc.lowercased())"
                }
            }
            result += with

            result += "."
        }
        return result
    }

    var verboseDesc: String {
        if internalSize == -2 { return "This is a ring system around the \(parent!.nameAndType). "}
        if internalSize == 0 { return "This is an asteroid/planetoid belt orbiting the \(parent!.nameAndType). "}
        let planetType = parent!.type == "Star" ? "planet" : "moon"
        var result = "\(name) is a "
        if internalSize == -1 {
            result += "small (200km) \(planetType)"} else {
            result += "\(planetType) with a diameter of roughly \(sizeDescription) "
        }
        result += " orbiting the \(parent!.nameAndType). "
        result += "It has " + (internalAtmosphere==0 ?
            "\(atmosphereDescription.lowercased()) " : "a \(atmosphereDescription.lowercased()) atmosphere ")
        result += "and \(hydrographicsDescription.lowercased()) on its surface. "
        if internalPopulation == 1 {
            result += "It has less than one hundred inhabitants"
        } else {
            result += "It has \(populationDescription.lowercased())" + (populationDescription.contains("inhabitants") ? "" : " inhabitants")
        }
        if internalPopulation > 0 {
            if internalGovernment > 0 {
            result += " who live under a \(governmentDescription.lowercased()). "
            } else {
                result += " who have no government structure. "
            }
            result += "Legally, \(lawLevelDescription.lowercased()). "
            result += "The technological level is "
            if internalTechnologicalLevel < 10 {result += "equivalent to " }
            result += "\(techLevelDescription.lowercased()).  "
        } else { result += ". "}
        if starport == "Y" { result += "The planet has no spaceport. "} else if starport == "X" {
            result += "The planet has no starport and is generally in a red travel zone. "
        } else if starport == "H" || starport == "E" {
            result += "The planet has a spaceport with \(starportDescription.lowercased()). "
        } else {
            result += "The planet has a starport of \(starportDescription.lowercased()). "
        }

        result += verboseBases
        // verbose facilities string

        result += verboseFacilities

        // verbose trade classifications string
        result += verboseTradeClassifications

        return result
    }

    var fullDescription: String {
        "Starport: \(starport) (\(starportDescription))\n" +
                "Naval Base: \(bases.contains(.navalBase) ? "present" : "absent")\n" +
                "Scout Base: \(bases.contains(.scoutBase) ? "present" : "absent")\n" +
                "Gas Giant: \(gasGiant ? "present" : "absent")\n" +
                "Planetoids: \(planetoids ? "present" : "absent")\n" +
                "Size: \(size) (\(sizeDescription))\n" +
                "Atmosphere: \(atmosphere) (\(atmosphereDescription))\n" +
                "Hydrographics: \(hydrographics) (\(hydrographicsDescription))\n" +
                "Population: \(population) (\(populationDescription))\n" +
                "Government: \(government) (\(governmentDescription))\n" +
                "Law Level: \(lawLevel) (\(lawLevelDescription))\n" +
                "Tech Level: \(technologicalLevel) (\(techLevelDescription))\n" +
                "Trade classifications: \(longTradeClassifications)"
    }

    // MARK: Initializers
    convenience init(coordX: Int, coordY: Int) {
        self.init()
        coordinateX = coordX
        coordinateY = coordY
        generateRandomPlanet()
    }

    convenience init(orbit: Float, starType: StarType, zone: Zone, planetoid: Bool = false, parent: Satellite?) {
        self.init(parent: parent)
        generateRandomPlanet(orbit, starType: starType, zone: zone, planetoid: planetoid)
    }

    convenience init(fromJSON: [String: AnyObject]) {
        self.init()
        name = (fromJSON["\(JsonLabels.name)"] as? String)!
        starport = (fromJSON["\(JsonLabels.starport)"] as? String)!
        if (fromJSON["\(JsonLabels.size)"] as? String) != nil {
            size = (fromJSON["\(JsonLabels.size)"] as? String)!
        } else { // support 'legacy' number type.
            internalSize = (fromJSON[JsonLabels.size.rawValue] as? Int)!
        }
        atmosphere = (fromJSON["\(JsonLabels.atm)"] as? String)!
        hydrographics = (fromJSON["\(JsonLabels.hyd)"] as? String)!
        population = (fromJSON["\(JsonLabels.pop)"] as? String)!
        government = (fromJSON["\(JsonLabels.gov)"] as? String)!
        lawLevel = (fromJSON["\(JsonLabels.law)"] as? String)!
        technologicalLevel = (fromJSON["\(JsonLabels.tech)"] as? String)!
        if (fromJSON["\(JsonLabels.naval)"] as? Bool) != nil { bases.insert(.navalBase) }
        if (fromJSON["\(JsonLabels.scout)"] as? Bool) != nil { bases.insert(.scoutBase) }
        gasGiant = (fromJSON["\(JsonLabels.gas)"] as? Bool)!
        let coord = (fromJSON["\(JsonLabels.coords)"] as? [String: Int])!
        coordinateX = coord["x"]!
        coordinateY = coord["y"]!
        setTradeClassifications()
    }

    convenience init(upp: String, scoutBase: Bool, navalBase: Bool, gasGiant: Bool) {
        self.init()
        if scoutBase { bases.insert(.scoutBase) }
        if navalBase { bases.insert(.navalBase) }
        self.gasGiant = gasGiant
        for (uppIndex, uppChar) in upp.enumerated() {
            switch uppIndex {
            case 0: starport = String(uppChar)
            case 1: internalSize = Int(String(uppChar), radix: 16) ?? 0
            case 2: internalAtmosphere = Int(String(uppChar), radix: 16) ?? 0
            case 3: internalHydrographics = Int(String(uppChar), radix: 16) ?? 0
            case 4: internalPopulation = Int(String(uppChar), radix: 16) ?? 0
            case 5: internalGovernment = Int(String(uppChar), radix: 16) ?? 0
            case 6: internalLawLevel = Int(String(uppChar), radix: 16) ?? 0
            case 8: internalTechnologicalLevel = Int(String(uppChar), radix: 16) ?? 0
            default: break
            }
        }
        // determine trade classifications
        setTradeClassifications()
    }

    convenience init(starport: String, size: Int, atmosphere: Int, hydrographics: Int, population: Int,
                     government: Int, lawLevel: Int, techLevel: Int, navalBase: Bool, scoutBase: Bool, gasGiant: Bool) {
        self.init()
        self.starport = starport
        internalSize = size
        internalAtmosphere = atmosphere
        internalHydrographics = hydrographics
        internalPopulation = population
        internalGovernment = government
        internalLawLevel = lawLevel
        internalTechnologicalLevel = techLevel
        if navalBase { bases.insert(.navalBase) }
        if scoutBase { bases.insert(.scoutBase) }
        self.gasGiant = gasGiant
        // determine trade classifications
        setTradeClassifications()
    }

    // MARK: Functions
    func generateRandomPlanet(_ planetoid: Bool = false) {
        if debugRolls { rollHistory["from_scratch"] = 1 }
        let nameGen: Name = Name(maxLength: maxNameLength)
        var roll = 0
        name = String(describing: nameGen)
        // generate starport
        rollStarport()
        // generate naval base
        rollNavalBase()
        // generate scout base
        rollScoutBase()
        // check for gas giants
        rollGasGiant()
        // check for planetoids
        rollPlanetoids()
        // calculate size
        roll = die.roll(2)
        if debugRolls { rollHistory["size"] = roll }
        internalSize = roll - 2
        // calculate atmosphere
        if internalSize == 0 {
            internalAtmosphere = 0
        } else {
            roll = die.roll(2)
            if debugRolls { rollHistory["atm"] = roll }
            internalAtmosphere = roll - 7 + internalSize
        }
        if internalAtmosphere < 0 { internalAtmosphere = 0 }
        // calculate hydrographics
        if internalSize <= 1 {
            internalHydrographics = 0
        } else {
            roll = die.roll(2)
            if debugRolls { rollHistory["hyd"] = roll }
            internalHydrographics = roll - 7 + internalAtmosphere
            if internalAtmosphere <= 1 || internalAtmosphere >= 10 {
                internalHydrographics -=  4
            }
        }
        if internalHydrographics < 0 {internalHydrographics = 0}
        if internalHydrographics > 10 {internalHydrographics = 10}
        // calculate population
        roll = die.roll(2)
        if debugRolls { rollHistory["pop"] = roll }
        internalPopulation = roll - 2
        // calculate government
        rollGovernment()
        // calculate law level
        rollLawLevel()
        // calculate tech level
        rollTechLevel()
        // determine trade classifications
        setTradeClassifications()
    }

    func generateRandomPlanet(_ orbit: Float, starType: StarType, zone: Zone, planetoid: Bool = false) {
        // generate a random planet for a specific star
        if debugRolls { rollHistory["from_star"] = 1 }
        internalSize = getSize(planetoid: planetoid, orbit: orbit, starType: starType)

        // determine atmosphere
        var roll = 0

        if internalSize < 1 {
            internalAtmosphere = 0
        } else {
            roll = die.roll(2)
            if debugRolls { rollHistory["atm"] = roll }
            internalAtmosphere = roll - 7 + internalSize
            if zone == Zone.I { internalAtmosphere -= 2 }
            if parent is Planet || parent is GasGiant { internalAtmosphere -= 2 }
            if zone == Zone.O { internalAtmosphere -= 4 }
        }
        if internalAtmosphere < 0 { internalAtmosphere = 0 }

        // determine hydrographics

        if internalSize <= 0 || zone == Zone.I || (internalSize <= 1 && parent is Star) {
            internalHydrographics = 0
        } else {
            roll = die.roll(2)
            if debugRolls { rollHistory["hyd"] = roll }
            internalHydrographics = roll - 7 + internalAtmosphere
            if zone == Zone.O { internalHydrographics -= 2 }
            if internalAtmosphere <= 1 || internalAtmosphere >= 10 {
                internalHydrographics -= 4
            }
        }
        if internalHydrographics < 0 {internalHydrographics = 0}
        if internalHydrographics > 10 {internalHydrographics = 10}

        // determine population

        roll = die.roll(2)
        if debugRolls { rollHistory["pop"] = roll }
        internalPopulation = roll - 2
        if zone == Zone.I { internalPopulation -= 5 }
        if parent is Star && zone == Zone.O { internalPopulation -= 3 }
        if parent is Planet && zone == Zone.O { internalPopulation -= 4 }
        if internalAtmosphere != 5 && internalAtmosphere != 6 && internalAtmosphere != 8 { internalPopulation -= 2 }
        if internalSize == -2 { internalPopulation = 0 }
        if parent is Planet && internalSize >= -1 && internalSize <= 4 { internalPopulation -= 2 }
        if internalPopulation < 0 { internalPopulation = 0 }
        // also need to make sure it's not > main world. Will do this elsewhere.
    }

    private func getSize(planetoid: Bool, orbit: Float, starType: StarType) -> Int {
        var size = 0
        var roll = 0
        // determine size
        if planetoid {
            size = 0
        } else {
            if parent is Star {
                // calculate size
                let diceModifier: Int = (orbit == 0 ? -5 : 0) + (orbit == 1 ? -4 : 0) + (orbit == 2 ? -2 : 0) + (starType == StarType.M ? -2 : 0)
                roll = die.roll(2)
                if debugRolls { rollHistory["size"] = roll }
                size = roll - 2 + diceModifier
                if size <= 0 { size = -1 }
            } else {
                if let planet = parent as? Planet {
                    roll = die.roll()
                    if debugRolls { rollHistory["pl_sat_size"] = roll }
                    size = planet.internalSize - roll
                } else if let planet = parent as? GasGiant {
                    if planet.size == .large {
                        roll = die.roll(2)
                        if debugRolls { rollHistory["gg_sat_size"] = roll }
                        size = roll - 4
                    } else {
                        roll = die.roll(2)
                        if debugRolls { rollHistory["gg_sat_size"] = roll }
                        size = roll - 6
                    }
                }
                if size < 0 { size = -1 }
                if size == 0 { size = -2 }
            }
        }
        return size
    }

    func checkPopulation(_ maxPopulation: Int) {
        if internalPopulation >= maxPopulation {
            internalPopulation = maxPopulation - 1
            if internalPopulation < 0 { internalPopulation = 0 }
        }
    }

    var size: String {
        get {
            switch internalSize {
            case -2: return "R"
            case -1: return "S"
            default: return String(format: "%1X", internalSize)
            }
        }
        set(newSize) {
            switch newSize {
            case "R": internalSize = -2
            case "S": internalSize = -1
            default: internalSize = Int(newSize, radix: 16) ?? 0
            }
        }
    }
    var atmosphere: String {
        get {
            String(format: "%1X", internalAtmosphere)
        }
        set(newAtmosphere) {
            internalAtmosphere = Int(newAtmosphere, radix: 16) ?? 0
        }
    }
    var hydrographics: String {
        get {
            String(format: "%1X", internalHydrographics)
        }
        set(newHydrographics) {
            internalHydrographics = Int(newHydrographics, radix: 16) ?? 0
        }
    }
    var population: String {
        get {
            String(format: "%1X", internalPopulation)
        }
        set(newPopulation) {
            internalPopulation = Int(newPopulation, radix: 16) ?? 0
        }
    }
    var government: String {
        get {
            String(format: "%1X", internalGovernment)
        }
        set(newGovernment) {
            internalGovernment = Int(newGovernment, radix: 16) ?? 0
        }
    }
    var lawLevel: String {
        get {
            String(format: "%1X", internalLawLevel)
        }
        set(newLawLevel) {
            internalLawLevel = Int(newLawLevel, radix: 16) ?? 0
        }
    }
    var technologicalLevel: String {
        get {
            String(format: "%1X", internalTechnologicalLevel)
        }
        set(newTechLevel) {
            internalTechnologicalLevel = Int(newTechLevel, radix: 16) ?? 0
        }
    }

    func rollStarport() {
        let roll = die.roll(2)
        if debugRolls { rollHistory["starport"] = roll }
        switch roll {
        case 2, 3, 4: starport="A"
        case 5, 6:   starport="B"
        case 7, 8:   starport="C"
        case 9:     starport="D"
        case 10, 11: starport="E"
        case 12:    starport="X"
        default:    starport="?"
        }
    }

    func rollNavalBase() {
        let roll = die.roll(2)
        if debugRolls { rollHistory["naval"] = roll }
        if starport < "C" && roll >= 8 { bases.insert(.navalBase) }
    }

    func rollScoutBase() {
        let roll = die.roll(2)
        if debugRolls { rollHistory["scout"] = roll }
        if starport < "E" {
            var diceMod: Int = 0
            switch starport {
            case "A": diceMod = -3
            case "B": diceMod = -2
            case "C": diceMod = -1
            default: diceMod = 0
            }
            if roll + diceMod >= 7 { bases.insert(.scoutBase) }
        }
    }

    func rollGasGiant() {
        let roll = die.roll(2)
        if debugRolls { rollHistory["gas"] = roll }
        gasGiant = (roll <= 9)
    }

    func rollPlanetoids() {
        let roll = die.roll(2)
        if debugRolls { rollHistory["planetoids"] = roll }
        planetoids = (roll <= 6)
    }

    func rollGovernment() {
        if internalPopulation > 0 {
            let roll = die.roll(2)
            if debugRolls { rollHistory["gov"] = roll }
            internalGovernment = roll - 7 + internalPopulation
            if internalGovernment < 0 {internalGovernment = 0}
        }
    }

    func rollLawLevel() {
        let roll = die.roll(2)
        if debugRolls { rollHistory["law"] = roll }
        internalLawLevel = roll - 7 + internalGovernment
        if internalLawLevel < 0 {internalLawLevel = 0}
        if internalLawLevel > 15 {internalLawLevel = 15}
    }

    func rollTechLevel() {
        var diceMod: Int = 0
        switch starport {
        case "A": diceMod = 6
        case "B": diceMod = 4
        case "C": diceMod = 2
        case "X": diceMod = -4
        default: break
        }
        switch internalSize {
        case -1..<2: diceMod += 2
        case 2..<5: diceMod += 1
        default: break
        }
        switch internalAtmosphere {
        case 0..<4: diceMod += 1
        case 10..<15: diceMod += 1
        default: break
        }
        switch internalHydrographics {
        case 9: diceMod += 1
        case 10: diceMod += 2
        default: break
        }
        switch internalPopulation {
        case 1..<6: diceMod += 1
        case 9: diceMod += 2
        case 10: diceMod += 4
        default: break
        }
        switch internalGovernment {
        case 0: diceMod += 1
        case 5: diceMod += 1
        case 13: diceMod -= 2
        default: break
        }
        let roll = die.roll()
        if debugRolls { rollHistory["tech"] = roll }
        internalTechnologicalLevel = roll + diceMod

        // although not explicitly stated in the rules, it is clear from the example systems given that tech level is zero if population is zero.
        if internalPopulation == 0 { internalTechnologicalLevel = 0 }
        if internalTechnologicalLevel < 0 {internalTechnologicalLevel = 0}
        if internalTechnologicalLevel > 15 {internalTechnologicalLevel = 15}
    }

    func setFacilities(_ mainWorld: Planet) {
        if debugRolls { rollHistory["facilities"] = 1 }
        facilities.removeAll()
        if zone == Zone.H &&
            internalAtmosphere >= 4 && internalAtmosphere <= 9 &&
            internalHydrographics >= 4 && internalHydrographics <= 8 &&
            internalPopulation >= 2 {
            facilities.insert(.farming)
        }
        if mainWorld.tradeClassifications.contains(.In) && internalPopulation >= 2 {
            facilities.insert(.mining)
        }
        if internalGovernment == 6 && internalPopulation >= 5 {
            facilities.insert(.colony)
        }
        if mainWorld.internalTechnologicalLevel > 8 && internalPopulation > 0 {
            if (die.roll(2) + mainWorld.internalTechnologicalLevel >= 10 ? 2 : 0) >= 11 {
                facilities.insert(.researchLaboratory)
            }
        }
        if !mainWorld.tradeClassifications.contains(.Po) && internalPopulation > 0 {
            if die.roll(2) + (mainWorld.internalPopulation >= 8 ? 1 : 0) + (mainWorld.internalAtmosphere == internalAtmosphere ? 2 : 0) >= 12 {
                facilities.insert(.militaryBase)
            }
        }
    }

    func setSatelliteAttribs(_ mainWorld: Planet) {
        if debugRolls { rollHistory["sat_attribs"] = 1 }
        var diceMod = 0
        var roll = 0
        if internalPopulation > 0 {
            if mainWorld.internalGovernment == 6 { internalGovernment = mainWorld.internalGovernment } else {
                if mainWorld.internalGovernment >= 7 { diceMod = 1 }
                roll = die.roll()
                if debugRolls { rollHistory["sat_gov"] = roll }
                switch roll + diceMod {
                case 1: internalGovernment = 0
                case 2: internalGovernment = 1
                case 3: internalGovernment = 2
                case 4: internalGovernment = 3
                default: internalGovernment = 6
                }
            }
            if internalGovernment == 0 { internalLawLevel = 0 } else {
                roll = die.roll()
                if debugRolls { rollHistory["sat_law"] = roll }
                internalLawLevel = roll - 3 + mainWorld.internalLawLevel
            }
            if internalLawLevel < 0 { internalLawLevel = 0 }
            if internalLawLevel > 15 { internalLawLevel = 15 }
        } else { internalGovernment = 0 }
        setFacilities(mainWorld)
        if facilities.contains(.militaryBase) || facilities.contains(.researchLaboratory) {
            internalTechnologicalLevel = mainWorld.internalTechnologicalLevel
        } else {
            internalTechnologicalLevel = mainWorld.internalTechnologicalLevel - 1
        }
        if internalPopulation == 0 { internalTechnologicalLevel = 0 }
        if internalTechnologicalLevel < 0 { internalTechnologicalLevel = 0 }
        roll = die.roll()
        if debugRolls { rollHistory["spaceport"] = roll }
        switch roll + (internalPopulation >= 6 ? 2 : 0) - (internalPopulation == 1 ? 2 : 0) - (internalPopulation == 0 ? 3 : 0) {
        case -2...2: starport = "Y"
        case 3: starport = "H"
        case 4, 5: starport = "G"
        default: starport = "F"
        }

    }

    func setTradeClassifications() {
        if debugRolls { rollHistory["trade"] = 1 }
        // start with a clean slate!
        tradeClassifications.removeAll()

        if internalAtmosphere >= 4 && internalAtmosphere <= 9 && internalHydrographics >= 4 &&
            internalHydrographics <= 8 && internalPopulation >= 5 && internalPopulation <= 7 {
            tradeClassifications.insert(.Ag)
        }

        if internalSize == 0 {
            tradeClassifications.insert(.As)
        }

        if internalPopulation == 0 && internalGovernment == 0 && internalLawLevel == 0 {
            tradeClassifications.insert(.Ba)
        }

        if internalHydrographics == 0 && internalAtmosphere >= 2 {
            tradeClassifications.insert(.De)
        }

        if internalAtmosphere >= 10 && internalHydrographics >= 1 {
            tradeClassifications.insert(.Fl)
        }

        if internalPopulation >= 9 {
            tradeClassifications.insert(.Hi)
        }

        if (internalAtmosphere == 0 || internalAtmosphere == 1) && internalHydrographics >= 1 {
            tradeClassifications.insert(.Ic)
        }

        if (internalAtmosphere <= 2 || internalAtmosphere == 4 || internalAtmosphere == 7 || internalAtmosphere == 9) && internalPopulation >= 9 {
            tradeClassifications.insert(.In)
        }

        if internalPopulation <= 3 {
            tradeClassifications.insert(.Lo)
        }

        if internalAtmosphere <= 3 && internalHydrographics <= 3 && internalPopulation >= 6 {
            tradeClassifications.insert(.Na)
        }

        if internalPopulation <= 6 {
            tradeClassifications.insert(.Ni)
        }

        if internalAtmosphere >= 2 && internalAtmosphere <= 5 && internalHydrographics <= 3 {
            tradeClassifications.insert(.Po)
        }

        if (internalAtmosphere == 6 || internalAtmosphere == 8) &&
            internalPopulation >= 6 && internalPopulation <= 8 &&
            internalGovernment >= 4 && internalGovernment <= 9 {
            tradeClassifications.insert(.Ri)
        }

        if internalAtmosphere == 0 {
            tradeClassifications.insert(.Va)
        }

        if internalHydrographics == 10 {
            tradeClassifications.insert(.Wa)
        }

    }

}
func == (left: Planet, right: Planet) -> Bool {
    left.uwp == right.uwp && left.stellarOrbit == right.stellarOrbit && left.depth == right.depth
}
func != (left: Planet, right: Planet) -> Bool {
    !(left == right)
}
