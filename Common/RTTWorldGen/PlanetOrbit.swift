//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation

enum PlanetOrbit: String, CustomStringConvertible {
    case epistellar
    case inner
    case outer
    var description: String {
        self.rawValue.uppercaseFirst
    }
}
