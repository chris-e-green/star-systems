//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation

enum Habitation: String, CustomStringConvertible {
    case Homeworld, Colony, Outpost, Uninhabited
    var description: String {
        return self.rawValue
    }
}

