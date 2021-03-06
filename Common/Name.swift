//
//  Name.swift
// names - generate random names from frequency data.
//
//  Created by Christopher Green on 9/5/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//
// My name algorithm is derived from English word frequency data. The length of
// the name and the initial letter are based on http://norvig.com/mayzner.html
// while the subsequent letters are based on
// http://homepages.math.uic.edu/~leon/mcs425-s08/handouts/char_freq2.pdf
//
// As an alternative generator, the algorithm used in the 'Frontier' game is
// also implemented (found it somewhere on the net...)
//

import Foundation

enum NameAlgorithm {
    case randomLetters
    case frontier
}

class Name: CustomStringConvertible {

    var name: String = ""
    var maxNameLength = 0
    var algorithm: NameAlgorithm

    // the cumulative distribution of word lengths. Thee array is the chance
    // (out of the maximum) that a word would be of that length. For example, if
    // a 97565-sided dice was thrown and it came up 700, the word length would
    // be 3 (because it's greater than 688 and less than or equal to 5303).

    let wordLengthCD: [Int] = [26, 688, 5303, 12280, 22821, 36162, 50554, 63838,
                              74917, 83385, 89154, 92854, 95126, 96328, 96996,
                              97279, 97437, 97501, 97541, 97557, 97558,
                              97563, 97565]

    // the cumulative distribution of initial letters, using the same approach
    // as for word length. If a 100,000-sided dice was thrown and it came up
    // 20,000, the first letter would be D.
    let initialLetterCD: [Int] = [11602, 16304, 19815, 22485, 24492,
                                 28271, 30221, 37453, 43739, 44336, 44926,
                                 47631, 52014, 54379, 60643, 63188, 63361,
                                 65014, 72769, 89440, 90927, 91576, 98329,
                                 98346, 99966, 100000]

    // the cumulative distribution of subsequent letters, based on the preceding
    // letter. The same approach as above, but mapped against the latest letter
    // in the word. For example, if the latest letter was 'D', we would roll a
    // 478-sided die. If it came up 70, the next letter would be 'C'.
    // Certain combinations basically don't happen very often (or at all) in
    // English and these are clear from the table. For example, X followed by A
    // happens 1/12, but never X followed by B. XC yes, XD no. XE yes, XF, XG, XH no.
    // The last value in each array of Int is the maximum possible for that sequence
    // and is used as the maximum value for the random number generator.
    let followingLetterProbabilities: [Character: [Int]] = [
        "w": [  66, 67, 68, 70, 109, 110, 110, 154, 193, 193, 193, 195, 196,
               208, 237, 237, 237, 240, 244, 248, 249, 249, 251, 251, 252, 252],
        "n": [  40, 47, 72, 218, 284, 292, 384, 400, 433, 435, 443, 452, 459,
               467, 527, 531, 532, 535, 568, 674, 680, 682, 694, 694, 705, 705],
        "u": [   7, 12, 24, 31, 38, 40, 54, 56, 64, 64, 65, 99, 107,
               143, 144, 160, 160, 204, 239, 287, 287, 287, 289, 289, 290, 290],
        "v": [   5, 5, 5, 5, 70, 70, 70, 70, 81, 81, 81, 81, 81,
                81, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 86, 86],
        "x": [   1, 1, 3, 3, 4, 4, 4, 4, 6, 6, 6, 6, 6,
                 6, 6, 9, 9, 9, 9, 12, 12, 12, 12, 12, 12, 12],
        "q": [   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                 0, 0, 0, 0, 0, 0, 0, 9, 9, 9, 9, 9, 9],
        "b": [  11, 12, 12, 12, 59, 59, 59, 59, 65, 66, 66, 83, 83,
                83, 102, 102, 102, 113, 115, 116, 137, 137, 137, 137, 148, 148],
        "r": [  50, 57, 67, 87, 220, 228, 238, 250, 300, 301, 309, 319, 333,
               349, 404, 410, 410, 424, 461, 503, 515, 519, 530, 530, 551, 551],
        "c": [  31, 31, 35, 35, 73, 73, 73, 111, 121, 121, 139, 148, 148,
               148, 193, 193, 194, 205, 206, 221, 228, 228, 228, 228, 229, 229],
        "e": [ 110, 133, 178, 304, 352, 382, 397, 430, 471, 474, 479, 534, 581,
               692, 725, 753, 755, 924, 1039, 1122, 1128, 1152, 1202, 1211, 1237, 1237],
        "y": [  18, 25, 31, 37, 51, 58, 61, 71, 82, 83, 84, 88, 94,
                97, 133, 137, 137, 140, 159, 179, 180, 181, 193, 193, 195, 195],
        "h": [ 114, 116, 118, 119, 421, 423, 424, 430, 527, 527, 527, 529, 532,
               533, 582, 583, 583, 591, 596, 628, 636, 636, 640, 640, 644, 644],
        "j": [   2, 2, 2, 2, 4, 4, 4, 4, 7, 7, 7, 7, 7,
                 7, 10, 10, 10, 10, 10, 10, 18, 18, 18, 18, 18, 18],
        "p": [  23, 24, 24, 24, 54, 55, 55, 58, 70, 70, 70, 85, 86,
                86, 107, 117, 117, 135, 140, 151, 157, 157, 158, 158, 159, 159],
        "f": [  25, 27, 30, 32, 52, 63, 64, 72, 95, 96, 96, 104, 109,
               110, 150, 152, 152, 168, 173, 210, 218, 218, 221, 221, 223, 223],
        "o": [  16, 28, 41, 59, 64, 144, 151, 162, 174, 175, 188, 214, 262,
               368, 404, 419, 419, 503, 531, 588, 703, 715, 761, 761, 766, 767],
        "k": [   6, 7, 8, 9, 38, 39, 39, 41, 55, 55, 55, 57, 58,
                67, 71, 71, 71, 71, 76, 80, 81, 81, 83, 83, 85, 85],
        "d": [  48, 68, 77, 90, 147, 158, 165, 190, 240, 243, 244, 255, 269,
               285, 326, 332, 332, 346, 381, 437, 447, 449, 468, 468, 478, 478],
        "t": [  59, 69, 80, 87, 162, 171, 174, 504, 580, 581, 583, 600, 611,
               618, 733, 737, 737, 765, 799, 855, 872, 873, 904, 904, 920, 920],
        "z": [   1, 1, 1, 1, 4, 4, 4, 4, 5, 5, 5, 5, 5,
                 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],
        "a": [   1, 21, 54, 106, 106, 118, 136, 141, 180, 181, 193, 250, 276,
               457, 458, 478, 479, 554, 649, 753, 762, 782, 795, 796, 822, 823],
        "i": [  10, 15, 47, 80, 103, 120, 145, 151, 152, 153, 161, 198, 235,
               414, 438, 444, 444, 471, 557, 650, 651, 665, 672, 674, 674, 676],
        "m": [  44, 51, 52, 53, 121, 123, 124, 127, 152, 152, 152, 153, 158,
               160, 189, 200, 200, 203, 213, 222, 230, 230, 234, 234, 252, 252],
        "s": [  67, 78, 95, 102, 176, 187, 191, 241, 290, 292, 298, 311, 323,
               333, 390, 410, 412, 416, 459, 568, 588, 590, 614, 614, 618, 618],
        "g": [  24, 27, 29, 31, 59, 62, 66, 101, 119, 120, 120, 127, 130,
               134, 157, 158, 158, 170, 179, 195, 202, 202, 207, 207, 208, 208],
        "l": [  40, 43, 45, 81, 145, 155, 156, 160, 207, 207, 210, 266, 270,
               272, 313, 316, 316, 318, 329, 344, 352, 355, 360, 360, 391, 391]
    ]

    let frontierBits = [
        "en", "la", "can", "be", "and", "phi", "eth", "ol", "ve", "ho", "a",
        "lia", "an", "ar", "ur", "mi", "in", "ti", "qu", "so", "ed", "ess",
        "ex", "io", "ce", "ze", "fa", "ay", "wa", "da", "ack", "gre"]

    init(maxLength: Int = 0, nameAlgorithm: NameAlgorithm = NameAlgorithm.frontier) {
        algorithm = nameAlgorithm
        switch algorithm {
        case .randomLetters:
        maxNameLength = maxLength
        let randomLength = Int(arc4random_uniform(UInt32(wordLengthCD.last!)))
        var nameLen = 1
        for index in 0..<wordLengthCD.count where wordLengthCD[index] >= randomLength {
            nameLen = index
            break
        }
        if maxNameLength != 0 && nameLen > maxNameLength { nameLen = maxNameLength }
        let randomInitialLetter = Int(arc4random_uniform(UInt32(initialLetterCD.last!)))
        var initLetter: Character = " "
        for index in 0..<initialLetterCD.count where initialLetterCD[index] >= randomInitialLetter {
            initLetter = Character(UnicodeScalar(index+96)!)
            break
        }

        name.append(initLetter)
        var currentLetter = initLetter
        for _ in 1..<nameLen {
            let followingLetterProbability = followingLetterProbabilities[currentLetter]!
            let randomFollowingLetter = Int(arc4random_uniform(UInt32(followingLetterProbability.last!)))
            for index in 0..<followingLetterProbabilities[currentLetter]!.count {
                let value = followingLetterProbabilities[currentLetter]![index]
                if value >= randomFollowingLetter {
                    let letter = Character(UnicodeScalar(index+96)!)
                    currentLetter = letter
                    break
                }
            }
            name.append(currentLetter)
        }
        case .frontier:
            for _ in 0..<3 {
                name += frontierBits[Int(arc4random_uniform(UInt32(frontierBits.count)))]
            }
        }
        name = name.uppercaseFirst
    }

    var description: String {
        name
    }
}
