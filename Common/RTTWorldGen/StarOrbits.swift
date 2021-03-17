//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation
enum StarOrbits: String, CustomStringConvertible {
    case primary
    case brownDwarf
    case tight
    case close
    case moderate
    case distant
    var description: String {
        switch self {
        case .brownDwarf: return "Brown Dwarf"
        default: return self.rawValue.uppercaseFirst
        }
    }
}
