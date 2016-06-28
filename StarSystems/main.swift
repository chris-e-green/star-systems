//
//  main.swift
//  StarSystems
//
//  Created by Christopher Green on 24/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation

func printSyntax() {
    print("\(Process.arguments[0]) -u=UWP [-n] [-s] [-g] [-c=x,y] [-N=name]")
    print("where UWP is the planetary profile, formatted A123456-7")
    print("\t-n if a naval base is present, -s if a scout base is present, -g if a gas giant is present")
    print("\tx and y are optional coordinates")
    print("\tname is the optional name of the planet; one will be generated if it is not supplied")
    print("\tGenerate a full star system from existing planet")
    print()
    print("\(Process.arguments[0]) -f")
    print("\tGenerate a full star system from scratch")
    print()
    print("\(Process.arguments[0]) -b")
    print("\tGenerate basic planet")
    print()
    print("\(Process.arguments[0]) -r")
    print("\tGenerate a system using RTT Worldgen rules")
    print()
    print("\(Process.arguments[0]) -s {density} [file1.pdf] [file2.xml] [file3.json]")
    print("\tGenerate a subsector to PDF/XML/JSON")
    print("\twhere density is 1..5, and represents chance out of 6")
    print("\tsupplying filenames will produce file1.pdf, file2.xml, file3.json")
    print("\(Process.arguments[0]) -j [-o] file1.json file2.pdf")
    print("\tLoad a subsector from file1.json and generate file2.pdf")
    print("\tIf -o is specified, file1.json is rewritten (fixes up trade classifications)")
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
        }
        if density > 5 || density < 1 {
            print("sorry, that density makes no sense.")
            abort()
        }
        let subsector: Subsector = Subsector(density: density)
        if pdffn != nil { subsector.generatePdf(pdffn!) }
        if xmlfn != nil { subsector.serialize(xmlfn!) }
        if jsonfn != nil { subsector.writeJson(jsonfn!) }

    case "-j":
        var path = "test.json"
        var jsonfn:String?
        var pdffn:String?
        var rewrite = false
        for fn in Process.arguments {
            if fn == "-o" {
                rewrite = true
            }
            if fn.containsString(".json") {
                jsonfn = fn
            }
            if fn.containsString(".pdf") {
                pdffn = fn
            }
        }
        if jsonfn != nil {
            let subsector: Subsector = Subsector(json: jsonfn!)
            if pdffn != nil {
                subsector.generatePdf(pdffn!)
                if rewrite {
                    subsector.writeJson(jsonfn!)
                }
            } else {
                print("well I can read a JSON file but I don't know what to do with it.")
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
        let rtt = RTTSystem()
        print(rtt)
    case "-u":
        var navalBase = false
        var scoutBase = false
        var gasGiant = false
        var coords : String?
        var upp: String?
        var name: String?
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
            print (planet)
            let starSystem = StarSystem(newWorld: planet)
            print(starSystem)
        } else {
            print("the UWP must be supplied!")
            printSyntax()
        }
    default:
        printSyntax()
    }
} else { printSyntax() }
