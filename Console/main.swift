//
//  main.swift
//  StarSystems
//
//  Created by Christopher Green on 24/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation

// global constant for debugging purposes. Set to false if debug info not wanted.
let DEBUG=false

func printSyntax() {
    print("\(CommandLine.arguments[0]) -type basicPlanet | subsector | processJson | basicStar | RTTWorldGen | fromUWP [options]")
    print()
    print("\t-type basicPlanet")
    print("\t\tGenerates a basic planet.")
    print()
    print("\t-type subsector -density {density} [-expanded YES|NO] [-pdf {file1}.pdf] [-xml {file2}.xml] [-json {file3}.json]")
    print("\t\tGenerates a subsector to PDF/XML/JSON.")
    print("\t\twhere density is 1..5, and represents chance out of 6")
    print("\t\tsupplying filenames will produce file1.pdf, file2.xml, file3.json.")
    print("\tIf -expanded is specified, expanded star system details will be generated")
    print()
    print("\t-type processJson [-overwrite YES|NO] [-expanded YES|NO] -json file1.json -pdf file2.pdf")
    print("\t\tLoad a subsector from {file1}.json and generate {file2}.pdf")
    print("\t\tIf -overwrite YES is specified, {file1}.json is rewritten (mainly to recalculate")
    print("\t\ttrade classifications).")
    print("\t\tIf -expanded YES is specified, expanded star system details will be generated")
    print()
    print("\t-type basicStar")
    print("\t\tGenerates a full star system from scratch.")
    print()
    print("\t-type RTTWorldGen [-verbose YES|NO]")
    print("\t\tGenerates a system using RTT Worldgen rules.")
    print("\t\t-verbose YES displays a verbose system description.")
    print()
    print("\t-type fromUWP")
    print("-UWP {UWPString} [-navalBase YES|NO] [-scoutBase YES|NO] [-gasGiant YES|NO] [-coords x,y] [-name {name}]")
    print("\t\tGenerates a full star system from an existing planet.")
    print("\t\t-UWP UWPString sets the planetary profile, where UWPString is formatted A123456-7")
    print("\t\t-navalBase YES if a naval base is present")
    print("\t\t-scoutBase YES if a scout base is present")
    print("\t\t-gasGiant YES if a gas giant is present")
    print("\t\t-coords x,y sets optional coordinates")
    print("\t\t-name {name} sets the name of the planet, otherwise one will be generated.")
    print()
}

var planet:Planet

var cmdLineOpts:UserDefaults = UserDefaults.standard;

let expanded = cmdLineOpts.bool(forKey: "expanded")
let density = cmdLineOpts.integer(forKey: "density")
let xmlfn:String? = cmdLineOpts.string(forKey: "xml")
let jsonfn:String? = cmdLineOpts.string(forKey: "json")
let pdffn:String? = cmdLineOpts.string(forKey: "pdf")
let overwrite = cmdLineOpts.bool(forKey: "overwrite")
let verbose = cmdLineOpts.bool(forKey: "verbose")
let navalBase = cmdLineOpts.bool(forKey: "navalBase")
let scoutBase = cmdLineOpts.bool(forKey: "scoutBase")
let gasGiant = cmdLineOpts.bool(forKey: "gasGiant")
let coords = cmdLineOpts.string(forKey: "coords")
let upp = cmdLineOpts.string(forKey: "UWP")
let name = cmdLineOpts.string(forKey: "name")

if let type = cmdLineOpts.string(forKey: "type") {
    switch type {
    case "basicPlanet":
        print("Generating basic system from scratch")
        let planet =  Planet()
        planet.generateRandomPlanet()
        print(planet)
    case "basicStar":
        print("Generating system from scratch")
        let star : StarSystem = StarSystem()
        print(star)
    case "subsector":
        if density > 5 || density < 1 {
            print("sorry, that density makes no sense.")
            abort()
        }
        let subsector: Subsector = Subsector(density: density)
        if expanded { subsector.populateStarSystems() }
        if pdffn != nil { subsector.generatePdf(pdffn!, starSysPrint: expanded) }
        if xmlfn != nil { subsector.serialize(xmlfn!) }
        if jsonfn != nil { subsector.writeJson(jsonfn!) }
    case "processJson":
        if jsonfn != nil {
            let subsector: Subsector = Subsector(jsonFilename: jsonfn!)
            if expanded {
                subsector.populateStarSystems()
                subsector.writeJson2("testing2.json")
            }
            if pdffn != nil {
                if expanded {
                    subsector.generatePdf(pdffn!, starSysPrint: true)
                } else {
                    subsector.generatePdf(pdffn!)
                }
                if overwrite {
                    subsector.writeJson(jsonfn!)
                }
            } else {
                print("well I can read a JSON file and write it again but did you want anything else?")
            }
        } else {
            print("A JSON file name must be supplied.")
        }
    case "RTTWorldGen":
        print("Generating system using RTTWorldGen")
        let rtt = RTTSystem()
        if verbose { print(rtt.verboseDesc) }
        else { print(rtt) }
    case "fromUWP":
        print("Generating system from UWP")
        if upp != nil {
            planet = Planet.init(upp: upp!, scoutBase: scoutBase, navalBase: navalBase, gasGiant: gasGiant)
            if name != nil { planet.name = name! }
            if coords != nil {
                if let coordParts = coords?.components(separatedBy:",") {
                    planet.coordinateX = Int(coordParts[0])!
                    planet.coordinateY = Int(coordParts[1])!
                }
            }
            print("Generating from existing planet \(planet)")
            //            print (planet)
            let starSystem = StarSystem(newWorld: planet)
            print(starSystem)
            if let fn = jsonfn {
                let jsonF = JsonFile(jsonFilename: fn)
                jsonF.writeJson(starSystem.json)
            }
        } else {
            print("The UWP must be supplied when generating from UWP!")
            printSyntax()
        }
    default:
        printSyntax()
    }
} else {
    printSyntax()
}

