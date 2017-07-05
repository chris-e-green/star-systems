//
//  JSON.swift
//  StarSystems
//
//  Created by Christopher Green on 2/07/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation


enum jsonLabels: String, CustomStringConvertible {
    case satellites
    case gasgiant
    // subsector labels
    case subsector
    //  Satellite labels
    case sat
    case orbit
    case name
    case sattype
    //  Planet labels
    case planet
    case coords
    case starport
    case size
    case atm
    case hyd
    case pop
    case gov
    case law
    case tech
    case naval
    case scout
    case gas
    case tc
    case fac
    // Star labels
    case star
    case type
    case decimal
    // size is used in both planet and star
    // Star System labels
    // coords is on star system where appropriate
    // Gas Giant labels
    var description: String {
        return self.rawValue
    }
}

class JsonFile {
    var jsonFilename:String?
    
    func writeJson(_ jsonData:String) {
        if let filename = jsonFilename {
            do {
                let fn = NSString(string:filename).expandingTildeInPath
                print("Writing JSON to \(fn)")
                try jsonData.write(toFile: fn, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print("Error writing JSON file. \(error)")
            }
        }
    }
    
    init(jsonFilename: String) {
        self.jsonFilename = jsonFilename
    }
    
    func readJson()->[[String:AnyObject]]? {
        if let filename = jsonFilename {
            do {
                let jsonStream = InputStream(fileAtPath: filename)
                jsonStream?.open()
                let jsonData = try JSONSerialization.jsonObject(with: jsonStream!, options: JSONSerialization.ReadingOptions())
                jsonStream?.close()
                return jsonData as? [[String:AnyObject]]
            } catch {
                print("Error parsing JSON data. \(error)")
                return nil
            }
        } else {
            print("JSON filename missing.")
            return nil
        }
    }
    
}
