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
        for (x, p) in planets.enumerate() {
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
        for (x, s) in starSystems.enumerate() {
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
    
    func generatePdf(filename: String, starSysPrint: Bool = false) {
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
            print("Writing PDF to \(filename)")
            try pdf.pdfContent.writeToFile(filename, atomically: true, encoding: NSUTF8StringEncoding)
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
    
    func serialize(filename:String) {
        do {
            print("Writing XML to \(filename)")
            try xml.writeToFile(filename, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            print("EXCEPTION: \(error) writing XML file.")
        }
    }
    
    func writeJson(filename:String) {
        do {
            print("Writing JSON to \(filename)")
            try json.writeToFile(filename, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            print("EXCEPTION: \(error) writing JSON file.")
        }
        
    }
    func writeJson2(filename:String) {
        do {
            print("Writing JSON to \(filename)")
            try json2.writeToFile(filename, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            print("EXCEPTION: \(error) writing JSON file.")
        }
        
    }
    init(xml:String) {
        let parser = NSXMLParser(stream: NSInputStream(fileAtPath: xml)!)
        parser.parse()
    }
    
    init(jsonFilename: String) {
        do {
            let jsonStream = NSInputStream(fileAtPath: jsonFilename)
            jsonStream?.open()
            let jsonData = try NSJSONSerialization.JSONObjectWithStream(jsonStream!, options: NSJSONReadingOptions())
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
        name = String(Name(maxLength: 8))
    }
}
