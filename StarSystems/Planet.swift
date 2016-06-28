//
//  Planet.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation

extension String {
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
        case .Ag: return "Agricultural"
        case .As: return "Asteroid Belt"
        case .Ba: return "Barren World"
        case .De: return "Desert World"
        case .Fl: return "Fluid Oceans"
        case .Hi: return "High Population"
        case .Ic: return "Ice-capped"
        case .In: return "Industrial"
        case .Lo: return "Low Population"
        case .Na: return "Non-Agricultural"
        case .Ni: return "Non-Industrial"
        case .Po: return "Poor"
        case .Ri: return "Rich"
        case .Va: return "Vacuum World"
        case .Wa: return "Water World"
        }
    }
}

class Planet: Satellite, CustomStringConvertible {
// the following really belong to the system, not the planet.
    var coordinateX:Int=0
    var coordinateY:Int=0
    var gasGiant: Bool = false
    var planetoids: Bool = false

    let sName     = "name"
    let sCoords   = "coords"
    let sStarport = "starport"
    let sSize     = "size"
    let sAtm      = "atm"
    let sHyd      = "hyd"
    let sPop      = "pop"
    let sGov      = "gov"
    let sLaw      = "law"
    let sTech     = "tech"
    let sNaval    = "naval"
    let sScout    = "scout"
    let sGas      = "gas"
    let sTC       = "tc"
    
    
    
    // the following are legitimately planet-centric.
    var starport: String = " "
    var navalBase: Bool = false
    var scoutBase: Bool = false
    let maxPlanetNameLength = 8 // this lets names fit on the map!
    var name: String?
    var size: Int = 0
    var atmosphere: Int = 0
    var hydrographics: Int = 0
    var population: Int = 0
    var government: Int = 0
    var lawLevel: Int = 0
    var technologicalLevel: Int = 0
    var tradeClassifications = Set<TradeClass>()
    var facilities = Set<Facility>()
    var facilitiesStr: String {
        get
        {
            var result = ""
            var first = true
            for f in facilities {
                if first { first = false } else { result += ", " }
                result += f.description
            }
            return result
        }
    }
    var shortTradeClassifications: String {get {
        var tcs = ""
        var first = true
        for tc in tradeClassifications {
            if first { first = false } else { tcs += ", " }
            tcs += tc.rawValue
        }
        return tcs
        }
    }
    var longTradeClassifications: String {get {
        var tcs = ""
        var first = true
        for tc in tradeClassifications {
            if first { first = false } else { tcs += ", " }
            tcs += tc.description
        }
        return tcs
        }
    }
    
    let d = Dice()
    
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
        self.name = (fromJSON[sName] as? String)!
        self.starport = (fromJSON[sStarport] as? String)!
        self.size = (fromJSON[sSize] as? Int)!
        self.atmosphere = (fromJSON[sAtm] as? Int)!
        self.hydrographics = (fromJSON[sHyd] as? Int)!
        self.population = (fromJSON[sPop] as? Int)!
        self.government = (fromJSON[sGov] as? Int)!
        self.lawLevel = (fromJSON[sLaw] as? Int)!
        self.technologicalLevel = (fromJSON[sTech] as? Int)!
        self.navalBase = (fromJSON[sNaval] as? Bool)!
        self.scoutBase = (fromJSON[sScout] as? Bool)!
        self.gasGiant = (fromJSON[sGas] as? Bool)!
        let coord = (fromJSON[sCoords] as? [String:Int])!
        self.coordinateX = coord["x"]!
        self.coordinateY = coord["y"]!
        setTradeClassifications()
    }
    
    //    override init() {
    //        super.init()
    //    }
    
    var description: String {
        var bases : String = ""
        if navalBase {bases += " N"} else {bases += "  "}
        if scoutBase {bases += " S"} else {bases += "  "}
        if gasGiant {bases += " G"} else {bases += "  "}
        var result = ""
        if name != nil { result += name!.padding(maxPlanetNameLength) + " " }
        if coordinateX != 0 && coordinateY != 0 {
            result += String(format:"%02d%02d", arguments:[coordinateX, coordinateY])
            result += " "
        }
        result += uwp
        result += "\(bases) \(shortTradeClassifications) \(facilitiesStr)"
        if satellites.orbits.count > 0 {
            result += "\n"
            result += "\(satDesc)"
        }
        return result
    }
    var uwp: String {
        return String(format:"%@%@%1X%1X%1X%1X%1X-%1X",arguments:[starport,getSize(),atmosphere,hydrographics,population,government,lawLevel,technologicalLevel])
    }
    
    var pdfDescription: String {
        return String(format:"(%@)Tj 60 0 Td (%02d%02d)Tj 40 0 Td (%@%@%1X%1X%1X%1X%1X-%1X)Tj 70 0 Td (%@)Tj 20 0 Td (%@)Tj 20 0 Td (%@)Tj 20 0 Td (%@)Tj -230 -12 Td",arguments:[name!,coordinateX,coordinateY,starport,getSize(),atmosphere,hydrographics,population,government,lawLevel,technologicalLevel,navalBase ? "N" : "",scoutBase ? "S" : "",gasGiant ? "G" : "",shortTradeClassifications])
    }
    
    var xml: String {
        return "<planet>\n <\(sName)>\(name)</\(sName)>\n <\(sCoords)>\n  <x>\(coordinateX)</x>\n  <y>\(coordinateY)</y>\n </\(sCoords)>\n <\(sStarport)>\(starport)</\(sStarport)>\n <\(sSize)>\(size)</\(sSize)>\n <\(sAtm)>\(atmosphere)</\(sAtm)>\n <\(sHyd)>\(hydrographics)</\(sHyd)>\n <\(sPop)>\(population)</\(sPop)>\n <\(sGov)>\(government)</\(sGov)>\n <\(sLaw)>\(lawLevel)</\(sLaw)>\n <\(sTech)>\(technologicalLevel)</\(sTech)>\n <\(sNaval)>\(navalBase)</\(sNaval)>\n <\(sScout)>\(scoutBase)</\(sScout)>\n <\(sGas)>\(gasGiant)</\(sGas)>\n <\(sTC)>\(shortTradeClassifications)</\(sTC)>\n</planet>\n"
    }
    
    var json: String {
        var result = "{\n"
        result += " \"\(sName)\": \"\(name)\",\n"
        result += " \"\(sCoords)\": {\n"
        result += "  \"x\": \(coordinateX),\n"
        result += "  \"y\": \(coordinateY)\n"
        result += " },\n"
        result += " \"\(sStarport)\": \"\(starport)\",\n"
        result += " \"\(sSize)\": \(getSize()),\n"
        result += " \"\(sAtm)\": \(atmosphere),\n"
        result += " \"\(sHyd)\": \(hydrographics),\n"
        result += " \"\(sPop)\": \(population),\n"
        result += " \"\(sGov)\": \(government),\n"
        result += " \"\(sLaw)\": \(lawLevel),\n"
        result += " \"\(sTech)\": \(technologicalLevel),\n"
        result += " \"\(sNaval)\": \(navalBase),\n"
        result += " \"\(sScout)\": \(scoutBase),\n"
        result += " \"\(sGas)\": \(gasGiant),\n"
        result += " \"\(sTC)\": \"\(shortTradeClassifications)\"\n"
        result += "}"
        return result
    }
    
    convenience init(upp: String, scoutBase: Bool, navalBase: Bool, gasGiant: Bool) {
        self.init()
        self.scoutBase = scoutBase
        self.navalBase = navalBase
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
        self.navalBase = navalBase
        self.scoutBase = scoutBase
        self.gasGiant = gasGiant
        // determine trade classifications
        setTradeClassifications()
    }
    
    func generateRandomPlanet(planetoid: Bool = false) {
        let nameGen : Name = Name(maxLength:maxPlanetNameLength)
        name = nameGen.description
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
        size = d.roll(2) - 2
        // calculate atmosphere
        if size == 0 {
            atmosphere = 0
        } else {
            atmosphere = d.roll(2) - 7 + size
        }
        if atmosphere < 0 { atmosphere = 0 }
        // calculate hydrographics
        if size <= 1 {
            hydrographics = 0
        } else {
            hydrographics = d.roll(2) - 7 + atmosphere
            if atmosphere <= 1 || atmosphere >= 10 {
                hydrographics = hydrographics - 4
            }
        }
        if hydrographics < 0 {hydrographics = 0}
        if hydrographics > 10 {hydrographics = 10}
        //calculate population
        population = d.roll(2) - 2
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
        if planetoid {
            size = 0
        } else {
            if parent is Star {
                // calculate size
                let dm:Int = (orbit == 0 ? -5 : 0) + (orbit == 1 ? -4 : 0) + (orbit == 2 ? -2 : 0) + (starType == StarType.M ? -2 : 0)
                size = d.roll(2) - 2 + dm
                if size <= 0 { size = -1 }
            } else {
                if parent is Planet {
                    size = (parent as! Planet).size - d.roll()
                } else if parent is GasGiant {
                    if (parent as! GasGiant).size == .Large {
                        size = d.roll(2) - 4
                    } else {
                        size = d.roll(2) - 6
                    }
                }
                if size < 0 { size = -1 }
                if size == 0 { size = -2 }
            }
        }
        if size < 1 {
            atmosphere = 0
        } else {
            atmosphere = d.roll(2) - 7 + size
            if zone == Zone.I { atmosphere -= 2 }
            if parent is Planet || parent is GasGiant { atmosphere -= 2 }
            if zone == Zone.O { atmosphere -= 4 }
        }
        if atmosphere < 0 { atmosphere = 0 }
        
        if size <= 0 || zone == Zone.I || (size <= 1 && parent is Star) {
            hydrographics = 0
        } else {
            hydrographics = d.roll(2) - 7 + atmosphere
            if zone == Zone.O { hydrographics -= 2 }
            if atmosphere <= 1 || atmosphere >= 10 {
                hydrographics = hydrographics - 4
            }
        }
        if hydrographics < 0 {hydrographics = 0}
        if hydrographics > 10 {hydrographics = 10}
        
        population = d.roll(2) - 2
        if zone == Zone.I { population -= 5 }
        if parent is Star && zone == Zone.O { population -= 3 }
        if parent is Planet && zone == Zone.O { population -= 4 }
        if atmosphere != 5 && atmosphere != 6 && atmosphere != 8 { population -= 2 }
        if size == -2 { population = 0 }
        if parent is Planet && size >= -1 && size <= 4 { population -= 2 }
        if population < 0 { population = 0 } // also need to make sure it's not > main world
        
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
    
    func rollStarport() {
        switch(d.roll(2)) {
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
        navalBase = (starport < "C" && d.roll(2) >= 8)
    }
    
    func rollScoutBase() {
        if (starport < "E") {
            var dm :Int = 0
            switch(starport) {
            case "A": dm = -3
            case "B": dm = -2
            case "C": dm = -1
            default: dm = 0
            }
            scoutBase = (d.roll(2) + dm >= 7)
        }
    }
    
    func rollGasGiant() {
        gasGiant = (d.roll(2) <= 9)
    }
    
    func rollPlanetoids() {
        planetoids = (d.roll(2) <= 6)
    }
    
    func rollGovernment() {
        government = d.roll(2) - 7 + population
        if government < 0 {government = 0}
    }
    
    func rollLawLevel() {
        lawLevel = d.roll(2) - 7 + government
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
        technologicalLevel = d.roll(1) + dm
        if technologicalLevel < 0 {technologicalLevel = 0}
        if technologicalLevel > 15 {technologicalLevel = 15}
    }
    
    func setFacilities(mainWorld: Planet) {
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
        switch d.roll() + (population >= 6 ? 2 : 0) - (population == 1 ? 2 : 0) - (population == 0 ? 3 : 0){
        case -2...2: starport = "Y"
        case 3: starport = "H"
        case 4,5: starport = "G"
        default: starport = "F"
        }
    }
    
    func setSatelliteAttribs(mainWorld: Planet) {
        var dm = 0
        if size > 0 {
            if mainWorld.government == 6 { government = mainWorld.government }
            else {
                if mainWorld.government >= 7 { dm = 1 }
                switch d.roll() + dm {
                case 1: government = 0
                case 2: government = 1
                case 3: government = 2
                case 4: government = 3
                default: government = 6
                }
            }
            if government == 0 { lawLevel = 0 }
            else { lawLevel = d.roll() - 3 + mainWorld.lawLevel }
            if lawLevel < 0 { lawLevel = 0 }
        }
        setFacilities(mainWorld)
        if facilities.contains(.MilitaryBase) || facilities.contains(.ResearchLaboratory) {
            technologicalLevel = mainWorld.technologicalLevel
        } else {
            technologicalLevel = mainWorld.technologicalLevel - 1
        }
        
    }
    
    func setTradeClassifications() {
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
    
    var fullDescription:String {
        return "Starport: \(starport) (\(starportDescription))\n" +
            "Naval Base: \(navalBase ? "present" : "absent")\n" +
            "Scout Base: \(scoutBase ? "present" : "absent")\n" +
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
    
}
func ==(left:Planet, right:Planet)->Bool {
    return left.uwp == right.uwp && left.orbit == right.orbit && left.depth == right.depth
}
func !=(left:Planet, right:Planet)->Bool {
    return !(left==right)
}
