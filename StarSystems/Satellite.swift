//
//  Satellite.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation
class Satellite {
    /* orbit is stored at orbit * 10 to accommodate the captured planet orbits */
    var satellites: [Int:Satellite] = [:] // orbit*10: satellite
}
class EmptyOrbit: Satellite, CustomStringConvertible {
    var description: String = "Empty orbit"
}
