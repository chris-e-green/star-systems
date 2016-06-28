//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation

enum PlanetOrbit :Int, CustomStringConvertible{
    case Epistellar = 0
    case Inner
    case Outer
    var description: String {
        switch self {
        case Epistellar: return "Epistellar"
        case Inner: return "Inner"
        case Outer: return "Outer"
        }
    }
}
