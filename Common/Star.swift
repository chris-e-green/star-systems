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
enum StarType:String, CustomStringConvertible,Codable,Hashable {
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
    var hashValue: Int {
        return Int(self.rawValue.utf8.first!)
    }
}

/// Possible star sizes
enum StarSize:String,CustomStringConvertible,Codable {
    case Ia
    case Ib
    case II
    case III
    case IV
    case V
    case D
    case Z
    var description:String {
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
    var hashValue: Int {
        switch (self) {
        case .Ia: return 0;
        case .Ib: return 1;
        case .II: return 2;
        case .III: return 3;
        case .IV: return 4;
        case .V: return 5;
        case .D: return 6;
        case .Z: return 7;
        }
    }
}

/// Contains the spectrum and size information for the star and a hash
/// so that different stars can be compared.
struct StarDetail:Hashable,Equatable,Codable {
    var t: StarType
    var d: Int
    var s: StarSize
    var hashValue: Int {
        get {
            return self.t.hashValue * 100 + self.d * 10 + self.s.hashValue
        }
    }
}

/// return true if the compared stars have the same spectrum and size
func ==(lhs: StarDetail, rhs: StarDetail) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

/// Possible orbit zones around a star
enum Zone: String, CustomStringConvertible {
    case O
    case H
    case I
    case U
    case W
    case C
    case Z
    var description:String {
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

/// the various stellar attributes from Traveller Book 6
let stellarAttrs:[StarDetail:(bolMagnitude:Double, luminosity:Double, effTemp:Double, radii: Double, mass: Double)] = [
    StarDetail(t: .B, d: 0, s: .Ia):  (-9.6, 560_000,    22_000,   52,    60),
    StarDetail(t: .B, d: 5, s: .Ia):  (-8.5, 204_000,    14_200,   75,    30),
    StarDetail(t: .A, d: 0, s: .Ia):  (-7.8, 107_000,     9_000,  135,    18),
    StarDetail(t: .A, d: 5, s: .Ia):  (-7.5,  81_000,     8_000,  149,    15),
    StarDetail(t: .F, d: 0, s: .Ia):  (-7.2,  61_000,     6_900,  174,    13),
    StarDetail(t: .F, d: 5, s: .Ia):  (-7.0,  51_000,     6_100,  204,    12),
    StarDetail(t: .G, d: 0, s: .Ia):  (-7.3,  67_000,     5_400,  298,    12),
    StarDetail(t: .G, d: 5, s: .Ia):  (-7.6,  89_000,     4_700,  454,    13),
    StarDetail(t: .K, d: 0, s: .Ia):  (-7.7,  97_000,     4_000,  654,    14),
    StarDetail(t: .K, d: 5, s: .Ia):  (-7.8, 107_000,     3_300, 1010,    18),
    StarDetail(t: .M, d: 0, s: .Ia):  (-7.9, 117_000,     2_800, 1467,    20),
    StarDetail(t: .M, d: 5, s: .Ia):  (-8.0, 129_000,     2_000, 3020,    25),
    StarDetail(t: .M, d: 9, s: .Ia):  (-8.1, 141_000,     1_900, 3499,    30),
    
    StarDetail(t: .B, d: 0, s: .Ib):  (-8.8, 270_000,    24_000,   30,    50),
    StarDetail(t: .B, d: 5, s: .Ib):  (-6.9,  46_700,    14_500,   35,    25),
    StarDetail(t: .A, d: 0, s: .Ib):  (-5.7,  15_000,     9_100,   50,    16),
    StarDetail(t: .A, d: 5, s: .Ib):  (-5.4,  11_700,     8_100,   55,    13),
    StarDetail(t: .F, d: 0, s: .Ib):  (-4.9,   7_400,     7_000,   59,    12),
    StarDetail(t: .F, d: 5, s: .Ib):  (-4.5,   5_100,     6_300,   60,    10),
    StarDetail(t: .G, d: 0, s: .Ib):  (-4.7,   6_100,     5_600,   84,    10),
    StarDetail(t: .G, d: 5, s: .Ib):  (-5.0,   8_100,     4_850,  128,    12),
    StarDetail(t: .K, d: 0, s: .Ib):  (-5.4,  11_700,     4_100,  216,    13),
    StarDetail(t: .K, d: 5, s: .Ib):  (-6.0,  20_400,     3_500,  392,    16),
    StarDetail(t: .M, d: 0, s: .Ib):  (-6.9,  46_000,     2_900,  857,    16),
    StarDetail(t: .M, d: 5, s: .Ib):  (-7.6,  89_000,     2_200, 2073,    20),
    StarDetail(t: .M, d: 9, s: .Ib):  (-7.9, 117_000,     2_000, 2876,    25),
    
    StarDetail(t: .B, d: 0, s: .II):  (-8.3, 170_000,    25_000,   22,    30),
    StarDetail(t: .B, d: 5, s: .II):  (-5.9,  18_600,    15_100,   20,    20),
    StarDetail(t: .A, d: 0, s: .II):  (-3.6,   2_200,     9_300,   18,    14),
    StarDetail(t: .A, d: 5, s: .II):  (-2.55,    850,     8_200,   14,    11),
    StarDetail(t: .F, d: 0, s: .II):  (-2.18,    600,     7_100,   16,    10),
    StarDetail(t: .F, d: 5, s: .II):  (-2.0,     510,     6_400,   18,     8.1),
    StarDetail(t: .G, d: 0, s: .II):  (-2.1,     560,     5_700,   25,     8.1),
    StarDetail(t: .G, d: 5, s: .II):  (-2.4,     740,     5_000,   37,    10),
    StarDetail(t: .K, d: 0, s: .II):  (-2.6,     890,     4_300,   54,    11),
    StarDetail(t: .K, d: 5, s: .II):  (-3.7,   2_450,     3_650,  124,    14),
    StarDetail(t: .M, d: 0, s: .II):  (-4.4,   4_600,     3_100,  237,    14),
    StarDetail(t: .M, d: 5, s: .II):  (-5.65, 14_900,     2_400,  712,    16),
    StarDetail(t: .M, d: 9, s: .II):  (-5.75, 16_200,     2_100,  931,    18),

    StarDetail(t: .B, d: 0, s: .III): (-7.8, 107_000,    26_000,   16,    25),
    StarDetail(t: .B, d: 5, s: .III): (-3.5,   6_700,    15_200,   10,    15),
    StarDetail(t: .A, d: 0, s: .III): (-1.36,    280,     9_500,    6.2,  12),
    StarDetail(t: .A, d: 5, s: .III): (-0.1,      90,     8_300,    4.6,   9),
    StarDetail(t: .F, d: 0, s: .III): ( 0.45,     53,     7_200,    4.7,   8),
    StarDetail(t: .F, d: 5, s: .III): ( 0.7,      43,     6_500,    5.2,   5),
    StarDetail(t: .G, d: 0, s: .III): ( 0.52,     50,     5_800,    7.1,   2.5),
    StarDetail(t: .G, d: 5, s: .III): ( 0.08,     75,     5_100,   11,     3.2),
    StarDetail(t: .K, d: 0, s: .III): ( 0.17,     95,     4_500,   16,     4),
    StarDetail(t: .K, d: 5, s: .III): (-1.5,     320,     3_800,   42,     5),
    StarDetail(t: .M, d: 0, s: .III): (-1.9,     470,     3_400,   63,     6.3),
    StarDetail(t: .M, d: 5, s: .III): (-3.6,   2_280,     2_650,  228,     7.4),
    StarDetail(t: .M, d: 9, s: .III): (-3.8,   2_690,     2_200,  360,     9.2),
    
    StarDetail(t: .B, d: 0, s: .IV):  (-7.5,  81_000,    27_000,   13,    20),
    StarDetail(t: .B, d: 5, s: .IV):  (-3.1,   2_000,    15_400,    5.3,  10),
    StarDetail(t: .A, d: 0, s: .IV):  (-0.7,     156,     9_700,    4.5,   6),
    StarDetail(t: .A, d: 5, s: .IV):  ( 0.85,     37,     8_400,    2.7,   4),
    StarDetail(t: .F, d: 0, s: .IV):  ( 1.58,     19,     7_300,    2.7,   2.5),
    StarDetail(t: .F, d: 5, s: .IV):  ( 2.1,      12,     6_600,    2.6,   2),
    StarDetail(t: .G, d: 0, s: .IV):  ( 2.74,      6.5,   5_900,    2.5,   1.75),
    StarDetail(t: .G, d: 5, s: .IV):  ( 3.04,      4.9,   5_200,    2.8,   2),
    StarDetail(t: .K, d: 0, s: .IV):  ( 3.1,       4.67,  4_700,    3.3,   2.3),
    
    StarDetail(t: .B, d: 0, s: .V):   (-7.1,  56_000,    28_000,   10,    18),
    StarDetail(t: .B, d: 5, s: .V):   (-2.71,  1_400,    15_500,    4.4,   6.5),
    StarDetail(t: .A, d: 0, s: .V):   (-0.1,      90,     9_900,    3.2,   3.2),
    StarDetail(t: .A, d: 5, s: .V):   ( 1.8,      16,     8_500,    1.8,   2.1),
    StarDetail(t: .F, d: 0, s: .V):   ( 2.5,       8.1,   7_400,    1.7,   1.7),
    StarDetail(t: .F, d: 5, s: .V):   ( 3.4,       3.5,   6_700,    1.4,   1.3),
    StarDetail(t: .G, d: 0, s: .V):   ( 4.57,      1.21,  6_000,    1.03,  1.04),
    StarDetail(t: .G, d: 5, s: .V):   ( 5.2,       0.67,  5_500,    0.91,  0.94),
    StarDetail(t: .K, d: 0, s: .V):   ( 5.7,       0.42,  4_900,    0.908, 0.825),
    StarDetail(t: .K, d: 5, s: .V):   ( 7.4,       0.08,  4_100,    0.566, 0.57),
    StarDetail(t: .M, d: 0, s: .V):   ( 8.25,      0.04,  3_500,    0.549, 0.489),
    StarDetail(t: .M, d: 5, s: .V):   (10.2,       0.007, 2_800,    0.358, 0.331),
    StarDetail(t: .M, d: 9, s: .V):   (13.9,       0.001, 2_300,    0.201, 0.215),
    
    StarDetail(t: .B, d: 0, s: .D):   ( 8.1,       0.046, 25_000,   0.018, 0.26),
    StarDetail(t: .A, d: 0, s: .D):   (10.5,       0.005, 14_000,   0.017, 0.36),
    StarDetail(t: .F, d: 0, s: .D):   (13.6,       0.0003, 6_600,   0.013, 0.42),
    StarDetail(t: .G, d: 0, s: .D):   (15.3,       0.00006,4_500,   0.012, 0.63),
    StarDetail(t: .K, d: 0, s: .D):   (15.6,       0.00004,3_500,   0.009, 0.83),
    StarDetail(t: .M, d: 0, s: .D):   (15.9,       0.00003,2_700,   0.006, 1.11),
    StarDetail(t: .B, d: 5, s: .D):   ( 8.1,       0.046, 25_000,   0.018, 0.26),
    StarDetail(t: .A, d: 5, s: .D):   (10.5,       0.005, 14_000,   0.017, 0.36),
    StarDetail(t: .F, d: 5, s: .D):   (13.6,       0.0003, 6_600,   0.013, 0.42),
    StarDetail(t: .G, d: 5, s: .D):   (15.3,       0.00006,4_500,   0.012, 0.63),
    StarDetail(t: .K, d: 5, s: .D):   (15.6,       0.00004,3_500,   0.009, 0.83),
    StarDetail(t: .M, d: 5, s: .D):   (15.9,       0.00003,2_700,   0.006, 1.11),
    StarDetail(t: .B, d: 9, s: .D):   ( 8.1,       0.046, 25_000,   0.018, 0.26),
    StarDetail(t: .A, d: 9, s: .D):   (10.5,       0.005, 14_000,   0.017, 0.36),
    StarDetail(t: .F, d: 9, s: .D):   (13.6,       0.0003, 6_600,   0.013, 0.42),
    StarDetail(t: .G, d: 9, s: .D):   (15.3,       0.00006,4_500,   0.012, 0.63),
    StarDetail(t: .K, d: 9, s: .D):   (15.6,       0.00004,3_500,   0.009, 0.83),
    StarDetail(t: .M, d: 9, s: .D):   (15.9,       0.00003,2_700,   0.006, 1.11),

]
/// the defined zones for each star type and size from Traveller Book 6
let tableOfZones:[StarDetail:[Zone]] = [
    //                            0  1  2  3  4  5  6  7  8  9 10 11 12 13 14
    StarDetail(t: .B, d: 0, s: .Ia):  [.W,.U,.U,.U,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O],
    StarDetail(t: .B, d: 5, s: .Ia):  [.W,.U,.U,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O],
    StarDetail(t: .A, d: 0, s: .Ia):  [.W,.W,.U,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O],
    StarDetail(t: .A, d: 5, s: .Ia):  [.W,.W,.U,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O],
    StarDetail(t: .F, d: 0, s: .Ia):  [.W,.W,.W,.U,.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O],
    StarDetail(t: .F, d: 5, s: .Ia):  [.W,.W,.W,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O,.O],
    StarDetail(t: .G, d: 0, s: .Ia):  [.W,.W,.W,.W,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O],
    StarDetail(t: .G, d: 5, s: .Ia):  [.W,.W,.W,.W,.W,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O],
    StarDetail(t: .K, d: 0, s: .Ia):  [.W,.W,.W,.W,.W,.W,.U,.I,.I,.I,.I,.I,.H,.O,.O],
    StarDetail(t: .K, d: 5, s: .Ia):  [.W,.W,.W,.W,.W,.W,.U,.I,.I,.I,.I,.I,.H,.O,.O],
    StarDetail(t: .M, d: 0, s: .Ia):  [.W,.W,.W,.W,.W,.W,.W,.I,.I,.I,.I,.I,.H,.O,.O],
    StarDetail(t: .M, d: 5, s: .Ia):  [.W,.W,.W,.W,.W,.W,.W,.W,.I,.I,.I,.I,.H,.O,.O],
    StarDetail(t: .M, d: 9, s: .Ia):  [.W,.W,.W,.W,.W,.W,.W,.W,.I,.I,.I,.I,.H,.O,.O],
    //                            0  1  2  3  4  5  6  7  8  9 10 11 12 13 14
    StarDetail(t: .B, d: 0, s: .Ib):  [.U,.U,.U,.U,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O],
    StarDetail(t: .B, d: 5, s: .Ib):  [.U,.U,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O,.O],
    StarDetail(t: .A, d: 0, s: .Ib):  [.W,.U,.U,.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O],
    StarDetail(t: .A, d: 5, s: .Ib):  [.W,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    StarDetail(t: .F, d: 0, s: .Ib):  [.W,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    StarDetail(t: .F, d: 5, s: .Ib):  [.W,.U,.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    StarDetail(t: .G, d: 0, s: .Ib):  [.W,.U,.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    StarDetail(t: .G, d: 5, s: .Ib):  [.W,.W,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    StarDetail(t: .K, d: 0, s: .Ib):  [.W,.W,.W,.W,.U,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    StarDetail(t: .K, d: 5, s: .Ib):  [.W,.W,.W,.W,.W,.U,.I,.I,.I,.I,.I,.H,.O,.O,.O],
    StarDetail(t: .M, d: 0, s: .Ib):  [.W,.W,.W,.W,.W,.W,.I,.I,.I,.I,.I,.H,.O,.O,.O],
    StarDetail(t: .M, d: 5, s: .Ib):  [.W,.W,.W,.W,.W,.W,.W,.I,.I,.I,.I,.I,.H,.O,.O],
    StarDetail(t: .M, d: 9, s: .Ib):  [.W,.W,.W,.W,.W,.W,.W,.W,.I,.I,.I,.I,.H,.O,.O],
    //                            0  1  2  3  4  5  6  7  8  9 10 11 12 13
    StarDetail(t: .B, d: 0, s: .II):  [.U,.U,.U,.U,.U,.U,.U,.I,.I,.I,.I,.I,.H,.O],
    StarDetail(t: .B, d: 5, s: .II):  [.U,.U,.U,.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O],
    StarDetail(t: .A, d: 0, s: .II):  [.U,.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    StarDetail(t: .A, d: 5, s: .II):  [.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O],
    StarDetail(t: .F, d: 0, s: .II):  [.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O],
    StarDetail(t: .F, d: 5, s: .II):  [.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O],
    StarDetail(t: .G, d: 0, s: .II):  [.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O],
    StarDetail(t: .G, d: 5, s: .II):  [.U,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O],
    StarDetail(t: .K, d: 0, s: .II):  [.W,.U,.I,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    StarDetail(t: .K, d: 5, s: .II):  [.W,.W,.U,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    StarDetail(t: .M, d: 0, s: .II):  [.W,.W,.W,.W,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O],
    StarDetail(t: .M, d: 5, s: .II):  [.W,.W,.W,.W,.W,.W,.I,.I,.I,.I,.I,.H,.O,.O],
    StarDetail(t: .M, d: 9, s: .II):  [.W,.W,.W,.W,.W,.W,.I,.I,.I,.I,.I,.H,.O,.O],
    //                            0  1  2  3  4  5  6  7  8  9 10 11 12 13
    StarDetail(t: .A, d: 0, s: .III): [.I,.I,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O],
    StarDetail(t: .A, d: 5, s: .III): [.I,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .F, d: 0, s: .III): [.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .F, d: 5, s: .III): [.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .G, d: 0, s: .III): [.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .G, d: 5, s: .III): [.I,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .K, d: 0, s: .III): [.I,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .K, d: 5, s: .III): [.W,.I,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O],
    StarDetail(t: .M, d: 0, s: .III): [.W,.W,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O],
    StarDetail(t: .M, d: 5, s: .III): [.W,.W,.W,.W,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    StarDetail(t: .M, d: 9, s: .III): [.W,.W,.W,.W,.W,.I,.I,.I,.I,.H,.O,.O,.O,.O],
    //                            0  1  2  3  4  5  6  7  8  9 10 11 12 13
    StarDetail(t: .A, d: 0, s: .IV):  [.W,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .A, d: 5, s: .IV):  [.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .F, d: 0, s: .IV):  [.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .F, d: 5, s: .IV):  [.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .G, d: 0, s: .IV):  [.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .G, d: 5, s: .IV):  [.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .K, d: 0, s: .IV):  [.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    //                            0  1  2  3  4  5  6  7  8  9 10 11 12 13
    StarDetail(t: .A, d: 0, s: .V):   [.I,.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .A, d: 5, s: .V):   [.I,.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .F, d: 0, s: .V):   [.I,.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .F, d: 5, s: .V):   [.I,.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .G, d: 0, s: .V):   [.I,.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .G, d: 5, s: .V):   [.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .K, d: 0, s: .V):   [.I,.I,.H,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .K, d: 5, s: .V):   [.H,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .M, d: 0, s: .V):   [.H,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .M, d: 5, s: .V):   [.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    StarDetail(t: .M, d: 9, s: .V):   [.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O,.O],
    //                            0  1  2  3  4
    StarDetail(t: .B, d: 0, s: .D):   [.H,.O,.O,.O,.O],
    StarDetail(t: .B, d: 5, s: .D):   [.H,.O,.O,.O,.O],
    StarDetail(t: .B, d: 9, s: .D):   [.H,.O,.O,.O,.O],
    //                            0  1  2  3  4
    StarDetail(t: .A, d: 0, s: .D):   [.O,.O,.O,.O,.O],
    StarDetail(t: .A, d: 5, s: .D):   [.O,.O,.O,.O,.O],
    StarDetail(t: .A, d: 9, s: .D):   [.O,.O,.O,.O,.O],
    //                            0  1  2  3  4
    StarDetail(t: .F, d: 0, s: .D):   [.O,.O,.O,.O,.O],
    StarDetail(t: .F, d: 5, s: .D):   [.O,.O,.O,.O,.O],
    StarDetail(t: .F, d: 9, s: .D):   [.O,.O,.O,.O,.O],
    //                            0  1  2  3  4
    StarDetail(t: .G, d: 0, s: .D):   [.O,.O,.O,.O,.O],
    StarDetail(t: .G, d: 5, s: .D):   [.O,.O,.O,.O,.O],
    StarDetail(t: .G, d: 9, s: .D):   [.O,.O,.O,.O,.O],
    //                            0  1  2  3  4
    StarDetail(t: .K, d: 0, s: .D):   [.O,.O,.O,.O,.O],
    StarDetail(t: .K, d: 5, s: .D):   [.O,.O,.O,.O,.O],
    StarDetail(t: .K, d: 9, s: .D):   [.O,.O,.O,.O,.O],
    //                            0  1  2  3  4
    StarDetail(t: .M, d: 0, s: .D):   [.O,.O,.O,.O,.O],
    StarDetail(t: .M, d: 5, s: .D):   [.O,.O,.O,.O,.O],
    StarDetail(t: .M, d: 9, s: .D):   [.O,.O,.O,.O,.O],
]

/// The class that defines all stars.
class Star : Satellite, /*Hashable, Equatable, */CustomStringConvertible {
    //    var type: StarType = .A
    //    var decimal: Int = 0
    //    var size: StarSize = .Ia
    var starDetail: StarDetail = StarDetail(t:.A,d:0,s:.Ia)
    var magnitude: Double = 0
    // despite its name, 'maximum orbits' is described in the text as "the highest numbered orbit available". Given that the system allows orbit 0, that means that the maximum number of orbits is actually one higher than 'max orbits'...
    // so to avoid further confusion, I am calling the variable 'maxOrbitNum'.
    var maxOrbitNum: Int = 0
    //    var hashValue: Int {get {return self.type.hashValue * 100 + self.decimal * 10 + self.size.hashValue}}
    
    var specSizeDescription: String {
        return "\(starDetail.t), \(starDetail.s) Star"
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
        if let p = parent as? Star {
            result += " companion star to \(p.name)"
        }
        result += ". "
        return result
    }
    
    var specSize: String {
        var result = ""
        if starDetail.s == .D { result += "\(starDetail.s.rawValue)\(starDetail.t.rawValue)" }
        else { result += "\(starDetail.t.rawValue)\(starDetail.d) \(starDetail.s.rawValue)" }
        return result
    }
    var description : String {
        var d: String = ""
        d += starDesc
        //        d += "Max orbit number = \(maxOrbitNum)\n"
        //        if parent == nil {
        d += "\(satDesc)"
        //        }
        return d
    }
        
    override var json: String {
        var result = ""
        result += "\"\(jsonLabels.star)\":\n"
        result += "{\n"
        result += "\t\"\(jsonLabels.name)\": \"\(name)\",\n"
        result += "\t\"\(jsonLabels.type)\": \"\(starDetail.t.rawValue)\",\n"
        result += "\t\"\(jsonLabels.decimal)\": \"\(starDetail.d)\",\n"
        result += "\t\"\(jsonLabels.size)\": \"\(starDetail.s.rawValue)\",\n"
        result += "\t\"\(jsonLabels.satellites)\": [\n"
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
        self.init(t: type, d: decimal, s: size)
        self.starDetail.t = type
        self.starDetail.d = decimal
        self.starDetail.s = size
        self.magnitude = (stellarAttrs[starDetail]?.bolMagnitude)!
        self.parent = parent
    }
    
    init(t: StarType = .A, d: Int = 0, s: StarSize = .Ia, p: Star? = nil) {
        super.init(parent:p)
        self.starDetail.t = t
        self.starDetail.d = d
        self.starDetail.s = s
        self.magnitude = (stellarAttrs[starDetail]?.bolMagnitude)!
        self.name = Name(maxLength: maxNameLength).description
    }
    
    convenience init(companion: Bool, typeRoll:Int, sizeRoll:Int, parent: Star? = nil) {
        self.init()
        self.parent = parent
        if companion {
            switch typeRoll {
            case 1:   self.starDetail.t = .B
            case 2:   self.starDetail.t = .A
            case 3,4: self.starDetail.t = .F
            case 5,6: self.starDetail.t = .G
            case 7,8: self.starDetail.t = .K
            default:  self.starDetail.t = .M
            }
        } else {
            switch typeRoll {
            case 2:     self.starDetail.t = .A
            case 3...7: self.starDetail.t = .M
            case 8:     self.starDetail.t = .K
            case 9,10:  self.starDetail.t = .G
            default:    self.starDetail.t = .F
            }
        }
        
        if Dice.roll(1) <= 3 { self.starDetail.d = 0 } else { self.starDetail.d = 5}
        
        if companion {
            switch sizeRoll {
            case 0: self.starDetail.s = .Ia
            case 1: self.starDetail.s = .Ib
            case 2: self.starDetail.s = .II
            case 3: self.starDetail.s = .III
            case 4: self.starDetail.s = .IV
            case 5...11: self.starDetail.s = .V
            default: self.starDetail.s = .D
            }
        } else {
            switch sizeRoll {
            case 2: self.starDetail.s = .II
            case 3: self.starDetail.s = .III
            case 4: self.starDetail.s = .IV
            default: self.starDetail.s = .V
            }
        }
        if ((self.starDetail.t == .K && self.starDetail.d == 5) || (self.starDetail.t == .M)) && (self.starDetail.s == .IV) {
            self.starDetail.s = .V
        }
        self.magnitude = (stellarAttrs[starDetail]?.bolMagnitude)!

    }
    
    /// Get the main world of this system (if such a thing exists).
    /// The main world is the planet with the highest population, and if there's more than
    /// one, by preference one in the habitable zone, otherwise the one closest to the sun.
    ///
    /// - returns:
    ///      The planet (if one exists) that matches the criteria.
    func getMainWorld()->Planet? {
        var mainWorld: Planet?
        var minOrbit: Float = Float.infinity
        let (worlds, _) = getMaxPop()  // worlds is an array of worlds that have the maximum population.
        // now we need to weed out to find the actual mainworld.
        for planet in worlds {
            if let p1 = planet {
                // habitable is first preference
                if p1.zone == Zone.H {
                    mainWorld = planet
                } else {
                    if p1.stellarOrbit < minOrbit {
                        mainWorld = planet
                        minOrbit = p1.stellarOrbit
                    }
                }
            }
        }
        return mainWorld
    }
    
    /// Obtain a random orbit number in the inner, habitable or outer zone.
    /// - Returns: A random available inner, habitable or outer orbit number.
    func getAvailOrbit() -> Float {
        var o:Float
        var possibilities = getAvailOrbits(Set<Zone>([Zone.H, Zone.O, Zone.I]))
        if DEBUG { print("Avail on \(name); AvailOrbits returned \(possibilities)") }
        let r = Dice.roll(1, sides:possibilities.count)
        o = possibilities[r-1]
        return o
    }

    /// Obtain a random orbit number in any zone except within the star.
    /// - Returns: A random available orbit number except within the star.
    func getAnyAvailOrbit() -> Float {
        var o:Float
        var possibilities = getAvailOrbits(Set<Zone>([Zone.H, Zone.O, Zone.I, Zone.U]))
        if DEBUG { print("Avail on \(name); AnyAvailOrbits returned \(possibilities)") }
        let r = Dice.roll(1, sides:possibilities.count)
        o = possibilities[r-1]
        return o
    }

    /// Obtain a random orbit number in the inner or outer zone.
    /// - Returns: A random available inner or outer orbit number.
    func getAvailInOutOrbit() -> Float? {
        var o:Float?
        var possibilities = getAvailOrbits(Set<Zone>([Zone.O, Zone.I]))
        if DEBUG { print("AvailInOut on \(name); AvailOrbits returned \(possibilities)") }
        if possibilities.count > 0 {
            let r = Dice.roll(1, sides:possibilities.count)
            o = possibilities[r-1]
        }
        return o
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
    func getAvailOrbits(_ zones:Set<Zone>, createIfNone: Bool=true)->[Float] {
        var orbits:[Float] = []
        for i in 0...maxOrbitNum {
            if zones.contains(getZone(i)!) && getSatellite(i) == nil {
                orbits.append(Float(i))
            }
        }
        if createIfNone {
            // if we found no orbits, and we've been asked to, we'll make one.
            if orbits.count == 0 {
                // we can't just blindly increment to the next orbit, because it might be occupied by a star, a captured planet, or an empty orbit.
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
    func createOuterZone()->Float {
        var result: Float = 0.0
        // first, we need to find out whether the current max orbit number is already in the outer zone.
        if getZone(maxOrbitNum) == Zone.O {
            // it is, so we just need to get to the next available orbit number and return that one (we need to make sure we don't collide with something...)
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
    func getHabOrbit()->Float? {
        var result: Float?
        if let zones:[Zone] = tableOfZones[self.starDetail] {
            if zones.index(of: Zone.H) != nil {
                result = Float(zones.index(of: Zone.H)!)
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
    func getSatellites(_ zones:Set<Zone>)->[Satellite] {
        var satellites:[Satellite] = []
        for i in 0...maxOrbitNum {
            if zones.contains(getZone(i)!) && getSatellite(i) != nil {
                satellites.append(getSatellite(i)!)
            }
        }
        return satellites
    }
    /**
 Obtain a random available habitable or outer orbit.
 - Returns: A random unoccupied orbit within the habitable and outer zones. If
     there are no available orbits in those zones, the outcome is undefined.
 */
    func getAvailHabitableOrOuterOrbit()->Float? {
        // returns a random available habitable or outer orbit number.
        var o:Float?
        var possibilities = getAvailOrbits(Set<Zone>([Zone.H, Zone.O]))
        if DEBUG { print("AvailHabOut on \(name); AvailOrbits returned \(possibilities)") }
        if possibilities.count > 0 {
            let r = Dice.roll(1, sides:possibilities.count)
            o = possibilities[r-1]
        }
        return o
    }
    
    /// The number of available orbits in the habitable and outer zones.
    var availHabOuterOrbits:Int {
        return getAvailOrbits(Set<Zone>([Zone.H, Zone.O]), createIfNone: false).count
    }
    
    /// The number of available habitable, inner, outer and uninhabitable orbits.
    var availOrbits:Int {
        return getAvailOrbits(Set<Zone>([Zone.H, Zone.I, Zone.O, Zone.U]), createIfNone: false).count
    }
    
    /**
 Roll for the maximum number of orbits
 - Returns:
     the maximum number of orbits for the star as rolled
 */
    func getMaxOrbitNum() -> Int {
        // determine maximum orbits
        var orbitDM : Int = 0
        var result: Int
        if starDetail.s == .III { orbitDM += 4}
        if starDetail.s == .II { orbitDM += 8}
        if starDetail.t == .M { orbitDM -= 4}
        if starDetail.t == .K { orbitDM -= 2}
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
    func getCompanionOrbit(_ dm: Int)->(orbitNum: Float, inFarOrbit: Bool) {

        
        var farOrbit: Bool = false
        var orbit: Float
        
        switch Dice.roll(2) + dm {
        case 0..<4: orbit = -1 // aka 'close' orbit
        case 4:     orbit = 1
        case 5:     orbit = 2
        case 6:     orbit = 3
        case 7:     orbit = 4 + Float(Dice.roll(1))
        case 8:     orbit = 5 + Float(Dice.roll(1))
        case 9:     orbit = 6 + Float(Dice.roll(1))
        case 10:    orbit = 7 + Float(Dice.roll(1))
        case 11:    orbit = 8 + Float(Dice.roll(1))
        default: // if its not one of the above it's "far".
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
//func ==(lhs: Star, rhs: Star) -> Bool {
//    return lhs.hashValue == rhs.hashValue
//}
