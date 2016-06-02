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

convenience init(coordX:Int, coordY:Int) {
  self.init()
  coordinateX = coordX
  coordinateY = coordY
}

override init() {
        super.init()
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
   
override  var description: String {
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
        return "<planet>\n <name>\(name)</name>\n <coords>\n  <x>\(coordinateX)</x>\n  <y>\(coordinateY)</y>\n </coords>\n <starport>\(starport)</starport>\n <size>\(size)</size>\n <atm>\(atmosphere)</atm>\n <hyd>\(hydrographics)</hyd>\n <pop>\(population)</pop>\n <gov>\(government)</gov>\n <law>\(lawLevel)</law>\n <tech>\(technologicalLevel)</tech>\n <naval>\(navalBase)</naval>\n <scout>\(scoutBase)</scout>\n <gas>\(gasGiant)</gas>\n <tc>\(shortTradeClassifications)</tc>\n</planet>\n"
    }
}

