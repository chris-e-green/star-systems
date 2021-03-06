//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation
// swiftlint:disable identifier_name
enum RTTBases: String, CustomStringConvertible {
    case A, B, C, D, E, F, G, H, J, K, L, M, GC, MH, SH, TA, TC
    case N, P, Q, R, S, T, U, V, W, X, Y, Z
    var description: String {
        switch self {
        case .A: return "A"
        case .B: return "B"
        case .C: return "C"
        case .D: return "D"
        case .E: return "E"
        case .F: return "F"
        case .G: return "G"
        case .H: return "H"
        case .J: return "J"
        case .K: return "K"
        case .L: return "L"
        case .M: return "M"
        case .GC: return "GC"
        case .MH: return "MH"
        case .SH: return "SH"
        case .TA: return "TA"
        case .TC: return "TC"
        case .N: return "N"
        case .P: return "P"
        case .Q: return "Q"
        case .R: return "R"
        case .S: return "S"
        case .T: return "T"
        case .U: return "U"
        case .V: return "V"
        case .W: return "W"
        case .X: return "X"
        case .Y: return "Y"
        case .Z: return "Z"
        }
    }

    var longDescription: String {
        switch self {
        case .A: return "A-class (Excellent) Starport"
        case .B: return "B-class (Good) Starport"
        case .C: return "C-class (Routine) Starport"
        case .D: return "D-class (Poor) Starport"
        case .E: return "E-class (Frontier) Starport or Emergency Beacon"
        case .F: return "Foreign Embassy / Diplomatic Consulate"
        case .G: return "Imperial Consulate / Governor's Estate"
        case .H: return "Galactic Hospital"
        case .J: return "Ansible / Stargate"
        case .K: return "Galactic church, temple, or other religious site"
        case .L: return "Library Archive"
        case .M: return "Merchant / Megacorporate base"
        case .GC: return "Moot seat or other government centre"
        case .MH: return "Megacorporate headquarters"
        case .SH: return "Scout hostel"
        case .N: return "Naval base"
        case .P: return "Pirate base"
        case .Q: return "Ancients' site"
        case .R: return "Research installation"
        case .S: return "Scout base"
        case .T: return "Travellers' Aid Society Hostel"
        case .TA: return "Travellers' Aid Society First-Class Hostel"
        case .TC: return "Travellers' Aid Society Hostel Chapter-House"
        case .U: return "Galactic University"
        case .V: return "Special enclave (prison, refugee facility, nature preserve, etc.)"
        case .W: return "Weather control / terraforming facility"
        case .X: return "No starport"
        case .Y: return "Shipyard"
        case .Z: return "Psionics Institute"
        }
    }
    // swiftlint:enable identifier_name
}
