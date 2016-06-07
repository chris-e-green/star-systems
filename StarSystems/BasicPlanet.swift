//
//  BasicPlanet.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation


class BasicPlanet : Planet {
    var coordinateX:Int=0
    var coordinateY:Int=0
    
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
    
    convenience init(coordX:Int, coordY:Int) {
        self.init()
        coordinateX = coordX
        coordinateY = coordY
        generateRandomPlanet()
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
    
    override init() {
        super.init()
    }
    
    override var description: String {
        var bases : String = ""
        if navalBase {bases += " N"} else {bases += "  "}
        if scoutBase {bases += " S"} else {bases += "  "}
        if gasGiant {bases += " G"} else {bases += "  "}
        return String(format:"%@ %02d%02d %@%1X%1X%1X%1X%1X%1X-%1X%@ %@",arguments:[name.padding(8),coordinateX,coordinateY,starport,size,atmosphere,hydrographics,population,government,lawLevel,technologicalLevel,bases,shortTradeClassifications])
    }
    var pdfDescription: String {
        return String(format:"(%@)Tj 60 0 Td (%02d%02d)Tj 40 0 Td (%@%1X%1X%1X%1X%1X%1X-%1X)Tj 70 0 Td (%@)Tj 20 0 Td (%@)Tj 20 0 Td (%@)Tj 20 0 Td (%@)Tj -230 -12 Td",arguments:[name,coordinateX,coordinateY,starport,size,atmosphere,hydrographics,population,government,lawLevel,technologicalLevel,navalBase ? "N" : "",scoutBase ? "S" : "",gasGiant ? "G" : "",shortTradeClassifications])
    }
    var xml: String {
        return "<planet>\n <\(sName)>\(name)</\(sName)>\n <\(sCoords)>\n  <x>\(coordinateX)</x>\n  <y>\(coordinateY)</y>\n </\(sCoords)>\n <\(sStarport)>\(starport)</\(sStarport)>\n <\(sSize)>\(size)</\(sSize)>\n <\(sAtm)>\(atmosphere)</\(sAtm)>\n <\(sHyd)>\(hydrographics)</\(sHyd)>\n <\(sPop)>\(population)</\(sPop)>\n <\(sGov)>\(government)</\(sGov)>\n <\(sLaw)>\(lawLevel)</\(sLaw)>\n <\(sTech)>\(technologicalLevel)</\(sTech)>\n <\(sNaval)>\(navalBase)</\(sNaval)>\n <\(sScout)>\(scoutBase)</\(sScout)>\n <\(sGas)>\(gasGiant)</\(sGas)>\n <\(sTC)>\(shortTradeClassifications)</\(sTC)>\n</planet>\n"
    }
    
    var json: String {
        var j = "{\n"
        j += " \"\(sName)\": \"\(name)\",\n"
        j += " \"\(sCoords)\": {\n"
        j += "  \"x\": \(coordinateX),\n"
        j += "  \"y\": \(coordinateY)\n"
        j += " },\n"
        j += " \"\(sStarport)\": \"\(starport)\",\n"
        j += " \"\(sSize)\": \(size),\n"
        j += " \"\(sAtm)\": \(atmosphere),\n"
        j += " \"\(sHyd)\": \(hydrographics),\n"
        j += " \"\(sPop)\": \(population),\n"
        j += " \"\(sGov)\": \(government),\n"
        j += " \"\(sLaw)\": \(lawLevel),\n"
        j += " \"\(sTech)\": \(technologicalLevel),\n"
        j += " \"\(sNaval)\": \(navalBase),\n"
        j += " \"\(sScout)\": \(scoutBase),\n"
        j += " \"\(sGas)\": \(gasGiant),\n"
        j += " \"\(sTC)\": \"\(shortTradeClassifications)\"\n"
        j += "}"
        return j
    }
}

