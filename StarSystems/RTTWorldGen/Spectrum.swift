//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation
enum Spectrum : CustomStringConvertible{
    case A
    case F
    case G
    case K
    case M
    case L
    case D
    var description: String {
        switch self {
        case A: return "A"
        case F: return "F"
        case G: return "G"
        case K: return "K"
        case M: return "M"
        case L: return "L"
        case D: return "D"
        }
    }
    var longDescription: String {
        switch (self) {
        case A: return "bluish-white"
        case F: return "white"
        case G: return "yellow"
        case K: return "orange"
        case M: return "red"
        case L: return "brown dwarf"
        case D: return "white dwarf"
        }
    }
}
