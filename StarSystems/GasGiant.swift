//
//  GasGiant.swift
//  StarSystems
//
//  Created by Christopher Green on 28/06/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation

enum GasGiantEnum: String, CustomStringConvertible {
    case Small
    case Large
    var description:String {
        return self.rawValue + " GG"
    }
}

class GasGiant : Satellite, CustomStringConvertible {
    var size: GasGiantEnum
//    var name: String = Name.init(maxLength: 14).description
    var description: String {
//        let pad = String(count: depth, repeatedValue: Character(" "))
//        return "\(pad)\(size)\n\(satDesc)"
        var result = ""
        result += "\(name.padding(maxNameLength)) "
        result += "\(size)\(satDesc)"
        return result
    }
    override var json: String {
        var result = ""
        result += "\"\(jsonLabels.gasgiant)\": {\n"
        result += "\t\"\(jsonLabels.name)\": \"\(name)\",\n"
        result += "\t\"\(jsonLabels.size)\": \"\(size.rawValue)\",\n"
        result += "\t\"\(jsonLabels.satellites)\": [\n"
        result += "\(satJSON)"
        result += "\t]\n"
        result += "}\n"
        return result
    }
    // gas giants only have parents that are stars.
    init(size:GasGiantEnum = .Small, parent:Star) {
        self.size = size
        super.init(parent: parent)
        name = Name(maxLength: maxNameLength).description
    }
}

