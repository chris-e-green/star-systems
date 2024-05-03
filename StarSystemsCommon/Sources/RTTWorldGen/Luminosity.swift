//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation

enum Luminosity: String, CustomStringConvertible {
    case typeIII
    case typeIV
    case typeV
    case typeVe
    var description: String {
        switch self {
        case .typeIII: return "III"
        case .typeIV: return "IV"
        case .typeV: return "V"
        case .typeVe: return "Ve"
        }
    }
    var longDescription: String {
        switch self {
        case .typeIII: return "Giant"
        case .typeIV: return "Subgiant"
        case .typeV: return "Main Sequence"
        case .typeVe: return "Flare"
        }
    }
}
