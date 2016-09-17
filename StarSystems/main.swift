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
    print("\(Process.arguments[0]) -u=UWP [-n] [-s] [-g] [-c=x,y] [-N=name]")
    print("\tGenerates a full star system from an existing planet.")
    print("\t-u=UWP sets the planetary profile, formatted A123456-7")
    print("\t-n if a naval base is present, -s if a scout base is present,")
    print("\t-g if a gas giant is present")
    print("\t-c=x,y sets optional coordinates")
    print("\t-N=name sets the name of the planet, otherwise one will be generated.")
    print()
    print("\(Process.arguments[0]) -f")
    print("\tGenerates a full star system from scratch.")
    print()
    print("\(Process.arguments[0]) -b")
    print("\tGenerates a basic planet.")
    print()
    print("\(Process.arguments[0]) -r [-v]")
    print("\tGenerates a system using RTT Worldgen rules.")
    print("\t-v displays verbose system description.")
    print()
    print("\(Process.arguments[0]) -s [-x] {density} [file1.pdf] [file2.xml] [file3.json]")
    print("\tGenerates a subsector to PDF/XML/JSON.")
    print("\twhere density is 1..5, and represents chance out of 6")
    print("\tsupplying filenames will produce file1.pdf, file2.xml, file3.json.")
    print("\tIf -x is specified, expanded star system details will be generated")
   print("\(Process.arguments[0]) -j [-o] [-x] file1.json file2.pdf")
    print("\tLoad a subsector from file1.json and generate file2.pdf")
    print("\tIf -o is specified, file1.json is rewritten (mainly to recalculate")
    print("\ttrade classifications).")
    print("\tIf -x is specified, expanded star system details will be generated")
}

var planet:Planet

if Process.argc > 1 {
    let param1:String = Process.arguments[1]
    let choice = param1[param1.startIndex...param1.startIndex.advancedBy(1)]
    switch choice {
    case "-b":
        print("Generating basic system")
        var planet =  Planet()
        planet.generateRandomPlanet()
        print(planet)
        print(planet.xml)
    case "-s":
        var density = 3
//        var path = "test"
        var xmlfn:String?
        var jsonfn:String?
        var pdffn:String?
        var expand = false
        for fn in Process.arguments {
            if fn.containsString(".xml") {
                xmlfn = fn
            }
            if fn.containsString(".json") {
                jsonfn = fn
            }
            if fn.containsString(".pdf") {
                pdffn = fn
            }
            if let d = Int(fn) {
                density = d
            }
            if fn == "-x" {
                expand = true
            }
        }
        if density > 5 || density < 1 {
            print("sorry, that density makes no sense.")
            abort()
        }
        let subsector: Subsector = Subsector(density: density)
        if expand {
            subsector.populateStarSystems()
        }
        if pdffn != nil { subsector.generatePdf(pdffn!, starSysPrint: true) }
        if xmlfn != nil { subsector.serialize(xmlfn!) }
        if jsonfn != nil { subsector.writeJson(jsonfn!) }

    case "-j":
        var path = "test.json"
        var jsonfn:String?
        var pdffn:String?
        var rewrite = false
        var expand = false
        for fn in Process.arguments {
            if fn == "-o" {
                rewrite = true
            }
            if fn == "-s" {
                expand = true
            }
            if fn.containsString(".json") {
                jsonfn = fn
            }
            if fn.containsString(".pdf") {
                pdffn = fn
            }
        }
        if jsonfn != nil {
            let subsector: Subsector = Subsector(jsonFilename: jsonfn!)
            if expand {
                subsector.populateStarSystems()
                subsector.writeJson2("testing2.json")
            }
            if pdffn != nil {
                if expand {
                    subsector.generatePdf(pdffn!, starSysPrint: true)
                } else {
                    subsector.generatePdf(pdffn!)
                }
                if rewrite {
                    subsector.writeJson(jsonfn!)
                }
            } else {
                print("well I can read a JSON file and write it again but did you want anything else?")
            }
        } else {
            print("A JSON file name must be supplied.")
        }


    case "-f":
        print("Generating system from scratch")
        let star : StarSystem = StarSystem()
        print(star)
    case "-r":
        print("Generating system using RTTWorldGen")
        var verbose = false
        for fn in Process.arguments {
            switch fn[fn.startIndex...fn.startIndex.advancedBy(1)] {
            case "-v": verbose = true
            default: break
            }
        }
        let rtt = RTTSystem()
        if verbose {
            print(rtt.verboseDesc)
        } else {
            print(rtt)
        }
    case "-u":
        var navalBase = false
        var scoutBase = false
        var gasGiant = false
        var coords : String?
        var upp: String?
        var name: String?
        var json: Bool = false
        var jsonFile: String?
        for fn in Process.arguments {
            switch fn[fn.startIndex...fn.startIndex.advancedBy(1)] {
            case "-n": navalBase = true
            case "-s": scoutBase = true
            case "-g": gasGiant = true
            case "-c": coords = fn[fn.startIndex.advancedBy(3)...fn.endIndex.advancedBy(-1)]
            case "-u":
                upp = fn[fn.startIndex.advancedBy(3)...fn.endIndex.advancedBy(-1)]
            case "-N":
                name = fn[fn.startIndex.advancedBy(3)...fn.endIndex.advancedBy(-1)]
            case "-j":
                json = true
                jsonFile = fn[fn.startIndex.advancedBy(3)...fn.endIndex.advancedBy(-1)]
            default: break
            }
        }
        if upp != nil {
            planet = Planet.init(upp: upp!, scoutBase: scoutBase, navalBase: navalBase, gasGiant: gasGiant)
            if name != nil {
                planet.name = name!
            }
            if coords != nil {
                let xcoord = coords![coords!.startIndex...coords!.rangeOfString(",")!.startIndex.advancedBy(-1)]
                let ycoord = coords![coords!.rangeOfString(",")!.endIndex...coords!.endIndex.advancedBy(-1)]
                planet.coordinateX = Int(xcoord)!
                planet.coordinateY = Int(ycoord)!
            }
            print("Generating from existing planet \(planet)")
//            print (planet)
            let starSystem = StarSystem(newWorld: planet)
            print(starSystem)
            if json {
                if let fn = jsonFile {
                    let jsonF = JsonFile(jsonFilename: fn)
                    jsonF.writeJson(starSystem.json)
                } else {
                    print("Error with filename \(jsonFile)")
                }
            } 
        } else {
            print("the UWP must be supplied!")
            printSyntax()
        }
    default:
        printSyntax()
    }
} else { printSyntax() }
