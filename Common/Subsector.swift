//
//  Subsector.swift
//  StarSystems
//
//  Created by Christopher Green on 3/06/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//
//  The Traveller game in all forms is owned by Far Future Enterprises.
//  Copyright 1977 - 2008 Far Future Enterprises.
//

import Foundation

class Subsector: CustomStringConvertible {
    var planets = [Planet]()
    var starSystems = [StarSystem]()
    var name: String = ""

    var description: String {
        var result: String = ""
        result += "Subsector name: \(name)\n"

        if starSystems.count>0 {
            for starSystem in starSystems {
                result += "\(starSystem)\n"
            }
        } else {
            for planet in planets {
                result += "\(planet)\n"
            }
        }
        return result
    }

    var xml: String {
        var xmlTemp: String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        xmlTemp += "<\(JsonLabels.subsector)>\n"
        xmlTemp += "<\(JsonLabels.name)>\n"
        xmlTemp += name
        xmlTemp += "</\(JsonLabels.name)>\n"
        for planet in planets {
            xmlTemp += planet.xml
        }
        xmlTemp += "</\(JsonLabels.subsector)>\n"
        return xmlTemp
    }
    
    var json: String {
        var jsonTemp: String = "{\n\"\(JsonLabels.subsector)\": "
        jsonTemp += "[\n"
        for (planetIndex, planet) in planets.enumerated() {
            jsonTemp += planet.json
            if planetIndex < planets.count - 1 {
                jsonTemp += ",\n"
            } else {
                jsonTemp += "\n"
            }
        }
        jsonTemp += "]\n}\n"
        return jsonTemp
    }
    var json2: String {
        var jsonText: String = "{\n\"\(JsonLabels.subsector)\": [\n"
        for (starSystemIndex, starSystem) in starSystems.enumerated() {
            jsonText += starSystem.json
            if starSystemIndex < starSystems.count - 1 {
                jsonText += ",\n"
            } else {
                jsonText += "\n"
            }
        }
        jsonText += "]\n}\n"
        return jsonText
    }
    
    func generatePdf(_ filename: String, starSysPrint: Bool = false) {
        let pdf: Pdf = Pdf()
        pdf.start()
        if starSysPrint {
            for starSystem in starSystems {
                pdf.display(starSystem)
            }
        } else {
            for planet in planets {
                pdf.display(planet)
            }
        }
        pdf.end()
        do {
            let expandedFilename = NSString(string: filename).expandingTildeInPath
            print("Writing PDF to \(expandedFilename)")
            try pdf.pdfContent.write(toFile: expandedFilename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("EXCEPTION: \(error) writing \(pdf.pdfContent)")
        }
    }
    
    func populateStarSystems() {
        for planet in planets {
            let starSystem = StarSystem(newWorld: planet)
            starSystem.subsectorName = name
            starSystems.append(starSystem)
        }
    }
    
    func serialize(_ filename: String) {
        do {
            let expandedFilename = NSString(string: filename).expandingTildeInPath
            print("Writing XML to \(expandedFilename)")
            try xml.write(toFile: expandedFilename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("EXCEPTION: \(error) writing XML file.")
        }
    }
    
    func writeJson(_ filename: String) {
        do {
            let expandedFilename = NSString(string: filename).expandingTildeInPath
            print("Writing JSON to \(expandedFilename)")
            try json.write(toFile: expandedFilename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("EXCEPTION: \(error) writing JSON file.")
        }
        
    }
    func writeJson2(_ filename: String) {
        do {
            let expandedFilename = NSString(string: filename).expandingTildeInPath
            print("Writing JSON to \(expandedFilename)")
            try json2.write(toFile: expandedFilename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("EXCEPTION: \(error) writing JSON file.")
        }
        
    }
    init(xml: String) {
        let parser = XMLParser(stream: InputStream(fileAtPath: xml)!)
        parser.parse()
    }
    
    init(jsonFilename: String) {
        do {
            let jsonStream = InputStream(fileAtPath: jsonFilename)
            jsonStream?.open()
            if let jsonData = try JSONSerialization.jsonObject(with: jsonStream!, options: JSONSerialization.ReadingOptions()) as? [String: AnyObject] {
                if let jsonSubsector = jsonData["\(JsonLabels.subsector)"] as? [[String: AnyObject]] {
                    for jsonPlanet in jsonSubsector {
                        planets.append(Planet(fromJSON: jsonPlanet))
                    }
                }
            }
            jsonStream?.close()
        } catch {
            print("Error parsing JSON data \(error)")
        }
    }

    init(density: Int, withStarSystems: Bool = false) {
        let die: Dice = Dice(sides: 6)

        for xCoord in 1...8 {
            for yCoord in 1...10 {
                if die.roll() <= density {
                    let planet = Planet(coordX: xCoord, coordY: yCoord)
                    planets.append(planet)
                }
            }
        }
        name = String(describing: Name(maxLength: 8))
        if withStarSystems { populateStarSystems()}
    }
}
