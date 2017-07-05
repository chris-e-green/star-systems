//
//  Subsector.swift
//  StarSystems
//
//  Created by Christopher Green on 3/06/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation

class Subsector  {
    var planets = [Planet]()
    var starSystems = [StarSystem]()
    var name: String = ""
    var xml: String {
        var x: String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        x += "<\(jsonLabels.subsector)>\n"
        x += "<\(jsonLabels.name)>\n"
        x += name
        x += "</\(jsonLabels.name)>\n"
        for p in planets {
                x += p.xml
        }
        x += "</\(jsonLabels.subsector)>\n"
        return x
    }
    var json: String {
        var j: String = "{\n\"\(jsonLabels.subsector)\": "
        j += "[\n"
        for (x, p) in planets.enumerated() {
            j += p.json
            if x < planets.count - 1 {
                j += ",\n"
            } else {
                j += "\n"
            }
        }
        j += "]\n}\n"
        return j
    }
    var json2: String {
        var j: String = "{\n\"\(jsonLabels.subsector)\": [\n"
        for (x, s) in starSystems.enumerated() {
            j += s.json
            if x < starSystems.count - 1 {
                j += ",\n"
            } else {
                j += "\n"
            }
        }
        j += "]\n}\n"
        return j
    }
    
    func generatePdf(_ filename: String, starSysPrint: Bool = false) {
        let pdf : Pdf = Pdf()
        pdf.start()
        if starSysPrint {
            for s in starSystems {
                pdf.display(s)
            }
        } else {
            for p in planets {
                pdf.display(p)
            }
        }
        pdf.end()
        do {
            let fn = NSString(string:filename).expandingTildeInPath
            print("Writing PDF to \(fn)")
            try pdf.pdfContent.write(toFile: fn, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("EXCEPTION: \(error) writing \(pdf.pdfContent)")
        }
    }
    
    func populateStarSystems() {
        for p in planets {
            let ss = StarSystem(newWorld: p)
            ss.subsectorName = name
            starSystems.append(ss)
        }
    }
    
    func serialize(_ filename:String) {
        do {
            let fn = NSString(string:filename).expandingTildeInPath
            print("Writing XML to \(fn)")
            try xml.write(toFile: fn, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("EXCEPTION: \(error) writing XML file.")
        }
    }
    
    func writeJson(_ filename:String) {
        do {
            let fn = NSString(string:filename).expandingTildeInPath
            print("Writing JSON to \(fn)")
            try json.write(toFile: fn, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("EXCEPTION: \(error) writing JSON file.")
        }
        
    }
    func writeJson2(_ filename:String) {
        do {
            let fn = NSString(string:filename).expandingTildeInPath
            print("Writing JSON to \(fn)")
            try json2.write(toFile: fn, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("EXCEPTION: \(error) writing JSON file.")
        }
        
    }
    init(xml:String) {
        let parser = XMLParser(stream: InputStream(fileAtPath: xml)!)
        parser.parse()
    }
    
    init(jsonFilename: String) {
        do {
            let jsonStream = InputStream(fileAtPath: jsonFilename)
            jsonStream?.open()
            let jsonData = try JSONSerialization.jsonObject(with: jsonStream!, options: JSONSerialization.ReadingOptions()) as! [String:AnyObject]
            jsonStream?.close()
            if let jsonSubsector = jsonData["\(jsonLabels.subsector)"] as? [[String:AnyObject]] {
                for jsonPlanet in jsonSubsector {
                    planets.append(Planet(fromJSON:jsonPlanet))
                }
            }
        } catch {
            print("Error parsing JSON data \(error)")
        }
    }
    
    init(density:Int) {
        let d : Dice = Dice(sides:6)

        for x in 1...8 {
            for y in 1...10 {
                if d.roll() <= density {
                    let planet = Planet(coordX:x,coordY:y)
                    planets.append(planet)
                }
            }
        }
        name = String(describing: Name(maxLength: 8))
    }
}
