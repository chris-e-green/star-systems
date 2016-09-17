//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation

enum Luminosity : String, CustomStringConvertible{
    case III
    case IV
    case V
    case Ve
    var description: String {
        return self.rawValue
    }
    var longDescription: String {
        switch self {
        case III: return "Giant"
        case IV: return "Subgiant"
        case V: return "Main Sequence"
        case Ve: return "Flare"
        }
    }
}
