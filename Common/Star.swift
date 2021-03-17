//
//  Star.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//
//  The Traveller game in all forms is owned by Far Future Enterprises.
//  Copyright 1977 - 2008 Far Future Enterprises.
//

import Foundation

/// Possible star spectral types
// swiftlint:disable identifier_name
enum StarType: String, CustomStringConvertible, Codable, Hashable {
    case O
    case B
    case A
    case F
    case G
    case K
    case M
    case Z
    var description: String {
        switch self {
        case .O, .B, .A: return "Light Blue"
        case .F: return "White"
        case .G: return "Yellow"
        case .K: return "Orange"
        case .M: return "Deep Red"
        case .Z: return "Undefined"
        }
    }
//    var hashValue: Int {
//        return Int(self.rawValue.utf8.first!)
//    }
}

/// Possible star sizes
enum StarSize: String, CustomStringConvertible, Codable {
    case Ia
    case Ib
    case II
    case III
    case IV
    case V
    case D
    case Z
    var description: String {
        switch self {
        case .Ia: return "Bright Supergiant"
        case .Ib: return "Weaker Supergiant"
        case .II: return "Bright Giant"
        case .III: return "Giant"
        case .IV: return "Subgiant"
        case .V: return "Main Sequence"
        case .D: return "White Dwarf"
        case .Z: return "Undefined"
        }
    }
    // swiftlint:enable identifier_name
//    var hashValue: Int {
//        switch self {
//        case .Ia: return 0
//        case .Ib: return 1
//        case .II: return 2
//        case .III: return 3
//        case .IV: return 4
//        case .V: return 5
//        case .D: return 6
//        case .Z: return 7
//        }
//    }
}

/// Contains the spectrum and size information for the star and a hash
/// so that different stars can be compared.
struct StarDetail: Hashable, Equatable, Codable {
    var starType: StarType
    var starDecimal: Int
    var starSize: StarSize
//    var hashValue: Int {
//        return self.t.hashValue * 100 + self.d * 10 + self.s.hashValue
//    }
}

/// return true if the compared stars have the same spectrum and size
func == (lhs: StarDetail, rhs: StarDetail) -> Bool {
    lhs.hashValue == rhs.hashValue
}

/// Possible orbit zones around a star
// swiftlint:disable identifier_name
enum Zone: String, CustomStringConvertible {
    case O
    case H
    case I
    case U
    case W
    case C
    case Z
    var description: String {
        switch self {
        case .O: return "Outer"
        case .H: return "Habitable"
        case .I: return "Inner"
        case .U: return "Unavailable"
        case .W: return "Within star"
        case .C: return "Close"
        case .Z: return "Undefined"
        }
    }
}
// swiftlint:enable identifier_name

class StellarAttributes {
    var bolMagnitude: Double
    var luminosity: Double
    var effTemp: Double
    var radii: Double
    var mass: Double
    init(bolMagnitude: Double, luminosity: Double, effTemp: Double, radii: Double, mass: Double) {
        self.bolMagnitude = bolMagnitude
        self.luminosity = luminosity
        self.effTemp = effTemp
        self.radii = radii
        self.mass = mass
    }
}
/// the various stellar attributes from Traveller Book 6
let stellarAttrs: [StarDetail: StellarAttributes] = [
    StarDetail(starType: .B, starDecimal: 0, starSize: .Ia): StellarAttributes(bolMagnitude: -9.6, luminosity: 560_000, effTemp: 22_000, radii: 52, mass: 60),
    StarDetail(starType: .B, starDecimal: 5, starSize: .Ia): StellarAttributes(bolMagnitude: -8.5, luminosity: 204_000, effTemp: 14_200, radii: 75, mass: 30),
    StarDetail(starType: .A, starDecimal: 0, starSize: .Ia): StellarAttributes(bolMagnitude: -7.8, luminosity: 107_000, effTemp: 9_000, radii: 135, mass: 18),
    StarDetail(starType: .A, starDecimal: 5, starSize: .Ia): StellarAttributes(bolMagnitude: -7.5, luminosity: 81_000, effTemp: 8_000, radii: 149, mass: 15),
    StarDetail(starType: .F, starDecimal: 0, starSize: .Ia): StellarAttributes(bolMagnitude: -7.2, luminosity: 61_000, effTemp: 6_900, radii: 174, mass: 13),
    StarDetail(starType: .F, starDecimal: 5, starSize: .Ia): StellarAttributes(bolMagnitude: -7.0, luminosity: 51_000, effTemp: 6_100, radii: 204, mass: 12),
    StarDetail(starType: .G, starDecimal: 0, starSize: .Ia): StellarAttributes(bolMagnitude: -7.3, luminosity: 67_000, effTemp: 5_400, radii: 298, mass: 12),
    StarDetail(starType: .G, starDecimal: 5, starSize: .Ia): StellarAttributes(bolMagnitude: -7.6, luminosity: 89_000, effTemp: 4_700, radii: 454, mass: 13),
    StarDetail(starType: .K, starDecimal: 0, starSize: .Ia): StellarAttributes(bolMagnitude: -7.7, luminosity: 97_000, effTemp: 4_000, radii: 654, mass: 14),
    StarDetail(starType: .K, starDecimal: 5, starSize: .Ia): StellarAttributes(bolMagnitude: -7.8, luminosity: 107_000, effTemp: 3_300, radii: 1010, mass: 18),
    StarDetail(starType: .M, starDecimal: 0, starSize: .Ia): StellarAttributes(bolMagnitude: -7.9, luminosity: 117_000, effTemp: 2_800, radii: 1467, mass: 20),
    StarDetail(starType: .M, starDecimal: 5, starSize: .Ia): StellarAttributes(bolMagnitude: -8.0, luminosity: 129_000, effTemp: 2_000, radii: 3020, mass: 25),
    StarDetail(starType: .M, starDecimal: 9, starSize: .Ia): StellarAttributes(bolMagnitude: -8.1, luminosity: 141_000, effTemp: 1_900, radii: 3499, mass: 30),

    StarDetail(starType: .B, starDecimal: 0, starSize: .Ib): StellarAttributes(bolMagnitude: -8.8, luminosity: 270_000, effTemp: 24_000, radii: 30, mass: 50),
    StarDetail(starType: .B, starDecimal: 5, starSize: .Ib): StellarAttributes(bolMagnitude: -6.9, luminosity: 46_700, effTemp: 14_500, radii: 35, mass: 25),
    StarDetail(starType: .A, starDecimal: 0, starSize: .Ib): StellarAttributes(bolMagnitude: -5.7, luminosity: 15_000, effTemp: 9_100, radii: 50, mass: 16),
    StarDetail(starType: .A, starDecimal: 5, starSize: .Ib): StellarAttributes(bolMagnitude: -5.4, luminosity: 11_700, effTemp: 8_100, radii: 55, mass: 13),
    StarDetail(starType: .F, starDecimal: 0, starSize: .Ib): StellarAttributes(bolMagnitude: -4.9, luminosity: 7_400, effTemp: 7_000, radii: 59, mass: 12),
    StarDetail(starType: .F, starDecimal: 5, starSize: .Ib): StellarAttributes(bolMagnitude: -4.5, luminosity: 5_100, effTemp: 6_300, radii: 60, mass: 10),
    StarDetail(starType: .G, starDecimal: 0, starSize: .Ib): StellarAttributes(bolMagnitude: -4.7, luminosity: 6_100, effTemp: 5_600, radii: 84, mass: 10),
    StarDetail(starType: .G, starDecimal: 5, starSize: .Ib): StellarAttributes(bolMagnitude: -5.0, luminosity: 8_100, effTemp: 4_850, radii: 128, mass: 12),
    StarDetail(starType: .K, starDecimal: 0, starSize: .Ib): StellarAttributes(bolMagnitude: -5.4, luminosity: 11_700, effTemp: 4_100, radii: 216, mass: 13),
    StarDetail(starType: .K, starDecimal: 5, starSize: .Ib): StellarAttributes(bolMagnitude: -6.0, luminosity: 20_400, effTemp: 3_500, radii: 392, mass: 16),
    StarDetail(starType: .M, starDecimal: 0, starSize: .Ib): StellarAttributes(bolMagnitude: -6.9, luminosity: 46_000, effTemp: 2_900, radii: 857, mass: 16),
    StarDetail(starType: .M, starDecimal: 5, starSize: .Ib): StellarAttributes(bolMagnitude: -7.6, luminosity: 89_000, effTemp: 2_200, radii: 2073, mass: 20),
    StarDetail(starType: .M, starDecimal: 9, starSize: .Ib): StellarAttributes(bolMagnitude: -7.9, luminosity: 117_000, effTemp: 2_000, radii: 2876, mass: 25),

    StarDetail(starType: .B, starDecimal: 0, starSize: .II): StellarAttributes(bolMagnitude: -8.3, luminosity: 170_000, effTemp: 25_000, radii: 22, mass: 30),
    StarDetail(starType: .B, starDecimal: 5, starSize: .II): StellarAttributes(bolMagnitude: -5.9, luminosity: 18_600, effTemp: 15_100, radii: 20, mass: 20),
    StarDetail(starType: .A, starDecimal: 0, starSize: .II): StellarAttributes(bolMagnitude: -3.6, luminosity: 2_200, effTemp: 9_300, radii: 18, mass: 14),
    StarDetail(starType: .A, starDecimal: 5, starSize: .II): StellarAttributes(bolMagnitude: -2.55, luminosity: 850, effTemp: 8_200, radii: 14, mass: 11),
    StarDetail(starType: .F, starDecimal: 0, starSize: .II): StellarAttributes(bolMagnitude: -2.18, luminosity: 600, effTemp: 7_100, radii: 16, mass: 10),
    StarDetail(starType: .F, starDecimal: 5, starSize: .II): StellarAttributes(bolMagnitude: -2.0, luminosity: 510, effTemp: 6_400, radii: 18, mass: 8.1),
    StarDetail(starType: .G, starDecimal: 0, starSize: .II): StellarAttributes(bolMagnitude: -2.1, luminosity: 560, effTemp: 5_700, radii: 25, mass: 8.1),
    StarDetail(starType: .G, starDecimal: 5, starSize: .II): StellarAttributes(bolMagnitude: -2.4, luminosity: 740, effTemp: 5_000, radii: 37, mass: 10),
    StarDetail(starType: .K, starDecimal: 0, starSize: .II): StellarAttributes(bolMagnitude: -2.6, luminosity: 890, effTemp: 4_300, radii: 54, mass: 11),
    StarDetail(starType: .K, starDecimal: 5, starSize: .II): StellarAttributes(bolMagnitude: -3.7, luminosity: 2_450, effTemp: 3_650, radii: 124, mass: 14),
    StarDetail(starType: .M, starDecimal: 0, starSize: .II): StellarAttributes(bolMagnitude: -4.4, luminosity: 4_600, effTemp: 3_100, radii: 237, mass: 14),
    StarDetail(starType: .M, starDecimal: 5, starSize: .II): StellarAttributes(bolMagnitude: -5.65, luminosity: 14_900, effTemp: 2_400, radii: 712, mass: 16),
    StarDetail(starType: .M, starDecimal: 9, starSize: .II): StellarAttributes(bolMagnitude: -5.75, luminosity: 16_200, effTemp: 2_100, radii: 931, mass: 18),

    StarDetail(starType: .B, starDecimal: 0, starSize: .III): StellarAttributes(bolMagnitude: -7.8, luminosity: 107_000, effTemp: 26_000, radii: 16, mass: 25),
    StarDetail(starType: .B, starDecimal: 5, starSize: .III): StellarAttributes(bolMagnitude: -3.5, luminosity: 6_700, effTemp: 15_200, radii: 10, mass: 15),
    StarDetail(starType: .A, starDecimal: 0, starSize: .III): StellarAttributes(bolMagnitude: -1.36, luminosity: 280, effTemp: 9_500, radii: 6.2, mass: 12),
    StarDetail(starType: .A, starDecimal: 5, starSize: .III): StellarAttributes(bolMagnitude: -0.1, luminosity: 90, effTemp: 8_300, radii: 4.6, mass: 9),
    StarDetail(starType: .F, starDecimal: 0, starSize: .III): StellarAttributes( bolMagnitude: 0.45, luminosity: 53, effTemp: 7_200, radii: 4.7, mass: 8),
    StarDetail(starType: .F, starDecimal: 5, starSize: .III): StellarAttributes( bolMagnitude: 0.7, luminosity: 43, effTemp: 6_500, radii: 5.2, mass: 5),
    StarDetail(starType: .G, starDecimal: 0, starSize: .III): StellarAttributes( bolMagnitude: 0.52, luminosity: 50, effTemp: 5_800, radii: 7.1, mass: 2.5),
    StarDetail(starType: .G, starDecimal: 5, starSize: .III): StellarAttributes( bolMagnitude: 0.08, luminosity: 75, effTemp: 5_100, radii: 11, mass: 3.2),
    StarDetail(starType: .K, starDecimal: 0, starSize: .III): StellarAttributes( bolMagnitude: 0.17, luminosity: 95, effTemp: 4_500, radii: 16, mass: 4),
    StarDetail(starType: .K, starDecimal: 5, starSize: .III): StellarAttributes(bolMagnitude: -1.5, luminosity: 320, effTemp: 3_800, radii: 42, mass: 5),
    StarDetail(starType: .M, starDecimal: 0, starSize: .III): StellarAttributes(bolMagnitude: -1.9, luminosity: 470, effTemp: 3_400, radii: 63, mass: 6.3),
    StarDetail(starType: .M, starDecimal: 5, starSize: .III): StellarAttributes(bolMagnitude: -3.6, luminosity: 2_280, effTemp: 2_650, radii: 228, mass: 7.4),
    StarDetail(starType: .M, starDecimal: 9, starSize: .III): StellarAttributes(bolMagnitude: -3.8, luminosity: 2_690, effTemp: 2_200, radii: 360, mass: 9.2),

    StarDetail(starType: .B, starDecimal: 0, starSize: .IV): StellarAttributes(bolMagnitude: -7.5, luminosity: 81_000, effTemp: 27_000, radii: 13, mass: 20),
    StarDetail(starType: .B, starDecimal: 5, starSize: .IV): StellarAttributes(bolMagnitude: -3.1, luminosity: 2_000, effTemp: 15_400, radii: 5.3, mass: 10),
    StarDetail(starType: .A, starDecimal: 0, starSize: .IV): StellarAttributes(bolMagnitude: -0.7, luminosity: 156, effTemp: 9_700, radii: 4.5, mass: 6),
    StarDetail(starType: .A, starDecimal: 5, starSize: .IV): StellarAttributes( bolMagnitude: 0.85, luminosity: 37, effTemp: 8_400, radii: 2.7, mass: 4),
    StarDetail(starType: .F, starDecimal: 0, starSize: .IV): StellarAttributes( bolMagnitude: 1.58, luminosity: 19, effTemp: 7_300, radii: 2.7, mass: 2.5),
    StarDetail(starType: .F, starDecimal: 5, starSize: .IV): StellarAttributes( bolMagnitude: 2.1, luminosity: 12, effTemp: 6_600, radii: 2.6, mass: 2),
    StarDetail(starType: .G, starDecimal: 0, starSize: .IV): StellarAttributes( bolMagnitude: 2.74, luminosity: 6.5, effTemp: 5_900, radii: 2.5, mass: 1.75),
    StarDetail(starType: .G, starDecimal: 5, starSize: .IV): StellarAttributes( bolMagnitude: 3.04, luminosity: 4.9, effTemp: 5_200, radii: 2.8, mass: 2),
    StarDetail(starType: .K, starDecimal: 0, starSize: .IV): StellarAttributes( bolMagnitude: 3.1, luminosity: 4.67, effTemp: 4_700, radii: 3.3, mass: 2.3),

    StarDetail(starType: .B, starDecimal: 0, starSize: .V): StellarAttributes(bolMagnitude: -7.1, luminosity: 56_000, effTemp: 28_000, radii: 10, mass: 18),
    StarDetail(starType: .B, starDecimal: 5, starSize: .V): StellarAttributes(bolMagnitude: -2.71, luminosity: 1_400, effTemp: 15_500, radii: 4.4, mass: 6.5),
    StarDetail(starType: .A, starDecimal: 0, starSize: .V): StellarAttributes(bolMagnitude: -0.1, luminosity: 90, effTemp: 9_900, radii: 3.2, mass: 3.2),
    StarDetail(starType: .A, starDecimal: 5, starSize: .V): StellarAttributes( bolMagnitude: 1.8, luminosity: 16, effTemp: 8_500, radii: 1.8, mass: 2.1),
    StarDetail(starType: .F, starDecimal: 0, starSize: .V): StellarAttributes( bolMagnitude: 2.5, luminosity: 8.1, effTemp: 7_400, radii: 1.7, mass: 1.7),
    StarDetail(starType: .F, starDecimal: 5, starSize: .V): StellarAttributes( bolMagnitude: 3.4, luminosity: 3.5, effTemp: 6_700, radii: 1.4, mass: 1.3),
    StarDetail(starType: .G, starDecimal: 0, starSize: .V): StellarAttributes( bolMagnitude: 4.57, luminosity: 1.21, effTemp: 6_000, radii: 1.03, mass: 1.04),
    StarDetail(starType: .G, starDecimal: 5, starSize: .V): StellarAttributes( bolMagnitude: 5.2, luminosity: 0.67, effTemp: 5_500, radii: 0.91, mass: 0.94),
    StarDetail(starType: .K, starDecimal: 0, starSize: .V): StellarAttributes( bolMagnitude: 5.7, luminosity: 0.42, effTemp: 4_900, radii: 0.908, mass: 0.825),
    StarDetail(starType: .K, starDecimal: 5, starSize: .V): StellarAttributes( bolMagnitude: 7.4, luminosity: 0.08, effTemp: 4_100, radii: 0.566, mass: 0.57),
    StarDetail(starType: .M, starDecimal: 0, starSize: .V): StellarAttributes( bolMagnitude: 8.25, luminosity: 0.04, effTemp: 3_500, radii: 0.549, mass: 0.489),
    StarDetail(starType: .M, starDecimal: 5, starSize: .V): StellarAttributes(bolMagnitude: 10.2, luminosity: 0.007, effTemp: 2_800, radii: 0.358, mass: 0.331),
    StarDetail(starType: .M, starDecimal: 9, starSize: .V): StellarAttributes(bolMagnitude: 13.9, luminosity: 0.001, effTemp: 2_300, radii: 0.201, mass: 0.215),

    StarDetail(starType: .B, starDecimal: 0, starSize: .D): StellarAttributes( bolMagnitude: 8.1, luminosity: 0.046, effTemp: 25_000, radii: 0.018, mass: 0.26),
    StarDetail(starType: .A, starDecimal: 0, starSize: .D): StellarAttributes(bolMagnitude: 10.5, luminosity: 0.005, effTemp: 14_000, radii: 0.017, mass: 0.36),
    StarDetail(starType: .F, starDecimal: 0, starSize: .D): StellarAttributes(bolMagnitude: 13.6, luminosity: 0.0003, effTemp: 6_600, radii: 0.013, mass: 0.42),
    StarDetail(starType: .G, starDecimal: 0, starSize: .D): StellarAttributes(bolMagnitude: 15.3, luminosity: 0.00006, effTemp: 4_500, radii: 0.012, mass: 0.63),
    StarDetail(starType: .K, starDecimal: 0, starSize: .D): StellarAttributes(bolMagnitude: 15.6, luminosity: 0.00004, effTemp: 3_500, radii: 0.009, mass: 0.83),
    StarDetail(starType: .M, starDecimal: 0, starSize: .D): StellarAttributes(bolMagnitude: 15.9, luminosity: 0.00003, effTemp: 2_700, radii: 0.006, mass: 1.11),
    StarDetail(starType: .B, starDecimal: 5, starSize: .D): StellarAttributes( bolMagnitude: 8.1, luminosity: 0.046, effTemp: 25_000, radii: 0.018, mass: 0.26),
    StarDetail(starType: .A, starDecimal: 5, starSize: .D): StellarAttributes(bolMagnitude: 10.5, luminosity: 0.005, effTemp: 14_000, radii: 0.017, mass: 0.36),
    StarDetail(starType: .F, starDecimal: 5, starSize: .D): StellarAttributes(bolMagnitude: 13.6, luminosity: 0.0003, effTemp: 6_600, radii: 0.013, mass: 0.42),
    StarDetail(starType: .G, starDecimal: 5, starSize: .D): StellarAttributes(bolMagnitude: 15.3, luminosity: 0.00006, effTemp: 4_500, radii: 0.012, mass: 0.63),
    StarDetail(starType: .K, starDecimal: 5, starSize: .D): StellarAttributes(bolMagnitude: 15.6, luminosity: 0.00004, effTemp: 3_500, radii: 0.009, mass: 0.83),
    StarDetail(starType: .M, starDecimal: 5, starSize: .D): StellarAttributes(bolMagnitude: 15.9, luminosity: 0.00003, effTemp: 2_700, radii: 0.006, mass: 1.11),
    StarDetail(starType: .B, starDecimal: 9, starSize: .D): StellarAttributes( bolMagnitude: 8.1, luminosity: 0.046, effTemp: 25_000, radii: 0.018, mass: 0.26),
    StarDetail(starType: .A, starDecimal: 9, starSize: .D): StellarAttributes(bolMagnitude: 10.5, luminosity: 0.005, effTemp: 14_000, radii: 0.017, mass: 0.36),
    StarDetail(starType: .F, starDecimal: 9, starSize: .D): StellarAttributes(bolMagnitude: 13.6, luminosity: 0.0003, effTemp: 6_600, radii: 0.013, mass: 0.42),
    StarDetail(starType: .G, starDecimal: 9, starSize: .D): StellarAttributes(bolMagnitude: 15.3, luminosity: 0.00006, effTemp: 4_500, radii: 0.012, mass: 0.63),
    StarDetail(starType: .K, starDecimal: 9, starSize: .D): StellarAttributes(bolMagnitude: 15.6, luminosity: 0.00004, effTemp: 3_500, radii: 0.009, mass: 0.83),
    StarDetail(starType: .M, starDecimal: 9, starSize: .D): StellarAttributes(bolMagnitude: 15.9, luminosity: 0.00003, effTemp: 2_700, radii: 0.006, mass: 1.11)

]
/// the defined zones for each star type and size from Traveller Book 6
let tableOfZones: [StarDetail: [Zone]] = [
    //                            0  1  2  3  4  5  6  7  8  9 10 11 12 13 14
    StarDetail(starType: .B, starDecimal: 0, starSize: .Ia): [.W, .U, .U, .U, .U, .U, .U, .U, .I, .I, .I, .I, .I, .H, .O],
    StarDetail(starType: .B, starDecimal: 5, starSize: .Ia): [.W, .U, .U, .U, .U, .U, .U, .I, .I, .I, .I, .I, .H, .O, .O],
    StarDetail(starType: .A, starDecimal: 0, starSize: .Ia): [.W, .W, .U, .U, .U, .U, .U, .I, .I, .I, .I, .I, .H, .O, .O],
    StarDetail(starType: .A, starDecimal: 5, starSize: .Ia): [.W, .W, .U, .U, .U, .U, .U, .I, .I, .I, .I, .I, .H, .O, .O],
    StarDetail(starType: .F, starDecimal: 0, starSize: .Ia): [.W, .W, .W, .U, .U, .U, .I, .I, .I, .I, .I, .I, .H, .O, .O],
    StarDetail(starType: .F, starDecimal: 5, starSize: .Ia): [.W, .W, .W, .U, .U, .U, .I, .I, .I, .I, .I, .H, .O, .O, .O],
    StarDetail(starType: .G, starDecimal: 0, starSize: .Ia): [.W, .W, .W, .W, .U, .U, .U, .I, .I, .I, .I, .I, .H, .O, .O],
    StarDetail(starType: .G, starDecimal: 5, starSize: .Ia): [.W, .W, .W, .W, .W, .U, .U, .I, .I, .I, .I, .I, .H, .O, .O],
    StarDetail(starType: .K, starDecimal: 0, starSize: .Ia): [.W, .W, .W, .W, .W, .W, .U, .I, .I, .I, .I, .I, .H, .O, .O],
    StarDetail(starType: .K, starDecimal: 5, starSize: .Ia): [.W, .W, .W, .W, .W, .W, .U, .I, .I, .I, .I, .I, .H, .O, .O],
    StarDetail(starType: .M, starDecimal: 0, starSize: .Ia): [.W, .W, .W, .W, .W, .W, .W, .I, .I, .I, .I, .I, .H, .O, .O],
    StarDetail(starType: .M, starDecimal: 5, starSize: .Ia): [.W, .W, .W, .W, .W, .W, .W, .W, .I, .I, .I, .I, .H, .O, .O],
    StarDetail(starType: .M, starDecimal: 9, starSize: .Ia): [.W, .W, .W, .W, .W, .W, .W, .W, .I, .I, .I, .I, .H, .O, .O],
    //                            0  1  2  3  4  5  6  7  8  9 10 11 12 13 14
    StarDetail(starType: .B, starDecimal: 0, starSize: .Ib): [.U, .U, .U, .U, .U, .U, .U, .U, .I, .I, .I, .I, .I, .H, .O],
    StarDetail(starType: .B, starDecimal: 5, starSize: .Ib): [.U, .U, .U, .U, .U, .U, .I, .I, .I, .I, .I, .H, .O, .O, .O],
    StarDetail(starType: .A, starDecimal: 0, starSize: .Ib): [.W, .U, .U, .U, .U, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O],
    StarDetail(starType: .A, starDecimal: 5, starSize: .Ib): [.W, .U, .U, .U, .U, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O],
    StarDetail(starType: .F, starDecimal: 0, starSize: .Ib): [.W, .U, .U, .U, .U, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O],
    StarDetail(starType: .F, starDecimal: 5, starSize: .Ib): [.W, .U, .U, .U, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O],
    StarDetail(starType: .G, starDecimal: 0, starSize: .Ib): [.W, .U, .U, .U, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O],
    StarDetail(starType: .G, starDecimal: 5, starSize: .Ib): [.W, .W, .U, .U, .U, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O],
    StarDetail(starType: .K, starDecimal: 0, starSize: .Ib): [.W, .W, .W, .W, .U, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O],
    StarDetail(starType: .K, starDecimal: 5, starSize: .Ib): [.W, .W, .W, .W, .W, .U, .I, .I, .I, .I, .I, .H, .O, .O, .O],
    StarDetail(starType: .M, starDecimal: 0, starSize: .Ib): [.W, .W, .W, .W, .W, .W, .I, .I, .I, .I, .I, .H, .O, .O, .O],
    StarDetail(starType: .M, starDecimal: 5, starSize: .Ib): [.W, .W, .W, .W, .W, .W, .W, .I, .I, .I, .I, .I, .H, .O, .O],
    StarDetail(starType: .M, starDecimal: 9, starSize: .Ib): [.W, .W, .W, .W, .W, .W, .W, .W, .I, .I, .I, .I, .H, .O, .O],
    //                            0  1  2  3  4  5  6  7  8  9 10 11 12 13
    StarDetail(starType: .B, starDecimal: 0, starSize: .II): [.U, .U, .U, .U, .U, .U, .U, .I, .I, .I, .I, .I, .H, .O],
    StarDetail(starType: .B, starDecimal: 5, starSize: .II): [.U, .U, .U, .U, .U, .I, .I, .I, .I, .I, .I, .H, .O, .O],
    StarDetail(starType: .A, starDecimal: 0, starSize: .II): [.U, .U, .U, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O],
    StarDetail(starType: .A, starDecimal: 5, starSize: .II): [.U, .U, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O],
    StarDetail(starType: .F, starDecimal: 0, starSize: .II): [.U, .U, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O],
    StarDetail(starType: .F, starDecimal: 5, starSize: .II): [.U, .U, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O],
    StarDetail(starType: .G, starDecimal: 0, starSize: .II): [.U, .U, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O],
    StarDetail(starType: .G, starDecimal: 5, starSize: .II): [.U, .U, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O],
    StarDetail(starType: .K, starDecimal: 0, starSize: .II): [.W, .U, .I, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O],
    StarDetail(starType: .K, starDecimal: 5, starSize: .II): [.W, .W, .U, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O],
    StarDetail(starType: .M, starDecimal: 0, starSize: .II): [.W, .W, .W, .W, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O],
    StarDetail(starType: .M, starDecimal: 5, starSize: .II): [.W, .W, .W, .W, .W, .W, .I, .I, .I, .I, .I, .H, .O, .O],
    StarDetail(starType: .M, starDecimal: 9, starSize: .II): [.W, .W, .W, .W, .W, .W, .I, .I, .I, .I, .I, .H, .O, .O],
    //                            0  1  2  3  4  5  6  7  8  9 10 11 12 13
    StarDetail(starType: .A, starDecimal: 0, starSize: .III): [.I, .I, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O],
    StarDetail(starType: .A, starDecimal: 5, starSize: .III): [.I, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .F, starDecimal: 0, starSize: .III): [.I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .F, starDecimal: 5, starSize: .III): [.I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .G, starDecimal: 0, starSize: .III): [.I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .G, starDecimal: 5, starSize: .III): [.I, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .K, starDecimal: 0, starSize: .III): [.I, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .K, starDecimal: 5, starSize: .III): [.W, .I, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O],
    StarDetail(starType: .M, starDecimal: 0, starSize: .III): [.W, .W, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O],
    StarDetail(starType: .M, starDecimal: 5, starSize: .III): [.W, .W, .W, .W, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O],
    StarDetail(starType: .M, starDecimal: 9, starSize: .III): [.W, .W, .W, .W, .W, .I, .I, .I, .I, .H, .O, .O, .O, .O],
    //                            0  1  2  3  4  5  6  7  8  9 10 11 12 13
    StarDetail(starType: .A, starDecimal: 0, starSize: .IV): [.W, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .A, starDecimal: 5, starSize: .IV): [.I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .F, starDecimal: 0, starSize: .IV): [.I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .F, starDecimal: 5, starSize: .IV): [.I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .G, starDecimal: 0, starSize: .IV): [.I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .G, starDecimal: 5, starSize: .IV): [.I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .K, starDecimal: 0, starSize: .IV): [.I, .I, .I, .I, .H, .O, .O, .O, .O, .O, .O, .O, .O, .O],
    //                            0  1  2  3  4  5  6  7  8  9 10 11 12 13
    StarDetail(starType: .A, starDecimal: 0, starSize: .V): [.I, .I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .A, starDecimal: 5, starSize: .V): [.I, .I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .F, starDecimal: 0, starSize: .V): [.I, .I, .I, .I, .I, .H, .O, .O, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .F, starDecimal: 5, starSize: .V): [.I, .I, .I, .I, .H, .O, .O, .O, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .G, starDecimal: 0, starSize: .V): [.I, .I, .I, .H, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .G, starDecimal: 5, starSize: .V): [.I, .I, .H, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .K, starDecimal: 0, starSize: .V): [.I, .I, .H, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .K, starDecimal: 5, starSize: .V): [.H, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .M, starDecimal: 0, starSize: .V): [.H, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .M, starDecimal: 5, starSize: .V): [.O, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O],
    StarDetail(starType: .M, starDecimal: 9, starSize: .V): [.O, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O, .O],
    //                            0  1  2  3  4
    StarDetail(starType: .B, starDecimal: 0, starSize: .D): [.H, .O, .O, .O, .O],
    StarDetail(starType: .B, starDecimal: 5, starSize: .D): [.H, .O, .O, .O, .O],
    StarDetail(starType: .B, starDecimal: 9, starSize: .D): [.H, .O, .O, .O, .O],
    //                            0  1  2  3  4
    StarDetail(starType: .A, starDecimal: 0, starSize: .D): [.O, .O, .O, .O, .O],
    StarDetail(starType: .A, starDecimal: 5, starSize: .D): [.O, .O, .O, .O, .O],
    StarDetail(starType: .A, starDecimal: 9, starSize: .D): [.O, .O, .O, .O, .O],
    //                            0  1  2  3  4
    StarDetail(starType: .F, starDecimal: 0, starSize: .D): [.O, .O, .O, .O, .O],
    StarDetail(starType: .F, starDecimal: 5, starSize: .D): [.O, .O, .O, .O, .O],
    StarDetail(starType: .F, starDecimal: 9, starSize: .D): [.O, .O, .O, .O, .O],
    //                            0  1  2  3  4
    StarDetail(starType: .G, starDecimal: 0, starSize: .D): [.O, .O, .O, .O, .O],
    StarDetail(starType: .G, starDecimal: 5, starSize: .D): [.O, .O, .O, .O, .O],
    StarDetail(starType: .G, starDecimal: 9, starSize: .D): [.O, .O, .O, .O, .O],
    //                            0  1  2  3  4
    StarDetail(starType: .K, starDecimal: 0, starSize: .D): [.O, .O, .O, .O, .O],
    StarDetail(starType: .K, starDecimal: 5, starSize: .D): [.O, .O, .O, .O, .O],
    StarDetail(starType: .K, starDecimal: 9, starSize: .D): [.O, .O, .O, .O, .O],
    //                            0  1  2  3  4
    StarDetail(starType: .M, starDecimal: 0, starSize: .D): [.O, .O, .O, .O, .O],
    StarDetail(starType: .M, starDecimal: 5, starSize: .D): [.O, .O, .O, .O, .O],
    StarDetail(starType: .M, starDecimal: 9, starSize: .D): [.O, .O, .O, .O, .O]
]

/// The class that defines all stars.
class Star: Satellite, /*Hashable, Equatable, */CustomStringConvertible {
    //    var type: StarType = .A
    //    var decimal: Int = 0
    //    var size: StarSize = .Ia
    var starDetail: StarDetail = StarDetail(starType: .A, starDecimal: 0, starSize: .Ia)
    var magnitude: Double = 0
    // despite its name, 'maximum orbits' is described in the text as "the highest numbered orbit available".
    // Given that the system allows orbit 0, that means that the maximum number of orbits is actually one higher than
    // 'max orbits'...
    // so to avoid further confusion, I am calling the variable 'maxOrbitNum'.
    var maxOrbitNum: Int = 0
    //    var hashValue: Int {get {return self.type.hashValue * 100 + self.decimal * 10 + self.size.hashValue}}

    var specSizeDescription: String {
        "\(starDetail.starType), \(starDetail.starSize) Star"
    }

    var starDesc: String {
        var result = ""
        //        let pad = String(count: depth, repeatedValue: Character(" "))
        //        result += pad
        //        result += "\t\t\t"
        result += name.padding(maxNameLength)
        result += "\(specSize) "
        result += "\t\t(\(specSizeDescription))"
        return result
    }

    var verboseDesc: String {
        var result = "\(name) (\(specSize)) is a \(specSizeDescription.lowercased())"
        if let parentStar = parent as? Star {
            result += " companion star to \(parentStar.name)"
        }
        result += ". "
        return result
    }

    var specSize: String {
        var result = ""
        if starDetail.starSize == .D {
            result += "\(starDetail.starSize.rawValue)\(starDetail.starType.rawValue)"
        } else {
            result += "\(starDetail.starType.rawValue)\(starDetail.starDecimal) \(starDetail.starSize.rawValue)"
        }
        return result
    }
    var description: String {
        var desc: String = ""
        desc += starDesc
        //        d += "Max orbit number = \(maxOrbitNum)\n"
        //        if parent == nil {
        desc += "\(satDesc)"
        //        }
        return desc
    }

    override var json: String {
        var result = ""
        result += "\"\(JsonLabels.star)\":\n"
        result += "{\n"
        result += "\t\"\(JsonLabels.name)\": \"\(name)\",\n"
        result += "\t\"\(JsonLabels.type)\": \"\(starDetail.starType.rawValue)\",\n"
        result += "\t\"\(JsonLabels.decimal)\": \"\(starDetail.starDecimal)\",\n"
        result += "\t\"\(JsonLabels.size)\": \"\(starDetail.starSize.rawValue)\",\n"
        result += "\t\"\(JsonLabels.satellites)\": [\n"
        result += satJSON
        result += "\t]\n"
        result += "}\n"
        return result
    }

    //    var satJSONDesc: String {
    //        var result = ""
    //            result += "\t\"\(jsonLabels.satellites)\": [\n"
    //            result += satJSON
    //            result += "\t]\n"
    //        return result
    //    }

    convenience init(type: StarType, decimal: Int, size: StarSize, parent: Star? = nil) {
        self.init(starType: type, starDecimal: decimal, starSize: size)
        starDetail.starType = type
        starDetail.starDecimal = decimal
        starDetail.starSize = size
        magnitude = (stellarAttrs[starDetail]?.bolMagnitude)!
        self.parent = parent
    }

    init(starType: StarType = .A, starDecimal: Int = 0, starSize: StarSize = .Ia, parentStar: Star? = nil) {
        super.init(parent: parentStar)
        starDetail.starType = starType
        starDetail.starDecimal = starDecimal
        starDetail.starSize = starSize
        magnitude = (stellarAttrs[starDetail]?.bolMagnitude)!
        name = Name(maxLength: maxNameLength).description
    }

    convenience init(companion: Bool, typeRoll: Int, sizeRoll: Int, parent: Star? = nil) {
        self.init()
        self.parent = parent
        if companion {
            switch typeRoll {
            case 1:   starDetail.starType = .B
            case 2:   starDetail.starType = .A
            case 3, 4: starDetail.starType = .F
            case 5, 6: starDetail.starType = .G
            case 7, 8: starDetail.starType = .K
            default:  starDetail.starType = .M
            }
        } else {
            switch typeRoll {
            case 2:     starDetail.starType = .A
            case 3...7: starDetail.starType = .M
            case 8:     starDetail.starType = .K
            case 9, 10:  starDetail.starType = .G
            default:    starDetail.starType = .F
            }
        }

        if Dice.roll(1) <= 3 { starDetail.starDecimal = 0 } else { starDetail.starDecimal = 5}

        if companion {
            switch sizeRoll {
            case 0: starDetail.starSize = .Ia
            case 1: starDetail.starSize = .Ib
            case 2: starDetail.starSize = .II
            case 3: starDetail.starSize = .III
            case 4: starDetail.starSize = .IV
            case 5...11: starDetail.starSize = .V
            default: starDetail.starSize = .D
            }
        } else {
            switch sizeRoll {
            case 2: starDetail.starSize = .II
            case 3: starDetail.starSize = .III
            case 4: starDetail.starSize = .IV
            default: starDetail.starSize = .V
            }
        }
        if ((starDetail.starType == .K && starDetail.starDecimal == 5) ||
            (starDetail.starType == .M)) && (starDetail.starSize == .IV) {
            starDetail.starSize = .V
        }
        magnitude = (stellarAttrs[starDetail]?.bolMagnitude)!

    }

    /// Get the main world of this system (if such a thing exists).
    /// The main world is the planet with the highest population, and if there's more than
    /// one, by preference one in the habitable zone, otherwise the one closest to the sun.
    ///
    /// - returns:
    ///      The planet (if one exists) that matches the criteria.
    func getMainWorld() -> Planet? {
        var mainWorld: Planet?
        var minOrbit: Float = Float.infinity
        let (worlds, _) = getMaxPop()  // worlds is an array of worlds that have the maximum population.
        // now we need to weed out to find the actual mainworld.
        for world in worlds {
            if let planet = world {
                // habitable is first preference
                if planet.zone == Zone.H {
                    mainWorld = planet
                } else {
                    if planet.stellarOrbit < minOrbit {
                        mainWorld = planet
                        minOrbit = planet.stellarOrbit
                    }
                }
            }
        }
        return mainWorld
    }

    /// Obtain a random orbit number in the inner, habitable or outer zone.
    /// - Returns: A random available inner, habitable or outer orbit number.
    func getAvailOrbit() -> Float {
        var orbit: Float
        let possibilities = getAvailOrbits(Set<Zone>([Zone.H, Zone.O, Zone.I]))
        if DEBUG { print("Avail on \(name); AvailOrbits returned \(possibilities)") }
        orbit = possibilities[Dice.roll(1, sides: possibilities.count)-1]
        return orbit
    }

    /// Obtain a random orbit number in any zone except within the star.
    /// - Returns: A random available orbit number except within the star.
    func getAnyAvailOrbit() -> Float {
        var orbit: Float
        let possibilities = getAvailOrbits(Set<Zone>([Zone.H, Zone.O, Zone.I, Zone.U]))
        if DEBUG { print("Avail on \(name); AnyAvailOrbits returned \(possibilities)") }
        orbit = possibilities[Dice.roll(1, sides: possibilities.count)-1]
        return orbit
    }

    /// Obtain a random orbit number in the inner or outer zone.
    /// - Returns: A random available inner or outer orbit number.
    func getAvailInOutOrbit() -> Float? {
        var orbit: Float?
        let possibilities = getAvailOrbits(Set<Zone>([Zone.O, Zone.I]))
        if DEBUG { print("AvailInOut on \(name); AvailOrbits returned \(possibilities)") }
        if possibilities.count > 0 {
            orbit = possibilities[Dice.roll(1, sides: possibilities.count)-1]
        }
        return orbit
    }

/**
     Obtain all available orbits within the supplied zones.
 
     - parameters:
        - zones:
     The `Zone`s that the orbit must be within
        - createIfNone:
     Defaults to `true`. Callers that want to count available orbits should supply `false`.
     
    - Returns: An array of empty orbits that are within the requested `Zone`s.
 */
    func getAvailOrbits(_ zones: Set<Zone>, createIfNone: Bool=true) -> [Float] {
        var orbits: [Float] = []
        for orbit in 0...maxOrbitNum {
            if zones.contains(getZone(orbit)!) && getSatellite(orbit) == nil {
                orbits.append(Float(orbit))
            }
        }
        if createIfNone {
            // if we found no orbits, and we've been asked to, we'll make one.
            if orbits.count == 0 {
                // we can't just blindly increment to the next orbit,
                // because it might be occupied by a star, a captured planet,
                // or an empty orbit.
                repeat {
                    maxOrbitNum += 1
                } while getSatellite(maxOrbitNum) != nil
                if DEBUG { print("Created a new orbit number \(maxOrbitNum) on \(name)") }
                orbits.append(Float(maxOrbitNum))
            }
        }
        return orbits
    }

    /// Creates a new outer zone on the star and returns the orbit number.
    func createOuterZone() -> Float {
        var result: Float = 0.0
        // first, we need to find out whether the current max orbit number
        // is already in the outer zone.
        if getZone(maxOrbitNum) == Zone.O {
            // it is, so we just need to get to the next available orbit
            // number and return that one (we need to make sure we don't
            // collide with something...)
            repeat {
                maxOrbitNum += 1
            } while getSatellite(maxOrbitNum) != nil
            result = Float(maxOrbitNum)
        } else {
            // we're not in the outer zone so we need to find where it starts
            // we will start looking from the current max
            var orbit = maxOrbitNum
            // increment orbit number until we find one that is in the outer zone and is also not occupied.
            repeat {
                orbit += 1
            } while getZone(orbit) != Zone.O && getSatellite(orbit) != nil
            // if we are explicitly placing an outer orbit and our max is not in the outer zone, we don't increase
            // the maximum orbit number, otherwise the system grows to meet the gas giant.
            result = Float(orbit)
        }
        return result
    }

/**
     Return the habitable orbit for this star, if there is one.
     - returns: the orbit number of the habitable zone, or nil if
     there is no habitable zone.
 */
    func getHabOrbit() -> Float? {
        var result: Float?
        if let zones: [Zone] = tableOfZones[starDetail] {
            if zones.firstIndex(of: Zone.H) != nil {
                result = Float(zones.firstIndex(of: Zone.H)!)
            }
        }
        return result

    }
/**
 Obtain all satellites within the supplied zones.

 - parameters:
     - zones: The `Zone`s that the satellites must occupy.

 - returns: An array of satellites that are with the requested `Zone`s.
 */
    func getSatellites(_ zones: Set<Zone>) -> [Satellite] {
        var satellites: [Satellite] = []
        for orbitNum in 0...maxOrbitNum {
            if zones.contains(getZone(orbitNum)!) && getSatellite(orbitNum) != nil {
                satellites.append(getSatellite(orbitNum)!)
            }
        }
        return satellites
    }
    /**
 Obtain a random available habitable or outer orbit.
 - Returns: A random unoccupied orbit within the habitable and outer zones. If
     there are no available orbits in those zones, the outcome is undefined.
 */
    func getAvailHabitableOrOuterOrbit() -> Float? {
        // returns a random available habitable or outer orbit number.
        var orbit: Float?
        let possibilities = getAvailOrbits(Set<Zone>([Zone.H, Zone.O]))
        if DEBUG { print("AvailHabOut on \(name); AvailOrbits returned \(possibilities)") }
        if possibilities.count > 0 {
            orbit = possibilities[Dice.roll(1, sides: possibilities.count)-1]
        }
        return orbit
    }

    /// The number of available orbits in the habitable and outer zones.
    var availHabOuterOrbits: Int {
        getAvailOrbits(Set<Zone>([Zone.H, Zone.O]), createIfNone: false).count
    }

    /// The number of available habitable, inner, outer and uninhabitable orbits.
    var availOrbits: Int {
        getAvailOrbits(Set<Zone>([Zone.H, Zone.I, Zone.O, Zone.U]), createIfNone: false).count
    }

    /**
 Roll for the maximum number of orbits
 - Returns:
     the maximum number of orbits for the star as rolled
 */
    func getMaxOrbitNum() -> Int {
        // determine maximum orbits
        var orbitDM: Int = 0
        var result: Int
        if starDetail.starSize == .III { orbitDM += 4}
        if starDetail.starSize == .II { orbitDM += 8}
        if starDetail.starType == .M { orbitDM -= 4}
        if starDetail.starType == .K { orbitDM -= 2}
        result = Dice.roll(2) + orbitDM
        if result < 0 { result = 0 }
        // maximum orbits is open-ended so no need to place upper limits.
        return result
    }

    /**
 Obtain a random orbit for a companion star.
     
 - parameters:
     - dm: The dice modifier for the throw.
 - Returns:
     A tuple containing
        - orbitNum: The orbit number.
        - inFarOrbit: True if the orbit number is Far, and thus the
                 companion could have its own companion.
 - Note:
     Curiously, the distribution of possible companion orbits is seemingly
     quite arbitrary.
     - orbit 4 is not possible(!);
     - orbit 14 has about 1% chance;
     - orbit 13 has a 2% chance;
     - orbit 5 has a 3% chance;
     - orbit 12 has a 4% chance;
     - orbit 6 has a 5% chance;
     - orbit 11 has a 6% chance;
     - orbit 7 has a 7% chance;
     - orbits 0, 1 and 8 have about 8% chance each;
     - orbits 9 and 10 have a 9% chance each;
     - orbit 2 has an 11% chance;
     - orbit 3 has a 14% chance;
     
     However, this implementation is based on the rules as written, so the
     weirdness remains. The only thing I've done is to turn the "far" orbits
     into real ones: under the rules as written, "far" is 1D6 * 1,000 AU.
     This puts
     - 1 at about orbit 13.7,
     - 2 at about orbit 14.7,
     - 3 at about orbit 15.3,
     - 4 at about orbit 15.7,
     - 5 at about orbit 16 and
     - 6 at about orbit 16.3.
     
     */
    func getCompanionOrbit(_ diceModifier: Int)->(orbitNum: Float, inFarOrbit: Bool) {

        var farOrbit: Bool = false
        var orbit: Float

        let primaryRoll = Dice.roll(2) + diceModifier
        switch primaryRoll {
        case 0..<4: orbit = -1.0
        case 4..<7: orbit = Float(primaryRoll - 3)
        case 7..<12: orbit = Float(primaryRoll - 3 + Dice.roll())
        default:
            farOrbit = true
            switch Dice.roll() {
            case 1: orbit = 13.7
            case 2: orbit = 14.7
            case 3: orbit = 15.3
            case 4: orbit = 15.7
            case 5: orbit = 16
            default:orbit = 16.3
            }
        }
        return (orbit, farOrbit)
    }
}
