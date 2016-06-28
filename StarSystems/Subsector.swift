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
    var xml: String {
        var x: String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        x += "<subsector>\n"
        for p in planets {
                x += p.xml
        }
        x += "</subsector>\n"
        return x
    }
    var json: String {
        var j: String = "{\n\"subsector\": [\n"
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
    func generatePdf(filename: String) {
        let pdf : Pdf = Pdf()
        pdf.start()
        for p in planets {
            pdf.display(p)
        }
        pdf.end()
        do {
            print("Writing PDF to \(filename)")
            try pdf.pdfContent.writeToFile(filename, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            print(pdf.pdfContent)
        }
    }
    
    func serialize(filename:String) {
        do {
            print("Writing XML to \(filename)")
            try xml.writeToFile(filename, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            print("Error writing XML file.")
        }
    }
    
    func writeJson(filename:String) {
        do {
            print("Writing JSON to \(filename)")
            try json.writeToFile(filename, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            print("Error writing JSON file.")
        }
        
    }
    init(xml:String) {
        let parser = NSXMLParser(stream: NSInputStream(fileAtPath: xml)!)
        parser.parse()
    }
    
    init(json: String) {
        do {
            let ins = NSInputStream(fileAtPath: json)
            ins?.open()
            let data = try NSJSONSerialization.JSONObjectWithStream(ins!, options: NSJSONReadingOptions())
            ins?.close()
            if let ss = data["subsector"] as? [[String:AnyObject]] {
                for p in ss {
                    planets.append(Planet(fromJSON:p))
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
    }
}
