//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation

enum Habitation: CustomStringConvertible {
    case Homeworld, Colony, Outpost, Uninhabited
    var description: String {
        switch self {
        case Homeworld: return "Homeworld"
        case Colony: return "Colony"
        case Outpost: return "Outpost"
        case Uninhabited: return "Uninhabited"
        }
    }
}

