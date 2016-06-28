//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation


extension Int {
    var b36:String {
        return String(self, radix:36, uppercase:true)
    }
}
