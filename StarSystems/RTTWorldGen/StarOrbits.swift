//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation
enum StarOrbits : String, CustomStringConvertible{
    case Primary
    case BrownDwarf
    case Tight
    case Close
    case Moderate
    case Distant
    var description: String {
        switch self {
        case .BrownDwarf: return "Brown Dwarf"
        default: return self.rawValue
        }
    }
}
