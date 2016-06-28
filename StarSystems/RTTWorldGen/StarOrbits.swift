//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation
enum StarOrbits : CustomStringConvertible{
    case Primary
    case BrownDwarf
    case Tight
    case Close
    case Moderate
    case Distant
    var description: String {
        switch self {
        case Primary: return "Primary"
        case BrownDwarf: return "Brown Dwarf"
        case Tight: return "Tight"
        case Close: return "Close"
        case Moderate: return "Moderate"
        case Distant: return "Distant"
        }
    }
}
