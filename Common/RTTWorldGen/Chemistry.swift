//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation

enum Chemistry: String, CustomStringConvertible {
    case Water, Ammonia, Methane, Sulfur, Chlorine
    var description: String {
        return self.rawValue
    }
}
