//
//  GasGiant.swift
//  StarSystems
//
//  Created by Christopher Green on 28/06/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation

enum GasGiantEnum: String, CustomStringConvertible {
    case small
    case large
    var description: String {
        self.rawValue.uppercaseFirst + " GG"
    }
}

class GasGiant: Satellite, CustomStringConvertible {
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
    var verboseDesc: String {
        "\(name) is a \(size.rawValue.lowercased()) gas giant " +
                "orbiting the \(parent!.type.lowercased()) \(parent!.name)."
    }
    override var json: String {
        var result = ""
        result += "\"\(JsonLabels.gasgiant)\": {\n"
        result += "\t\"\(JsonLabels.name)\": \"\(name)\",\n"
        result += "\t\"\(JsonLabels.size)\": \"\(size.rawValue)\",\n"
        result += "\t\"\(JsonLabels.satellites)\": [\n"
        result += "\(satJSON)"
        result += "\t]\n"
        result += "}\n"
        return result
    }
    // gas giants only have parents that are stars.
    init(size: GasGiantEnum = .small, parent: Star) {
        self.size = size
        super.init(parent: parent)
        name = Name(maxLength: maxNameLength).description
    }
}
