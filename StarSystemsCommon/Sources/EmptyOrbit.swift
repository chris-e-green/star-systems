//
//  EmptyOrbit.swift
//  StarSystems
//
//  Created by Christopher Green on 28/06/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation

class EmptyOrbit: Satellite, CustomStringConvertible {
    var description: String {
//        let pad = String(count: depth, repeatedValue: Character(" "))
//        return "\(pad)Empty orbit"
        "Empty orbit"
    }
    override var json: String {
        var result = ""
        result += "\"\(JsonLabels.sattype)\": \"empty\"\n"
        return result
    }

    // empty orbits only have parents that are stars.
    init(parent: Star) {
        super.init(parent: parent)
        name = ""
    }
}
