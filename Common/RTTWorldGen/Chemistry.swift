//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation

enum Chemistry: String, CustomStringConvertible {
    case water, ammonia, methane, sulfur, chlorine
    var description: String {
        self.rawValue.uppercaseFirst
    }
}
