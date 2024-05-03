//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation
// swiftlint:disable identifier_name
enum Spectrum: String, CustomStringConvertible {
    case A
    case F
    case G
    case K
    case M
    case L
    case D
    var description: String {
        self.rawValue
    }
    var longDescription: String {
        switch self {
        case .A: return "bluish-white"
        case .F: return "white"
        case .G: return "yellow"
        case .K: return "orange"
        case .M: return "red"
        case .L: return "brown dwarf"
        case .D: return "white dwarf"
        }
    }
    // swiftlint:enable identifier_name
}
