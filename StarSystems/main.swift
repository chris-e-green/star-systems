//
//  main.swift
//  StarSystems
//
//  Created by Christopher Green on 24/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation

func printSyntax() {
    print("\(Process.arguments[0]) -u UPP S N G")
    print("where S=1 if scout base present, 0 if absent")
    print("      N=1 if naval base present, 0 if absent")
    print("      G=1 if gas giant present, 0 if absent")
    print("\tGenerate a full star system from existing planet")
    print()
    print("\(Process.arguments[0]) -f")
    print("\tGenerate a full star system from scratch")
    print("")
    print("\(Process.arguments[0]) -b")
    print("\tGenerate basic planet")
    print()
    print("\(Process.arguments[0]) -s {density} [file1.pdf] [file2.xml] [file3.json]")
    print("\tGenerate a subsector to PDF/XML/JSON")
    print("\twhere density is 1..5, and represents chance out of 6")
    print("\tsupplying filenames will produce file1.pdf, file2.xml, file3.json")
    print("\(Process.arguments[0]) -j [-o] file1.json file2.pdf")
    print("\tLoad a subsector from file1.json and generate file2.pdf")
    print("\tIf -o is specified, file1.json is rewritten (fixes up trade classifications)")
}

//func createSubsector(density:Int, path:String) {
//    let d : Dice = Dice(sides:6)
//    let pdf : Pdf = Pdf()
//    var ssxml: String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
////    ssxml += "<!DOCTYPE subsector [\n"
////    ssxml += "  <!ELEMENT subsector (planet*)>\n"
////    ssxml += "  <!ELEMENT planet (name, coords, starport, size, atm, hyd, pop, gov, law, tech, naval, scout, gas, tc)>\n"
////    ssxml += "  <!ELEMENT name (#PCDATA)>\n"
////    ssxml += "  <!ELEMENT coords (x, y)>\n"
////    ssxml += "  <!ELEMENT starport (#PCDATA)>\n"
////    ssxml += "  <!ELEMENT size (#PCDATA)>\n"
////    ssxml += "  <!ELEMENT atm (#PCDATA)>\n"
////    ssxml += "  <!ELEMENT hyd (#PCDATA)>\n"
////    ssxml += "  <!ELEMENT pop (#PCDATA)>\n"
////    ssxml += "  <!ELEMENT gov (#PCDATA)>\n"
////    ssxml += "  <!ELEMENT law (#PCDATA)>\n"
//    
//    ssxml += "<subsector>\n"
//    
//    pdf.start()
//    for x in 1...8 {
//        for y in 1...10 {
//            if d.roll() <= density {
//                let planet = BasicPlanet(coordX:x,coordY:y)
//                ssxml += planet.xml
//                pdf.display(planet)
//            }
//        }
//    }
//    pdf.end()
//    ssxml += "</subsector>\n"
//    do {
//        print("Writing PDF to \(path).pdf")
//        try pdf.pdfContent.writeToFile("\(path).pdf", atomically: true, encoding: NSUTF8StringEncoding)
//        print("Writing XML to \(path).xml")
//        try ssxml.writeToFile("\(path).xml", atomically: true, encoding: NSUTF8StringEncoding)
//    } catch {
//        print(pdf.pdfContent)
//    }
//    
//}

var planet:Planet
if Process.argc > 1 {
    switch Process.arguments[1] {
    case "-b":
        print("Generating basic system")
        var planet : BasicPlanet = BasicPlanet()
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
//        if Process.argc >= 3 {
//            density = Int(Process.arguments[2]) ?? 3
//            if density > 5 || density < 1 {
//                print("sorry, that density makes no sense.")
//                abort()
//            }
//            if Process.argc == 4 {
//                path = Process.arguments[3]
//            }
//        }
        // createSubsector(density, path:path)
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
    case "-u":
        if Process.argc == 6 {
            planet = Planet.init(upp: Process.arguments[2], scoutBase: Process.arguments[3] == "1" ? true : false, navalBase: Process.arguments[4] == "1" ? true : false, gasGiant: Process.arguments[5] == "1" ? true : false)
            
            print("Generating from existing planet \(planet)")
            print (planet)
            let star = StarSystem(planet: planet)
            print(star)
        } else { printSyntax() }
    default:
        printSyntax()
    }
} else { printSyntax() }
