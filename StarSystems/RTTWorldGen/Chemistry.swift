//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation

enum Chemistry: Int, CustomStringConvertible {
    case Water, Ammonia, Methane, Sulfur, Chlorine
    var description: String {
        switch self {
        case Water: return "Water"
        case Ammonia: return "Ammonia"
        case Methane: return "Methane"
        case Sulfur: return "Sulfur"
        case Chlorine: return "Chlorine"
        }
    }
}
