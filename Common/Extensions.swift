//
//  Extensions.swift
//  StarSystems
//
//  Created by Christopher Green on 23/12/17.
//  Copyright © 2017 Christopher Green. All rights reserved.
//

import Foundation

extension String {
    // shorthand padding with spaces to a given length
    func padding(_ length: Int) -> String {
        return self.padding(toLength: length, withPad: " ", startingAt: 0)
    }
    // return the first character of the string
    var first: String {
        return String(prefix(1))
    }
    // return the last character of the string
    var last: String {
        return String(suffix(1))
    }
    // return the string with the first character uppercased
    var uppercaseFirst: String {
        return first.uppercased() + String(dropFirst())
    }
}

extension Int {
    /**
     return an ordinal string representation for an Int.
     - parameters:
     - things: the name of the entity that the Int counts. It is used
     as part of the string, and pluralised when appropriate.
     - returns:
     A string of the form "is|are *n* *thing*|*thing*s" where the
     choice of is/are and plural strings are dependend on the value
     of *n*.
     */
    func strord(_ things: String)->String {
        var result = ""
        var isAre = ""
        var plural = ""
        if self == 1 {
            isAre = "is "
        } else {
            isAre = "are "
            plural = "s"
        }
        result += String(self)
        result += " "
        result += things
        
        return "\(isAre) \(self) \(things)\(plural)"
    }
    
    var b36:String {
        return String(self, radix:36, uppercase:true)
    }

}

