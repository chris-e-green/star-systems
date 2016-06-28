//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation
enum TradeCodes: CustomStringConvertible {
    case Ag, As, De, Fl, Ga, Hi, Ht, Ic, In, Lo
    case Lt, Na, Ni, Po, Ri, St, Wa, Va, Zo
    var description: String {
        switch self {
        case Ag: return "Agricultural"
        case As: return "Asteroid Belt"
        case De: return "Desert"
        case Fl: return "Fluid Oceans"
        case Ga: return "Garden"
        case Hi: return "High Population"
        case Ht: return "High Technology"
        case Ic: return "Ice-Capped"
        case In: return "Industrial"
        case Lo: return "Low Population"
        case Lt: return "Low Technology"
        case Na: return "Non-Agricultural"
        case Ni: return "Non-Industrial"
        case Po: return "Poor"
        case Ri: return "Rich"
        case St: return "Sterile"
        case Wa: return "Water World"
        case Va: return "Vacuum"
        case Zo: return "Zoo"
        }
    }
}
