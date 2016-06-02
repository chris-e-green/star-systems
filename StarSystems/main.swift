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
    print("\(Process.arguments[0]) -s {density} [outputfilebase]")
    print("\tGenerate a subsector to PDF/XML")
    print("\twhere density is 1..5")
    print("\t\t1 = 1 in 6 chance;")
    print("\t\t2 = 1 in 3 chance;")
    print("\t\t3 = 1 in 2 chance;")
    print("\t\t4 = 2 in 3 chance;")
    print("\t\t5 = 5 in 6 chance.")
    print("\n")
    print("\t\tsupplying outputfilebase will produce outputfilename.pdf and outputfilename.xml")
}
func createSubsector(density:Int, path:String) {
    let d : Dice = Dice(sides:6)
    let pdf : Pdf = Pdf()
    var ssxml: String = "<subsector>\n"
    
    pdf.start()
    for x in 1...8 {
        for y in 1...10 {
            if d.roll() <= density {
                let planet = BasicPlanet(coordX:x,coordY:y)
                ssxml += planet.xml
                pdf.display(planet)
            }
        }
    }
    pdf.end()
    ssxml += "</subsector>\n"
    do {
        print("Writing PDF to \(path + ".pdf")")
        try pdf.pdfContent.writeToFile(path + ".pdf", atomically: true, encoding: NSUTF8StringEncoding)
        print("Writing XML to \(path + ".xml")")
        try ssxml.writeToFile(path + ".xml", atomically: true, encoding: NSUTF8StringEncoding)
    } catch {
        print(pdf.pdfContent)
    }
    
}

var planet:Planet
if Process.argc > 1 {
    switch Process.arguments[1] {
    case "-b":
        print("Generating basic system")
        var planet : BasicPlanet = BasicPlanet()
        print(planet)
        print(planet.xml)
    case "-s":
        var density = 3
        var path = "test"
        if Process.argc >= 3 {
            density = Int(Process.arguments[2]) ?? 3
            if density > 5 || density < 1 {
                print("sorry, that density makes no sense.")
                abort()
            }
            if Process.argc == 4 {
                path = Process.arguments[3]
            }
        }
        createSubsector(density, path:path)
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
