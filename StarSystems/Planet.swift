//
//  Planet.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation

extension String {
    // shorthand padding with spaces to a given length
    func padding(length: Int) -> String {
        return self.stringByPaddingToLength(length, withString: " ", startingAtIndex: 0)
    }
}

enum Facility: String, CustomStringConvertible {
    case Farming
    case Mining
    case Colony
    case ResearchLaboratory
    case MilitaryBase
    var description: String {
        switch self {
        case .ResearchLaboratory: return "Research Laboratory"
        case .MilitaryBase: return "Military Base"
        default: return self.rawValue
        }
    }
}

enum Base: String, CustomStringConvertible {
    case N
    case S
    case D
    case W
    var description: String {
        switch self {
        case .N:
            return "Naval Base"
        case .S:
            return "Scout Base"
        case .D:
            return "Naval Depot"
        case .W:
            return "Scout Way Station"
        }
    }
}

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
    var description:String {
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
}

class Planet: Satellite, CustomStringConvertible {
    // MARK: System-centric Variables
    var coordinateX:Int=0
    var coordinateY:Int=0
    var gasGiant: Bool = false
    var planetoids: Bool = false
    
    // MARK: Planet-centric Variables
    var starport: String = " "
//    var navalBase: Bool = false
//    var scoutBase: Bool = false
    var bases = Set<Base>()
    //    var name: String?
    var size: Int = 0
    var atmosphere: Int = 0
    var hydrographics: Int = 0
    var population: Int = 0
    var government: Int = 0
    var lawLevel: Int = 0
    var technologicalLevel: Int = 0
    var debugRolls = false
    var rollHistory: [String:Int] = [:]
    var tradeClassifications = Set<TradeClass>()
    var facilities = Set<Facility>()
    
    let d = Dice()
    
    // MARK: Calculated Variables
    var facilitiesStr: String {
        get {
            var result = ""
            var first = true
            for f in facilities {
                if first { first = false } else { result += ", " }
                result += String(f)
            }
            return result
        }
    }
    var shortTradeClassifications: String {
        get {
            var tcs = ""
            var first = true
            for tc in tradeClassifications {
                if first { first = false } else { tcs += ", " }
                tcs += tc.rawValue
            }
            return tcs
        }
    }
    var longTradeClassifications: String {
        get {
            var tcs = ""
            var first = true
            for tc in tradeClassifications {
                if first { first = false } else { tcs += ", " }
                tcs += String(tc)
            }
            return tcs
        }
    }
    
    var description: String {
        var baseStr : String = ""
        //        if navalBase {bases += " N"} else {bases += "  "}
        //        if scoutBase {bases += " S"} else {bases += "  "}
        if gasGiant {baseStr += " G"} else {baseStr += "  "}
//        if facilities.contains(Facility.MilitaryBase) { bases += " M" } else { bases += "  " }
        if bases.contains(.N) && bases.contains(.S) { baseStr += " A" }
        else if bases.contains(.N) { baseStr += " N" }
        else if bases.contains(.S) { baseStr += " S" }
//        if navalBase {
//            if scoutBase { baseStr += " A" }
//            else { baseStr += " N" }
//        } else if scoutBase { baseStr += " S" }
        else if facilities.contains(Facility.MilitaryBase) { baseStr += " M" } else { baseStr += "  " }
        var result = ""
        result += name.padding(maxNameLength)
        if coordinateX != 0 && coordinateY != 0 {
            result += String(format:"%02d%02d", arguments:[coordinateX, coordinateY])
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
        return String(format:"%@%@%1X%1X%1X%1X%1X-%1X",arguments:[starport,getSize(),atmosphere,hydrographics,population,government,lawLevel,technologicalLevel])
    }
    
//    var pdfDescription: String {
//        return String(format:"(%@)Tj 60 0 Td (%02d%02d)Tj 40 0 Td (%@%@%1X%1X%1X%1X%1X-%1X)Tj 70 0 Td (%@)Tj 20 0 Td (%@)Tj 20 0 Td (%@)Tj 20 0 Td (%@)Tj -230 -12 Td",arguments:[name,coordinateX,coordinateY,starport,getSize(),atmosphere,hydrographics,population,government,lawLevel,technologicalLevel,bases.contains(.N) ? "N" : "",bases.contains(.S) ? "S" : "",gasGiant ? "G" : "",shortTradeClassifications])
//    }
    
    var xml: String {
        return "<planet>\n <\(jsonLabels.name)>\(name)</\(jsonLabels.name)>\n <\(jsonLabels.coords)>\n  <x>\(coordinateX)</x>\n  <y>\(coordinateY)</y>\n </\(jsonLabels.coords)>\n <\(jsonLabels.starport)>\(starport)</\(jsonLabels.starport)>\n <\(jsonLabels.size)>\(size)</\(jsonLabels.size)>\n <\(jsonLabels.atm)>\(atmosphere)</\(jsonLabels.atm)>\n <\(jsonLabels.hyd)>\(hydrographics)</\(jsonLabels.hyd)>\n <\(jsonLabels.pop)>\(population)</\(jsonLabels.pop)>\n <\(jsonLabels.gov)>\(government)</\(jsonLabels.gov)>\n <\(jsonLabels.law)>\(lawLevel)</\(jsonLabels.law)>\n <\(jsonLabels.tech)>\(technologicalLevel)</\(jsonLabels.tech)>\n <\(jsonLabels.naval)>\(bases.contains(.N) ? "N" : "")</\(jsonLabels.naval)>\n <\(jsonLabels.scout)>\(bases.contains(.S) ? "S" : "")</\(jsonLabels.scout)>\n <\(jsonLabels.gas)>\(gasGiant)</\(jsonLabels.gas)>\n <\(jsonLabels.tc)>\(shortTradeClassifications)</\(jsonLabels.tc)>\n</planet>\n"
    }
    
    override var json: String {
        var result = "\"\(jsonLabels.planet)\": {\n"
        result += " \"\(jsonLabels.name)\": \"\(name)\",\n"
        if parent == nil {
            // coordinates only make sense when planet=system so only add them when we have no parent star/gg.
            result += " \"\(jsonLabels.coords)\": {\n"
            result += "  \"x\": \(coordinateX),\n"
            result += "  \"y\": \(coordinateY)\n"
            result += " },\n"
        }
        result += " \"\(jsonLabels.starport)\": \"\(starport)\",\n"
        result += " \"\(jsonLabels.size)\": \"\(getSize())\",\n"
        result += " \"\(jsonLabels.atm)\": \(atmosphere),\n"
        result += " \"\(jsonLabels.hyd)\": \(hydrographics),\n"
        result += " \"\(jsonLabels.pop)\": \(population),\n"
        result += " \"\(jsonLabels.gov)\": \(government),\n"
        result += " \"\(jsonLabels.law)\": \(lawLevel),\n"
        result += " \"\(jsonLabels.tech)\": \(technologicalLevel),\n"
        result += " \"\(jsonLabels.naval)\": \(bases.contains(.N)),\n"
        result += " \"\(jsonLabels.scout)\": \(bases.contains(.S)),\n"
        if parent == nil {
            // gas giant only makes sense when planet=system so only add it when we have no parent star/gg.
            result += " \"\(jsonLabels.gas)\": \(gasGiant),\n"
        }
        result += " \"\(jsonLabels.tc)\": \"\(shortTradeClassifications)\",\n"
        result += " \"\(jsonLabels.fac)\": \"\(facilitiesStr)\"\n"
        result += "}"
        return result
    }
    
    var sizeDescription:String {
        switch size {
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
    
    var starportDescription:String {
        switch(starport) {
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
    
    
    var atmosphereDescription:String {
        switch atmosphere {
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
    
    var hydrographicsDescription:String {
        switch hydrographics {
        case 0: return "No free standing water"
        case 1..<10: return "\(hydrographics*10)% water"
        case 10: return "No land masses"
        default: return ""
        }
    }
    
    var populationDescription:String {
        switch population {
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
    
    var governmentDescription:String {
        switch government {
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
    
    var lawLevelDescription:String {
        switch lawLevel {
        case 0: return "No prohibitions"
        case 1: return "Body pistols undetectable by standard detectors, explosives (bombs, grenades), and poison gas prohibited"
        case 2: return "Portable energy weapons (laser carbine, laser rifle) prohibited. Ship's gunnery not affected"
        case 3: return "Weapons of a strict military nature (machine guns, automatic rifles) prohibited"
        case 4: return "Light assault weapons (sub-machineguns) prohibited"
        case 5: return "Personal concealable firearms (pistols, revolvers) prohibited"
        case 6: return "Most firearms (all except shotguns) prohibited. The carrying of any type of weapon openly is discouraged"
        case 7: return "Shotguns are prohibited"
        case 8: return "Long bladed weapons (all but daggers) are controoled, and open possession is prohibited"
        case 9: return "Possession of any weapon outside one's residence is prohibited"
        default:return "Weapon possession is prohibited"
        }
    }
    
    var techLevelDescription:String {
        switch technologicalLevel {
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
    
    var fullDescription:String {
        return "Starport: \(starport) (\(starportDescription))\n" +
            "Naval Base: \(bases.contains(.N) ? "present" : "absent")\n" +
            "Scout Base: \(bases.contains(.S) ? "present" : "absent")\n" +
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
    convenience init(coordX:Int, coordY:Int) {
        self.init()
        coordinateX = coordX
        coordinateY = coordY
        generateRandomPlanet()
    }
    
    convenience init(orbit: Float, starType: StarType, zone: Zone, planetoid: Bool = false, parent: Satellite?) {
        self.init(parent:parent)
        generateRandomPlanet(orbit, starType: starType, zone: zone, planetoid: planetoid)
    }
    
    convenience init(fromJSON:[String:AnyObject]) {
        self.init()
        self.name = (fromJSON["\(jsonLabels.name)"] as? String)!
        self.starport = (fromJSON["\(jsonLabels.starport)"] as? String)!
        let sz = fromJSON["\(jsonLabels.size)"]
        if sz is String {
            self.setSize((fromJSON["\(jsonLabels.size)"] as? String)!)
        } else { // support 'legacy' number type.
            self.size = (fromJSON[jsonLabels.size.rawValue] as? Int)!
        }
        self.atmosphere = (fromJSON["\(jsonLabels.atm)"] as? Int)!
        self.hydrographics = (fromJSON["\(jsonLabels.hyd)"] as? Int)!
        self.population = (fromJSON["\(jsonLabels.pop)"] as? Int)!
        self.government = (fromJSON["\(jsonLabels.gov)"] as? Int)!
        self.lawLevel = (fromJSON["\(jsonLabels.law)"] as? Int)!
        self.technologicalLevel = (fromJSON["\(jsonLabels.tech)"] as? Int)!
        let n = (fromJSON["\(jsonLabels.naval)"] as? Bool)!
        if n { bases.insert(.N) }
        let s = (fromJSON["\(jsonLabels.scout)"] as? Bool)!
        if s { bases.insert(.S) }
        self.gasGiant = (fromJSON["\(jsonLabels.gas)"] as? Bool)!
        let coord = (fromJSON["\(jsonLabels.coords)"] as? [String:Int])!
        self.coordinateX = coord["x"]!
        self.coordinateY = coord["y"]!
        setTradeClassifications()
    }
    
    convenience init(upp: String, scoutBase: Bool, navalBase: Bool, gasGiant: Bool) {
        self.init()
        if scoutBase { bases.insert(.S) }
        if navalBase { bases.insert(.N) }
        self.gasGiant = gasGiant
        var uppIndex = 0
        for x in upp.characters {
            switch uppIndex {
            case 0: starport = String(x)
            case 1: size = Int(String(x), radix: 16) ?? 0
            case 2: atmosphere = Int(String(x), radix: 16) ?? 0
            case 3: hydrographics = Int(String(x), radix: 16) ?? 0
            case 4: population = Int(String(x), radix: 16) ?? 0
            case 5: government = Int(String(x), radix: 16) ?? 0
            case 6: lawLevel = Int(String(x), radix: 16) ?? 0
            case 8: technologicalLevel = Int(String(x), radix: 16) ?? 0
            default: break
            }
            uppIndex = uppIndex + 1
        }
        // determine trade classifications
        setTradeClassifications()
    }
    
    convenience init(starport: String, size: Int, atmosphere: Int, hydrographics: Int, population: Int, government: Int, lawLevel: Int, techLevel: Int, navalBase: Bool, scoutBase: Bool, gasGiant: Bool) {
        self.init()
        self.starport = starport
        self.size = size
        self.atmosphere = atmosphere
        self.hydrographics = hydrographics
        self.population = population
        self.government = government
        self.lawLevel = lawLevel
        self.technologicalLevel = techLevel
        if navalBase { bases.insert(.N) }
        if scoutBase { bases.insert(.S) }
        self.gasGiant = gasGiant
        // determine trade classifications
        setTradeClassifications()
    }
    
    // MARK: Functions
    func generateRandomPlanet(planetoid: Bool = false) {
        if debugRolls { rollHistory["from_scratch"] = 1 }
        let nameGen : Name = Name(maxLength:maxNameLength)
        var roll = 0
        name = String(nameGen)
        //generate starport
        rollStarport()
        //generate naval base
        rollNavalBase()
        //generate scout base
        rollScoutBase()
        //check for gas giants
        rollGasGiant()
        //check for planetoids
        rollPlanetoids()
        // calculate size
        roll = d.roll(2)
        if debugRolls { rollHistory["size"] = roll }
        size = roll - 2
        // calculate atmosphere
        if size == 0 {
            atmosphere = 0
        } else {
            roll = d.roll(2)
            if debugRolls { rollHistory["atm"] = roll }
            atmosphere = roll - 7 + size
        }
        if atmosphere < 0 { atmosphere = 0 }
        // calculate hydrographics
        if size <= 1 {
            hydrographics = 0
        } else {
            roll = d.roll(2)
            if debugRolls { rollHistory["hyd"] = roll }
            hydrographics = roll - 7 + atmosphere
            if atmosphere <= 1 || atmosphere >= 10 {
                hydrographics = hydrographics - 4
            }
        }
        if hydrographics < 0 {hydrographics = 0}
        if hydrographics > 10 {hydrographics = 10}
        //calculate population
        roll = d.roll(2)
        if debugRolls { rollHistory["pop"] = roll }
        population = roll - 2
        // calculate government
        rollGovernment()
        // calculate law level
        rollLawLevel()
        // calculate tech level
        rollTechLevel()
        // determine trade classifications
        setTradeClassifications()
    }
    
    func generateRandomPlanet(orbit: Float, starType: StarType, zone: Zone, planetoid: Bool = false) {
        if debugRolls { rollHistory["from_star"] = 1 }
        var roll = 0
        if planetoid {
            size = 0
        } else {
            if parent is Star {
                // calculate size
                let dm:Int = (orbit == 0 ? -5 : 0) + (orbit == 1 ? -4 : 0) + (orbit == 2 ? -2 : 0) + (starType == StarType.M ? -2 : 0)
                roll = d.roll(2)
                if debugRolls { rollHistory["size"] = roll }
                size = roll - 2 + dm
                if size <= 0 { size = -1 }
            } else {
                if parent is Planet {
                    roll = d.roll()
                    if debugRolls { rollHistory["pl_sat_size"] = roll }
                    size = (parent as! Planet).size - roll
                } else if parent is GasGiant {
                    if (parent as! GasGiant).size == .Large {
                        roll = d.roll(2)
                        if debugRolls { rollHistory["gg_sat_size"] = roll }
                        size = roll - 4
                    } else {
                        roll = d.roll(2)
                        if debugRolls { rollHistory["gg_sat_size"] = roll }
                        size = roll - 6
                    }
                }
                if size < 0 { size = -1 }
                if size == 0 { size = -2 }
            }
        }
        if size < 1 {
            atmosphere = 0
        } else {
            roll = d.roll(2)
            if debugRolls { rollHistory["atm"] = roll }
            atmosphere = roll - 7 + size
            if zone == Zone.I { atmosphere -= 2 }
            if parent is Planet || parent is GasGiant { atmosphere -= 2 }
            if zone == Zone.O { atmosphere -= 4 }
        }
        if atmosphere < 0 { atmosphere = 0 }
        
        if size <= 0 || zone == Zone.I || (size <= 1 && parent is Star) {
            hydrographics = 0
        } else {
            roll = d.roll(2)
            if debugRolls { rollHistory["hyd"] = roll }
            hydrographics = roll - 7 + atmosphere
            if zone == Zone.O { hydrographics -= 2 }
            if atmosphere <= 1 || atmosphere >= 10 {
                hydrographics = hydrographics - 4
            }
        }
        if hydrographics < 0 {hydrographics = 0}
        if hydrographics > 10 {hydrographics = 10}
        
        roll = d.roll(2)
        if debugRolls { rollHistory["pop"] = roll }
        population = roll - 2
        if zone == Zone.I { population -= 5 }
        if parent is Star && zone == Zone.O { population -= 3 }
        if parent is Planet && zone == Zone.O { population -= 4 }
        if atmosphere != 5 && atmosphere != 6 && atmosphere != 8 { population -= 2 }
        if size == -2 { population = 0 }
        if parent is Planet && size >= -1 && size <= 4 { population -= 2 }
        if population < 0 { population = 0 }
        // also need to make sure it's not > main world. Will do this elsewhere.
    }
    
    func checkPopulation(maxPopulation:Int) {
        if population >= maxPopulation {
            population = maxPopulation - 1
            if population < 0 { population = 0 }
        }
    }
    
    func getSize()->String {
        switch size {
        case -2: return "R"
        case -1: return "S"
        default: return String(format:"%1X",size)
        }
    }
    func setSize(newSize: String) {
        switch(newSize) {
        case "R": size = -2
        case "S": size = -1
        default: size = Int(newSize, radix: 16) ?? 0
        }
    }
    
    func rollStarport() {
        let roll = d.roll(2)
        if debugRolls { rollHistory["starport"] = roll }
        switch roll {
        case 2,3,4: starport="A"
        case 5,6:   starport="B"
        case 7,8:   starport="C"
        case 9:     starport="D"
        case 10,11: starport="E"
        case 12:    starport="X"
        default:    starport="?"
        }
    }
    
    func rollNavalBase() {
        let roll = d.roll(2)
        if debugRolls { rollHistory["naval"] = roll }
        if (starport < "C" && roll >= 8) { bases.insert(.N) }
    }
    
    func rollScoutBase() {
        let roll = d.roll(2)
        if debugRolls { rollHistory["scout"] = roll }
        if (starport < "E") {
            var dm :Int = 0
            switch(starport) {
            case "A": dm = -3
            case "B": dm = -2
            case "C": dm = -1
            default: dm = 0
            }
            if (roll + dm >= 7) { bases.insert(.S) }
        }
    }
    
    func rollGasGiant() {
        let roll = d.roll(2)
        if debugRolls { rollHistory["gas"] = roll }
        gasGiant = (roll <= 9)
    }
    
    func rollPlanetoids() {
        let roll = d.roll(2)
        if debugRolls { rollHistory["planetoids"] = roll }
        planetoids = (roll <= 6)
    }
    
    func rollGovernment() {
        if population > 0 {
            let roll = d.roll(2)
            if debugRolls { rollHistory["gov"] = roll }
            government = roll - 7 + population
            if government < 0 {government = 0}
        }
    }
    
    func rollLawLevel() {
        let roll = d.roll(2)
        if debugRolls { rollHistory["law"] = roll }
        lawLevel = roll - 7 + government
        if lawLevel < 0 {lawLevel = 0}
        if lawLevel > 15 {lawLevel = 15}
    }
    
    func rollTechLevel() {
        var dm : Int = 0
        switch(starport) {
        case "A": dm = 6
        case "B": dm = 4
        case "C": dm = 2
        case "X": dm = -4
        default: break
        }
        switch(size) {
        case -1..<2: dm += 2
        case 2..<5: dm += 1
        default: break
        }
        switch(atmosphere) {
        case 0..<4: dm += 1
        case 10..<15: dm += 1
        default: break
        }
        switch(hydrographics) {
        case 9: dm += 1
        case 10: dm += 2
        default: break
        }
        switch(population) {
        case 1..<6: dm += 1
        case 9: dm += 2
        case 10: dm += 4
        default: break
        }
        switch(government) {
        case 0: dm += 1
        case 5: dm += 1
        case 13: dm -= 2
        default: break
        }
        let roll = d.roll()
        if debugRolls { rollHistory["tech"] = roll }
        technologicalLevel = roll + dm
        
        // although not specifically stated in the rules, it is clear from the example systems given.
        if population == 0 { technologicalLevel = 0 }
        if technologicalLevel < 0 {technologicalLevel = 0}
        if technologicalLevel > 15 {technologicalLevel = 15}
    }
    
    func setFacilities(mainWorld: Planet) {
        if debugRolls { rollHistory["facilities"] = 1 }
        facilities.removeAll()
        if zone == Zone.H && atmosphere >= 4 && atmosphere <= 9 && hydrographics >= 4 && hydrographics <= 8 && population >= 2 {
            facilities.insert(.Farming)
        }
        if mainWorld.tradeClassifications.contains(.In) && population >= 2 {
            facilities.insert(.Mining)
        }
        if government == 6 && population >= 5 {
            facilities.insert(.Colony)
        }
        if mainWorld.technologicalLevel > 8 && population > 0 {
            if (d.roll(2) + mainWorld.technologicalLevel >= 10 ? 2 : 0) >= 11 {
                facilities.insert(.ResearchLaboratory)
            }
        }
        if !mainWorld.tradeClassifications.contains(.Po) && population > 0 {
            if d.roll(2) + (mainWorld.population >= 8 ? 1 : 0) + (mainWorld.atmosphere == atmosphere ? 2 : 0) >= 12 {
                facilities.insert(.MilitaryBase)
            }
        }
    }
    
    func setSatelliteAttribs(mainWorld: Planet) {
        if debugRolls { rollHistory["sat_attribs"] = 1 }
        var dm = 0
        var roll = 0
        if population > 0 {
            if mainWorld.government == 6 { government = mainWorld.government }
            else {
                if mainWorld.government >= 7 { dm = 1 }
                roll = d.roll()
                if debugRolls { rollHistory["sat_gov"] = roll }
                switch roll + dm {
                case 1: government = 0
                case 2: government = 1
                case 3: government = 2
                case 4: government = 3
                default: government = 6
                }
            }
            if government == 0 { lawLevel = 0 }
            else {
                roll = d.roll()
                if debugRolls { rollHistory["sat_law"] = roll }
                lawLevel = roll - 3 + mainWorld.lawLevel
            }
            if lawLevel < 0 { lawLevel = 0 }
            if lawLevel > 15 { lawLevel = 15 }
        } else { government = 0 }
        setFacilities(mainWorld)
        if facilities.contains(.MilitaryBase) || facilities.contains(.ResearchLaboratory) {
            technologicalLevel = mainWorld.technologicalLevel
        } else {
            technologicalLevel = mainWorld.technologicalLevel - 1
        }
        if population == 0 { technologicalLevel = 0 }
        if technologicalLevel < 0 { technologicalLevel = 0 }
        roll = d.roll()
        if debugRolls { rollHistory["spaceport"] = roll }
        switch roll + (population >= 6 ? 2 : 0) - (population == 1 ? 2 : 0) - (population == 0 ? 3 : 0){
        case -2...2: starport = "Y"
        case 3: starport = "H"
        case 4,5: starport = "G"
        default: starport = "F"
        }
        
    }
    
    func setTradeClassifications() {
        if debugRolls { rollHistory["trade"] = 1 }
        // start with a clean slate!
        tradeClassifications.removeAll()
        
        if atmosphere >= 4 && atmosphere <= 9 && hydrographics >= 4 &&
            hydrographics <= 8 && population >= 5 && population <= 7 {
            tradeClassifications.insert(.Ag)
        }
        
        if size == 0 {
            tradeClassifications.insert(.As)
        }
        
        if population == 0 && government == 0 && lawLevel == 0 {
            tradeClassifications.insert(.Ba)
        }
        
        if hydrographics == 0 && atmosphere >= 2 {
            tradeClassifications.insert(.De)
        }
        
        if atmosphere >= 10 && hydrographics >= 1 {
            tradeClassifications.insert(.Fl)
        }
        
        if population >= 9 {
            tradeClassifications.insert(.Hi)
        }
        
        if (atmosphere == 0 || atmosphere == 1) && hydrographics >= 1 {
            tradeClassifications.insert(.Ic)
        }
        
        if (atmosphere <= 2 || atmosphere == 4 || atmosphere == 7 || atmosphere == 9) && population >= 9 {
            tradeClassifications.insert(.In)
        }
        
        if (population <= 3) {
            tradeClassifications.insert(.Lo)
        }
        
        if atmosphere <= 3 && hydrographics <= 3 && population >= 6 {
            tradeClassifications.insert(.Na)
        }
        
        if population <= 6 {
            tradeClassifications.insert(.Ni)
        }
        
        if atmosphere >= 2 && atmosphere <= 5 && hydrographics <= 3 {
            tradeClassifications.insert(.Po)
        }
        
        if (atmosphere == 6 || atmosphere == 8) && population >= 6 && population <= 8 && government >= 4 && government <= 9 {
            tradeClassifications.insert(.Ri)
        }
        
        if atmosphere == 0 {
            tradeClassifications.insert(.Va)
        }
        
        if hydrographics == 10 {
            tradeClassifications.insert(.Wa)
        }
        
    }
    
    
}
func ==(left:Planet, right:Planet)->Bool {
    return left.uwp == right.uwp && left.orbit == right.orbit && left.depth == right.depth
}
func !=(left:Planet, right:Planet)->Bool {
    return !(left==right)
}
