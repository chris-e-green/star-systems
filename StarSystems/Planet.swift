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

enum TradeClass: Int {
    case Ag = 0
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
    func simpleDescription()->String {
        switch self {
        case .Ag: return "Ag"
        case .As: return "As"
        case .Ba: return "Ba"
        case .De: return "De"
        case .Fl: return "Fl"
        case .Hi: return "Hi"
        case .Ic: return "Ic"
        case .In: return "In"
        case .Lo: return "Lo"
        case .Na: return "Na"
        case .Ni: return "Ni"
        case .Po: return "Po"
        case .Ri: return "Ri"
        case .Va: return "Va"
        case .Wa: return "Wa"
        }
    }
    func longDescription()->String {
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
    let maxPlanetNameLength = 8 // this lets names fit on the map!
    var name: String = ""
    var starport: String = " "
    var navalBase: Bool = false
    var scoutBase: Bool = false
    var gasGiant: Bool = false
    var planetoids: Bool = false
    var size: Int = 0
    var atmosphere: Int = 0
    var hydrographics: Int = 0
    var population: Int = 0
    var government: Int = 0
    var lawLevel: Int = 0
    var technologicalLevel: Int = 0
    var tradeClassifications = Set<TradeClass>()
    var shortTradeClassifications: String {get {
        var tcs = ""
        var first = true
        for tc in tradeClassifications {
            if first { first = false } else { tcs += ", " }
            tcs += tc.simpleDescription()
        }
        return tcs
        }
    }
    var longTradeClassifications: String {get {
        var tcs = ""
        var first = true
        for tc in tradeClassifications {
            if first { first = false } else { tcs += ", " }
            tcs += tc.longDescription()
        }
        return tcs
        }
    }
    let d = Dice(sides:6)
    
    override init() {
        let nameGen : Name = Name(maxLength:maxPlanetNameLength)
        name = nameGen.description
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
    
    func generateRandomPlanet(orbit: Int, starType: StarType, zone: Zone) {
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
        rollSize()
        // calculate atmosphere
        rollAtmosphere()
        // calculate hydrographics
        rollHydrographics()
        //calculate population
        rollPopulation()
        // calculate government
        rollGovernment()
        // calculate law level
        rollLawLevel()
        // calculate tech level
        rollTechLevel()
        // determine trade classifications
        setTradeClassifications()
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
    
    func sizeDescription()->String {
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
    
    func starportDescription()->String {
        switch(starport) {
        case "A": return "Excellent quality with refined fuel, overhaul, shipyards"
        case "B": return "Good quality with refined fuel, overhaul, shipyards for non-starships"
        case "C": return "Routine quality with unrefined fuel, some repair facilities"
        case "D": return "Poor quality with unrefined fuel; no repair facilities"
        case "E": return "Frontier installation; no facilities"
        case "X": return "No starport. Generally a red travel zone"
        default: return ""
        }
    }
    
    func atmosphereDescription()->String {
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
    
    func hydrographicsDescription()->String {
        switch hydrographics {
        case 0: return "No free standing water"
        case 1..<10: return "\(hydrographics*10)% water"
        case 10: return "No land masses"
        default: return ""
        }
    }
    
    func populationDescription()->String {
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
    
    func governmentDescription()->String {
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
    
    func lawLevelDescription()->String {
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
    
    func techLevelDescription()->String {
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
    
    var description: String {
        var bases: String = ""
        if navalBase {bases += " N"} else {bases += "  "}
        if scoutBase {bases += " S"} else {bases += "  "}
        if gasGiant {bases += " G"} else {bases += "  "}
        return String(format:"%@ %@%1X%1X%1X%1X%1X%1X-%1X%@ %@",arguments:[name.padding(maxPlanetNameLength),starport,size,atmosphere,hydrographics,population,government,lawLevel,technologicalLevel,bases,shortTradeClassifications])
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
    
    func rollSize() {
        size = d.roll(2) - 2
    }
    
    func rollAtmosphere() {
        if size == 0 {
            atmosphere = 0
        } else {
            atmosphere = d.roll(2) - 7 + size
        }
        if atmosphere < 0 { atmosphere = 0 }
    }
    
    func rollHydrographics() {
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
    }
    
    func rollPopulation() {
        population = d.roll(2) - 2
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
        case 0..<2: dm += 2
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
    
    func setTradeClassifications() {
//        var tc  : String = ""
//        var stc : String = ""
        
        if atmosphere >= 4 && atmosphere <= 9 && hydrographics >= 4 &&
            hydrographics <= 8 && population >= 5 && population <= 7 {
            tradeClassifications.insert(.Ag)
//           tc += "Agricultural "
//            stc += "Ag "
        }
        
        if size == 0 {
            tradeClassifications.insert(.As)
//            tc += "Asteroid Belt "
//            stc += "As "
        }
        
        if population == 0 && government == 0 && lawLevel == 0 {
            tradeClassifications.insert(.Ba)
//            tc += "Barren World "
//            stc += "Ba "
        }
        
        if hydrographics == 0 && atmosphere >= 2 {
            tradeClassifications.insert(.De)
//            tc += "Desert World "
//            stc += "De "
        }
        
        if atmosphere >= 10 && hydrographics >= 1 {
            tradeClassifications.insert(.Fl)
//            tc += "Fluid Oceans "
//            stc += "Fl "
        }
        
        if population >= 9 {
            tradeClassifications.insert(.Hi)
//            tc += "High Population "
//            stc += "Hi "
        }
        
        if (atmosphere == 0 || atmosphere == 1) && hydrographics >= 1 {
            tradeClassifications.insert(.Ic)
//            tc += "Ice-capped "
//            stc += "Ic "
        }
        
        if (atmosphere <= 2 || atmosphere == 4 || atmosphere == 7 || atmosphere == 9) && population >= 9 {
            tradeClassifications.insert(.In)
//            tc += "Industrial "
//            stc += "In "
        }
        
        if (population <= 3) {
            tradeClassifications.insert(.Lo)
//            tc += "Low Population "
//            stc += "Lo "
        }
        
        if atmosphere <= 3 && hydrographics <= 3 && population >= 6 {
            tradeClassifications.insert(.Na)
//            tc += "Non-Agricultural "
//            stc += "Na "
        }
        
        if population <= 6 {
            tradeClassifications.insert(.Ni)
//            tc += "Non-Industrial "
//            stc += "Ni "
        }
        
        if atmosphere >= 2 && atmosphere <= 5 && hydrographics <= 3 {
            tradeClassifications.insert(.Po)
//            tc += "Poor "
//            stc += "Po "
        }
        
        if (atmosphere == 6 || atmosphere == 8) && population >= 6 && population <= 8 && government >= 4 && government <= 9 {
            tradeClassifications.insert(.Ri)
//            tc += "Rich "
//            stc += "Ri "
        }
        
        if atmosphere == 0 {
            tradeClassifications.insert(.Va)
//            tc += "Vacuum World "
//            stc += "Va "
        }
        
        if hydrographics == 10 {
            tradeClassifications.insert(.Wa)
//            tc += "Water World "
//           stc += "Wa "
        }
        
//        longTradeClassifications=tc
//        shortTradeClassifications=stc
    }
    
    var fullDescription:String {
        return "Starport: \(starport) (\(starportDescription()))\n" +
            "Naval Base: \(navalBase ? "present" : "absent")\n" +
            "Scout Base: \(scoutBase ? "present" : "absent")\n" +
            "Gas Giant: \(gasGiant ? "present" : "absent")\n" +
            "Planetoids: \(planetoids ? "present" : "absent")\n" +
            "Size: \(size) (\(sizeDescription()))\n" +
            "Atmosphere: \(atmosphere) (\(atmosphereDescription()))\n" +
            "Hydrographics: \(hydrographics) (\(hydrographicsDescription()))\n" +
            "Population: \(population) (\(populationDescription()))\n" +
            "Government: \(government) (\(governmentDescription()))\n" +
            "Law Level: \(lawLevel) (\(lawLevelDescription()))\n" +
            "Tech Level: \(technologicalLevel) (\(techLevelDescription()))\n" +
            "Trade classifications: \(longTradeClassifications)"
    }
    
}
