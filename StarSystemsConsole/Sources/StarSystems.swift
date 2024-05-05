//
//  main.swift
//  StarSystems
//
//  Created by Christopher Green on 24/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//
//  The Traveller game in all forms is owned by Far Future Enterprises.
//  Copyright 1977 - 2008 Far Future Enterprises.
//

import Foundation
import StarSystemsCommon
import ArgumentParser

@main
struct StarSystems: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Generate planets, star sytems and subsectors using  classic Traveller rules.",
        subcommands: [basicPlanet.self, subsector.self, fromJson.self, basicStar.self, RTTWorldGen.self, fromUWP.self],
        defaultSubcommand: basicPlanet.self
    )
}

struct Options: ParsableArguments {
    @Flag(name: [.long, .customShort("x")], help: "generate expanded details")
    var expanded = false
    
}
extension StarSystems {
    struct basicPlanet: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Generates a basic planet.")
        
        @OptionGroup var options: StarSystemsConsole.Options
        
        mutating func run() {
            print("Generating basic system from scratch")
            let planet =  Planet()
            planet.generateRandomPlanet()
            print(planet)
        }
    }
    
    struct subsector: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Generates a subsector to PDF/XML/JSON.")
        
        @OptionGroup var options: StarSystemsConsole.Options

        @Argument(help: "Subsector density (1..5) out of 6")
        var density: Int
        
        @Argument(help: "PDF, JSON, XML.")
        var format: String
        
        @Argument(help: "Output file name (will have format appended as extension)")
        var filename: String
        
        mutating func run() {
            if density > 5 || density < 1 {
                print("sorry, that density makes no sense.")
                abort()
            }
            format = format.lowercased()
            if (format != "pdf" && format != "xml" && format != "json") {
                abort()
            }
            let subsector: Subsector = Subsector(density: density)
            if options.expanded { subsector.populateStarSystems() }
            switch format {
            case "pdf": subsector.generatePdf(filename.appending("." + format), starSysPrint: options.expanded)
            case "xml": subsector.serialize(filename.appending("." + format))
            case "json": subsector.writeJson(filename.appending("." + format))
            default:
                print("Unknown output format")
            }
        }
    }
    
    struct fromJson: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Load a subsector from {file1}.json and generate {file2}.pdf")
        
        @OptionGroup var options: StarSystemsConsole.Options

        @Argument(help: "Input JSON file")
        var jsonFilename: String
        
        @Argument(help: "Output PDF file")
        var pdfFilename: String
        
        @Flag(name: [.long, .customShort("o")], help: "Regenerate and rewrite input JSON file (to recalculate trade classifications)")
        var overwrite = false
       
        mutating func run() {
                let subsector: Subsector = Subsector(jsonFilename: jsonFilename)
                if options.expanded {
                    subsector.populateStarSystems()
                    subsector.writeJson2("testing2.json")
                }
                if options.expanded {
                    subsector.generatePdf(pdfFilename, starSysPrint: true)
                } else {
                    subsector.generatePdf(pdfFilename)
                }
                if overwrite {
                    subsector.writeJson(jsonFilename)
                }
        }
    }
    
    struct basicStar: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Generates a full star system from scratch.")
        
        mutating func run() {
            print("Generating system from scratch")
            let star: StarSystem = StarSystem()
            print(star)
        }
    }
    
    struct RTTWorldGen: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Generates a system using RTT Worldgen rules.")
        
        @Flag(name: [.long, .customShort("v")], help: "displays a verbose system description.")
        var verbose = false
        
        mutating func run() {
            print("Generating system using RTTWorldGen")
            let rtt = RTTSystem()
            if verbose { print(rtt.verboseDesc) } else { print(rtt) }
        }
    }
    
    struct fromUWP: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Generates a full star system from an existing planet.")
        
        @Argument(help: "sets the planetary profile, where UWPString is formatted A123456-7")
        var upp: String
        
        @Option(name: [.long, .customShort("c")], help: "optional coordinates in format x,y")
        var coords: String?
        
        @Option(help: "Optional name of the planet, otherwise one will be generated.")
        var name: String?
        
        @Option(name: [.long, .customShort("j")], help: "Optional JSON filename to write.")
        var jsonFilename: String?
        
        @Flag(name: [.long, .customShort("n")], help: "a naval base is present")
        var navalBase = false
        
        @Flag(name: [.long, .customShort("s")], help: "a scout base is present")
        var scoutBase = false
        
        @Flag(name: [.long, .customShort("g")], help: "a gas giant is present")
        var gasGiant = false
        
        mutating func run() {
            print("Generating system from UWP")
            let planet = Planet.init(upp: upp, scoutBase: scoutBase, navalBase: navalBase, gasGiant: gasGiant)
            if name != nil { planet.name = name! }
            if coords != nil {
                if let coordParts = coords?.components(separatedBy: ",") {
                    planet.coordinateX = Int(coordParts[0])!
                    planet.coordinateY = Int(coordParts[1])!
                }
            }
            print("Generating from existing planet \(planet)")
            //            print (planet)
            let starSystem = StarSystem(newWorld: planet)
            print(starSystem)
            if let filename = jsonFilename {
                let jsonF = JsonFile(jsonFilename: filename)
                jsonF.writeJson(starSystem.json)
            }
        }
    }
}
