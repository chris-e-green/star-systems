//
//  Pdf.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//
//  The Traveller game in all forms is owned by Far Future Enterprises. 
//  Copyright 1977 - 2008 Far Future Enterprises.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

postfix operator ~
/// Convenience operator to convert doubles to strings with 1 decimal place,
/// and if the result is n.0, drop the .0
/// For example, 3.3333 -> "3.3" and 3.001 -> "3"
/// - Parameter value: the Double to be converted to a string
/// - Returns: the String conversion
postfix func ~ (value: Double) -> String {
    let result = String(format: "%.1f", value)
    if result.hasSuffix(".0") {
        return result.dropLast(2).description
    } else {
        return result
    }
}
/// Convenience operator to convert doubles to strings with 1 decimal place,
/// and if the result is n.0, drop the .0
/// For example, 3.3333 -> "3.3" and 3.001 -> "3"
/// - Parameter value: the Double to be converted to a string
/// - Returns: the String conversion
postfix func ~ (value: Float) -> String {
    let result = String(format: "%.1f", value)
    if result.hasSuffix(".0") {
        return result.dropLast(2).description
    } else {
        return result
    }
}

/// A coordinate pair (x and y) with a custom description using the truncated strings described above
struct CoordPair: CustomStringConvertible {
    var x: Double
    var y: Double
    var description: String {
        "\(x~) \(y~)"
    }
}

/// Function to subtract one coordinate pair from another
///
/// - Parameters:
///   - left: the coordinate pair to be subtracted from
///   - right: the coordinate pair to subtract from left
/// - Returns: the result of left - right
func - (left: CoordPair, right: CoordPair) -> CoordPair {
    CoordPair(x: left.x - right.x, y: left.y - right.y)
}

/// Function to add one coordinate pair to another
///
/// - Parameters:
///   - left: the first coordinate pair to add
///   - right: the second coordinate pair to add
/// - Returns: the result of left + right
func + (left: CoordPair, right: CoordPair) -> CoordPair {
    CoordPair(x: left.x + right.x, y: left.y + right.y)
}

/// Rectangular coordinates - that is, two sets of coordinate pairs representing bottom left and top right of the rectangle
struct RectCoords: CustomStringConvertible {
    var bottomLeft: CoordPair
    var topRight: CoordPair
    var description: String {
        "\(bottomLeft) \(topRight)"
    }
}

/// Subtract one set of Rectangular coordinates from another
///
/// - Parameters:
///   - left: the rectangular coordinates to subtract right from
///   - right: the rectangular coordinates to subtract from left
/// - Returns: the result of subtracting right from left
func - (left: RectCoords, right: RectCoords) -> RectCoords {
    RectCoords(bottomLeft: left.bottomLeft - right.bottomLeft, topRight: left.topRight - right.topRight)
}

/// Add two sets of rectangular coordinates together
///
/// - Parameters:
///   - left: the first set of rectangular coordinates to add
///   - right: the second set of rectangular coordinates to add
/// - Returns: the sum of left and right
func + (left: RectCoords, right: RectCoords) -> RectCoords {
    RectCoords(bottomLeft: left.bottomLeft + right.bottomLeft, topRight: left.topRight + right.topRight)
}

class PdfObj {
    var id: Int
    var content: String {
        "\(id) 0 obj\n\(body)endobj\n"
    }
    var body: String {
        ""
    }
    
    init(id: Int) {
        self.id = id
    }
}

class PdfCatalog: PdfObj {
    var pages: PdfPages?
    override var body: String {
        "<<\n/Type /Catalog\n/Pages \(pages!.id) 0 R\n>>\n"
    }
    
    init(id: Int, pages: PdfPages) {
        super.init(id: id)
        self.pages = pages
    }
}

class PdfPages: PdfObj {
    var kids: [PdfPage?] = []
    override var body: String {
        var pdfPagesText: String = "<<\n/Type /Pages\n/Kids ["
        for kid in kids {
            pdfPagesText += "\(kid!.id) 0 R "
        }
        pdfPagesText += "]\n/Count \(kids.count)\n>>\n"
        return pdfPagesText
    }
}

class PdfPage: PdfObj {
    var parent: PdfPages?
    var contents: PdfContents?
    var procset: PdfProcSet?
    var fonts: [PdfFont] = []
    var xobjects: [PdfXObject]?
    var max: CoordPair?
    override var body: String {
        var pdfPageText: String = "<<\n/Type /Page\n/Parent \(parent!.id) 0 R\n/MediaBox [0 0 \(max!)]\n/Contents \(contents!.id) 0 R\n/Resources <<\n/ProcSet \(procset!.id) 0 R\n/Font <<\n"
        for font in fonts {
            pdfPageText += "/\(font.fontName!) \(font.id) 0 R\n"
        }
        pdfPageText += ">>\n"
        if xobjects!.count > 0 {
            pdfPageText += "/XObject <<\n"
            for xobject in xobjects! {
                pdfPageText += "/\(xobject.xobjId!) \(xobject.id) 0 R\n"
            }
            pdfPageText += ">>\n"
        }
        pdfPageText += ">>\n>>\n"
        return pdfPageText
    }
    
    init(id: Int, parent: PdfPages, contents: PdfContents, procset: PdfProcSet, fonts: [PdfFont], xobjects: [PdfXObject], max: CoordPair) {
        super.init(id: id)
        self.parent = parent
        self.contents = contents
        self.procset = procset
        self.fonts = fonts
        self.xobjects = xobjects
        self.max = max
    }
}

class PdfProcSet: PdfObj {
    override var body: String {
        "   [/PDF /Text]\n"
    }
}

class PdfFont: PdfObj {
    var fontName: String?
    var baseFontName: String?
    override var body: String {
        var fontText: String = ""
        fontText += "<<\n"
        fontText += "   /Type /Font\n"
        fontText += "   /Subtype /Type1\n"
        fontText += "   /Name /\(fontName!) /BaseFont /\(baseFontName!)\n"
        fontText += ">>\n"
        return fontText
    }
    init(id: Int, fontName: String, baseFontName: String) {
        super.init(id: id)
        self.fontName = fontName
        self.baseFontName = baseFontName
    }
}

class PdfContents: PdfObj {
    var bodyStr: String = ""
    override var body: String {
        get {
            bodyStr
        }
        set {
            bodyStr = newValue
        }
    }
}

// The problem with the hex display is that the hex is an
// XObject and is referenced in an XObject, so it needs to be mentioned
// in the Resources for the XObject...

class PdfXObject: PdfObj {
    var xobjId: String?
    var stream: String?
    var bbox: RectCoords?
    var xobjs: [PdfXObject] = []
    var fonts: [PdfFont] = []
    override var body: String {
        var pdfText: String = "<<\n/Type /XObject\n/Subtype /Form\n/BBox [\(bbox!)]\n/Resources <<\n/ProcSet [/PDF /Text]\n"
        if fonts.count > 0 {
            pdfText += "/Font <<\n"
            for font in fonts {
                pdfText += "/\(font.fontName!) \(font.id) 0 R\n"
            }
            pdfText += ">>\n"
        }
        if xobjs.count > 0 {
            pdfText += "/XObject <<\n"
            for xobj in xobjs {
                pdfText += "/\(xobj.xobjId!) \(xobj.id) 0 R\n"
            }
            pdfText += ">>\n"
        }
        pdfText += ">>\n/Length \(stream!.count - 1)\n>>\nstream\n"
        pdfText += stream!
        pdfText += "endstream\n"
        return pdfText
    }
    
    init(id: Int, xobjId: String, stream: String, bbox: RectCoords, fonts: [PdfFont] = [], xobjs: [PdfXObject] = []) {
        super.init(id: id)
        self.xobjId = xobjId
        self.stream = stream
        self.bbox = bbox
        self.fonts = fonts
        self.xobjs = xobjs
    }
}

class Pdf {
    let fontDetails    : [(baseFontName: String, fontName: String)] = [("Helvetica", "F1"),
                                                                       ("Helvetica-Bold", "F2"),
                                                                       ("Helvetica-Oblique", "F3"),
                                                                       ("Courier", "F4")]
    let xobjPlanetDryId: String = "circle-blue-filled"
    let xobjPlanetWetId: String = "circle-blue-empty"
    let xobjGasGiantId: String = "circle-black-filled"
    let xobjNavalBaseId: String = "triangle-black-filled"
    let xobjScoutBaseId: String = "star-black-filled"
    let xobjTASForm6Id: String = "tas-form-6"
    let xobjTASForm7Id: String = "tas-form-7"
    let xobjISForm7Id: String = "is-form-7"
    let xobjISForm7aId: String = "is-form-7-continuation"
    let xobjHexId: String = "hex"
    let coordPts: Double = 5.0
    let namePts: Double = 8.0
    let listPts: Double = 11.0
    let listLineHeight: Double = 23.5
    let headingPts: Double = 12.0
    let textPts: Double = 8.0
    let sqrt3: Double = sqrt(3.0)
    let inverseSqrt3: Double = 1.0 / sqrt(3.0)
    let pageMax: CoordPair = CoordPair(x: 420, y: 595.0) // A5
    let pageMargin: RectCoords = RectCoords(
        bottomLeft: CoordPair(x: 26.0, y: 41.0),
        topRight: CoordPair(x: 30.0, y: 22.5)
    )
    let contentMargin: RectCoords = RectCoords(
        bottomLeft: CoordPair(x: 10.0, y: 10.0),
        topRight: CoordPair(x: 10.0, y: 10.0)
    )
    var mapBoxSize: CoordPair {
        CoordPair(
                x: contentMargin.bottomLeft.x + contentMargin.bottomLeft.x + 328,
                y: pageMax.y - pageMargin.topRight.y - pageMargin.bottomLeft.y
        )
    }
    var tasForm7ListTL: CoordPair {
        CoordPair(
                x: pageMargin.bottomLeft.x + 7.0,
                y: pageMax.y - pageMargin.topRight.y - 93.0)
    }
    
    var hexHeight: Double = 45.0
    var hexWidth: Double {
        hexHeight / sqrt3
    }
    let planetRadius: Double = 3.0
    let asteroidsSize: Double = 6.0
    let gasGiantRadius: Double = 1.5
    let navalBaseSize: Double = 4.0
    let scoutBaseSize: Double = 4.0
    var tas7line: Int    = 0
    var is7line: Int    = 0
    var is7continued: Bool   = false
    var mapData: String = ""
    var subsectorData  = [String]()
    var systemData     = [String]()
    var pdfContent: String = ""
    var catalog: PdfCatalog?
    var pages: PdfPages?
    var procSet: PdfProcSet?
    var xobjs: [PdfXObject] = []
    var pdfObjects: [Int: PdfObj] = [:]
    var fonts: [PdfFont] = []
    #if os(macOS)
    var fontCache: [String: NSFont] = [:]
    #else
    var fontCache: [String: UIFont] = [:]
    #endif
    var currObjId = 2
    
    func leftPad(_ num: Int) -> String {
        let ofsStr = ("0000000000" + String(num))
        return String(ofsStr[ofsStr.index(ofsStr.endIndex, offsetBy: -10)...])
    }
    
    func strWidth(_ str: String, fontName: String, fontSize: Double) -> Double {
        #if os(macOS)
        var font: NSFont?
        #else
        var font: UIFont?
        #endif
        font = fontCache["\(fontName)\(fontSize)"]
        if font == nil {
            #if os(macOS)
            font = NSFont(name: fontName, size: CGFloat(fontSize))
            #else
            font = UIFont(name: baseFontName, size: CGFloat(fontSize))
            #endif
            fontCache["\(fontName)\(fontSize)"] = font
        }
        let ctl: CTLine = CTLineCreateWithAttributedString(NSAttributedString(string: str, attributes: [NSAttributedString.Key.font: font!]))
        let width: Double = CTLineGetTypographicBounds(ctl, nil, nil, nil)// / 12.0 * fontSize
        return width
    }

    func hline(_ y: Double, minX: Double, maxX: Double) -> String {
        "\(minX~) \(y~) m \(maxX~) \(y~) l S\n"
    }
    
    func vline(_ x: Double, minY: Double, maxY: Double) -> String {
        "\(x~) \(minY~) m \(x~) \(maxY~) l S\n"
    }

    func xobject(_ xobjName: String, atCoords: CoordPair) -> String {
        "q 1 0 0 1 \(atCoords) cm /\(xobjName) Do Q\n"
    }

    func circle(_ x: Double, y: Double, radius: Double, filled: Bool, blue: Bool) -> String {
        let magic: Double = radius * 0.551784
        var circleStr = ""
        if DEBUG { circleStr += "% circle at (\(x~), \(y~)) r=\(radius~)\n" }
        if filled && blue {
            circleStr += "0 0.5 1 rg "
        }
        circleStr += "0.5 w \((x - radius)~) \(y~) m "
        circleStr += "\((x - radius)~) \((y + magic)~) \((x - magic)~) \((y + radius)~) \(x~) \((y + radius)~) c "
        circleStr += "\((x + magic)~) \((y + radius)~) \((x + radius)~) \((y + magic)~) \((x + radius)~) \(y~) c "
        circleStr += "\((x + radius)~) \((y - magic)~) \((x + magic)~) \((y - radius)~) \(x~) \((y - radius)~) c "
        circleStr += "\((x - magic)~) \((y - radius)~) \((x - radius)~) \((y - magic)~) \((x - radius)~) \(y~) c "
        if filled {circleStr += "f "}
        circleStr += "S 1 w "
        if filled && blue {
            circleStr += "0 0 0 rg"
        }
        circleStr += "\n"
        return circleStr
    }

    func asteroids(_ x: Double, y: Double, size: Double) -> String {
        var asteroidStr = ""
        if DEBUG { asteroidStr += "% asteroid at (\(x~), \(y~))\n" }
        var xDisp: Double = 0.0
        var yDisp: Double = 0.0
        let intSize = UInt32(size)
        for _ in 1..<20 {
            xDisp = Double(arc4random_uniform(intSize)+arc4random_uniform(intSize)) - size
            yDisp = Double(arc4random_uniform(intSize)+arc4random_uniform(intSize)) - size
            asteroidStr += circle(x + xDisp, y: y + yDisp, radius: 0.5, filled: true, blue: false)
        }
        return asteroidStr
    }

    func triangle(_ x: Double, y: Double, size: Double) -> String {
        var triangleStr = ""
        if DEBUG { triangleStr += "% triangle at (\(x~), \(y~))\n" }
        triangleStr += "\((x - size / 2.0)~) \(y~) m \(x~) \((y + 0.866 * size)~) l "
        triangleStr += "\((x + size / 2.0)~) \(y~) l h f S\n"
        return triangleStr
    }
    
    func star(_ x: Double, y: Double, size: Double) -> String {
        let xf1: Double = 0.809 * size
        let yf1: Double = 0.182 * size
        let xf2: Double = 0.191 * size
        let yf2: Double = 0.77 * size
        let xf3: Double = 0.309 * size
        let xf4: Double = 0.5 * size
        let yf3: Double = 0.406 * size
        var starStr = ""
        if DEBUG { starStr += "% asterisk at (\(x~), \(y~))\n" }
        starStr += "\((x - xf1)~) \((y + yf1)~) m \((x - xf2)~) \((y + yf1)~) l "
        starStr += "\(x~) \((y + yf2)~) l \((x + xf2)~) \((y + yf1)~) l "
        starStr += "\((x + xf1)~) \((y + yf1)~) l \((x + xf3)~) \((y - yf1)~) l "
        starStr += "\((x + xf4)~) \((y - yf2)~) l \(x~) \((y - yf3)~) l "
        starStr += "\((x - xf4)~) \((y - yf2)~) l \((x - xf3)~) \((y - yf1)~) l h f S\n"
        return starStr
    }
    
    func drawHex(_ x: Double, y: Double, height: Double) -> String {
        let topBottomVar: Double = inverseSqrt3 * height / 2.0
        let middleVar: Double = inverseSqrt3 * height
        let heightVar: Double = height / 2.0
        var hexString = ""
        if DEBUG { hexString += "% hex at (\(x~), \(y~))\n" }
        hexString += """
             \((x - topBottomVar)~) \((y - heightVar)~) m \((x + topBottomVar)~) \((y - heightVar)~) l 
             \((x + middleVar)~) \(y~) l \((x + topBottomVar)~) \((y + heightVar)~) l 
             \((x - topBottomVar)~) \((y + heightVar)~) l \((x - middleVar)~) \(y~) l 
             \((x - topBottomVar)~) \((y - heightVar)~) l h S
                     
             """
        return hexString
    }
    
    func hex(_ x: Double, y: Double, height: Double, label: String) -> String {
        var hexStr = ""
        if DEBUG { hexStr += "% hex at (\(x~), \(y~))\n" }
        
        hexStr += "q 1 0 0 1 \(x~) \(y~) cm /\(xobjHexId) Do Q\n"
        let labelWidth: Double = strWidth(label, fontName: fontDetails[0].baseFontName, fontSize: coordPts)
        hexStr += "BT /\(fontDetails[0].fontName) \(coordPts~) Tf \((x - labelWidth / 2.0)~) \((y + 14.0)~) Td (\(label))Tj ET\n"
        return hexStr
    }
    
    func hexLocToCoord(_ x: Int, y: Int, map: Bool = false) -> CoordPair {
        // if map is true, we are drawing the hexes on the map so our coordinates are based on zero in the form context.
        var ptsX = 0.0
        var ptsY = 0.0
        if map {
            ptsX = 20 + hexWidth + hexWidth * 1.5 * (Double(x) - 1.0)
            ptsY = 1.5 * hexHeight + hexHeight * (Double(y) - 1.0)
        } else {
            ptsX = 46 + hexWidth + hexWidth * 1.5 * (Double(x) - 1.0)
            ptsY = 1.5 * hexHeight + hexHeight * (Double(y) - 1.0)
        }
        if x % 2 == 1 {
            ptsY -= (hexHeight / 2.0)
        }
        if map {
            ptsY = mapBoxSize.y - 12 - ptsY
        } else {
            ptsY = mapBoxSize.y + 17 - ptsY
        }
        return CoordPair(x: ptsX, y: ptsY)
    }
    
    func listCoords(_ x: Int, y: Int) -> CoordPair {
        CoordPair(x: tasForm7ListTL.x,
                y: tasForm7ListTL.y - Double(tas7line + 1) * listLineHeight)
    }
    
    func showText(_ text: String, x: Double, y: Double, heading: Bool = false, small: Bool = true, narrow: Bool = false) -> String {
        var result = "BT /"
        if heading {
            result += "\(fontDetails[1].fontName) \(headingPts~)"
        } else {
            result += "\(fontDetails[0].fontName) "
            if small {
                result += "\(textPts~)"
            } else {
                result += "\(listPts~)"
            }
        }
        result += " Tf \(x~) \(y~) Td "
        if narrow { result += "75 Tz " }
        result += "(\(text))Tj "
        if narrow { result += "100 Tz " }
        result += "ET\n"
        return result
    }
    
    func drawTASForm6() -> String {
        var result = ""
        
        // ----------------------------------------------------------
        // Draw TAS Form 6.
        if DEBUG {
            result += "%-----------------------------------------------\n"
            result += "% Draw TAS Form 6.\n"
            result += "%-----------------------------------------------\n"
            // ----------------------------------------------------------
        }
        let form = CoordPair(x: 364.0, y: mapBoxSize.y)
        
        // draw box around page content
        result += "4 w 0 \(headingPts~) \(form) re S\n"
        // draw box around map content
        //        result += "\(innerBoxBL) \(innerBoxSzX~) \(innerBoxSzY~) re S\n"
        result += "6 \((headingPts + 6)~) \(form - CoordPair(x: 12, y: 44)) re S\n"
        // draw line separating header from map
        result += hline(form.y - 20, minX: 0, maxX: form.x)
        // draw labels on map form
        result += showText("TAS Form 6", x: 0, y: 0, heading: true)
        let lbl = "Subsector Map Grid"
        
        let lblWidth = strWidth(lbl, fontName: fontDetails[1].baseFontName, fontSize: headingPts)
        result += showText(lbl, x: mapBoxSize.x - lblWidth, y: 0, heading: true)
        result += showText("SUBSECTOR MAP GRID", x: 6, y: form.y - 15, heading: true)
        result += showText("1. Subsector Name", x: 200, y: form.y)
        
        // draw vertical lines in header
        result += "1 w\n"
        result += vline(190, minY: form.y + headingPts, maxY: form.y - 20)
        result += vline(340, minY: form.y + headingPts, maxY: form.y - 20)
        
        // draw hexagons in map
        
        result += "0.5 g 0.5 G\n"
        
        for xCoord in 1 ... 8 {
            for yCoord in 1 ... 10 {
                let coordPair: CoordPair = hexLocToCoord(xCoord, y: yCoord, map: true)
                let coordLabel: String = String(format: "%02d%02d", arguments: [xCoord, yCoord])
                result += hex(coordPair.x, y: coordPair.y, height: hexHeight, label: coordLabel)
            }
        }
        result += "0 g 0 G\n"
        if DEBUG {
            result += "%-----------------------------------------------\n"
        }
        return result
    }

    func drawISForm7(_ first: Bool = true) -> String {
        /*
         Content locations:
         - field 1: bl.x = form.bl.x + 240, bl.y = form.tr.y - headingPts - 18, tr.x = form.tr.x - 5, tr.y = form.tr.y - headingPts - 2
         - field 2: bl.x = form.bl.x + 5, bl.y = form.tr.y - headingPts -
         */
        let form = CoordPair(x: 364.0, y: mapBoxSize.y)
        let headingInset = 5.0
        let textVMargin = 3.0
        let guideBox = CoordPair(x: 12.0, y: 16.5)
        let guideBoxStartX = 144.0
        let orbitBox = CoordPair(x: 24.0, y: 16.5)
        let orbitBoxSep = 2.0
        let hLineHeight = 24.0
        let vLine1X = 235.0
        let vLine2X = 182.0
        let vLine3X = 283.0
        let line0Y = form.y + headingPts
        let boxLineWidth = 4.0
        let divLineWidth = 1.0

        func lineToY(_ lineNum: Double) -> Double {
            form.y - 20 - (lineNum - 1) * hLineHeight
        }

        var formPdf = ""
        if DEBUG {
            if first {
                formPdf += "% IS Form 7\n"
            } else {
                formPdf += "% IS Form 7 continuation\n"
            }
            formPdf += "%-----------------------------------------------\n"
        }
        formPdf += "\(boxLineWidth~) w 0 \(headingPts~) \(form) re S \(divLineWidth~) w\n"
        // first row content
        var curLineNum = 1.0
        var dateLabelNum = 1
        if first {
            formPdf += showText("STAR SYSTEM DATA", x: headingInset, y: lineToY(curLineNum) + textVMargin, heading: true)
        } else {
            formPdf += showText("STAR SYSTEM DATA (Continuation)", x: headingInset, y: lineToY(curLineNum) + textVMargin, heading: true)
            dateLabelNum = 7
        }
        formPdf += showText("\(dateLabelNum). Date of Preparation", x: vLine1X + headingInset, y: line0Y - textPts - boxLineWidth / 2)
        
        // line separating column 1 & 2 on row 1
        formPdf += vline(vLine1X, minY: line0Y, maxY: lineToY(curLineNum))
        
        // line below first row
        formPdf += hline(lineToY(curLineNum), minX: 0, maxX: form.x)
        
        if first {
            // second row content
            // line separating column 1 & 2 on row 2
            formPdf += vline(vLine2X, minY: lineToY(curLineNum), maxY: lineToY(curLineNum+1))
            
            formPdf += showText("2. System Name (and Hex Location)", x: headingInset, y: lineToY(curLineNum) - textPts)
            formPdf += showText("3. Subsector and Sector", x: vLine2X + headingInset, y: lineToY(curLineNum) - textPts)
            curLineNum += 1
            // line below second row
            formPdf += hline(lineToY(curLineNum), minX: 0, maxX: form.x)
        }
        // third row content
        var starLabel = "4. Star Name"
        var specNum = 5
        var magNum = 6
        if !first {
            starLabel = "8. Central Star Name"
            specNum = 9
            magNum = 10
        }
        // line separating column 1 & 2 on row 3
        formPdf += vline(vLine2X, minY: lineToY(curLineNum), maxY: lineToY(curLineNum+1))
        // line separating column 2 & 3 on row 3
        formPdf += vline(vLine3X, minY: lineToY(curLineNum), maxY: lineToY(curLineNum+1))
        formPdf += showText(starLabel, x: headingInset, y: lineToY(curLineNum) - textPts)
        formPdf += showText("\(specNum). Spectrum and Size", x: vLine2X + headingInset, y: lineToY(curLineNum) - textPts)
        formPdf += showText("\(magNum). Magnitude", x: vLine3X + headingInset, y: lineToY(curLineNum) - textPts)
        curLineNum += 1
        // line below third row
        formPdf += hline(lineToY(curLineNum), minX: 0, maxX: form.x)
        
        if first {
            curLineNum += 1
            // fourth row content
            formPdf += showText("WORLD AND SATELLITE DATA", x: headingInset, y: lineToY(curLineNum) + textVMargin, heading: true)
            // line below fourth row
            formPdf += hline(lineToY(curLineNum), minX: 0, maxX: form.x)
        }
        
        formPdf += "0.5 w\n"
        let rows = first ? 19 : 21
        for row in 1..<rows {
            let rowOffsetY = Double(row) * listLineHeight
            formPdf += hline(lineToY(curLineNum) - rowOffsetY, minX: 0, maxX: form.x)
            let y = lineToY(curLineNum) - rowOffsetY + 3.5
            // orbit boxes
            formPdf += "\(headingInset~) \(y~) \(orbitBox) re S\n"
            formPdf += "\((headingInset + orbitBox.x + orbitBoxSep)~) \(y~) \(orbitBox) re S\n"
            // UWP boxes
            formPdf += "\(guideBoxStartX~) \((y + guideBox.y)~) m \(guideBoxStartX~) \(y~) l "
            for guideBoxIndex in 1...8 {
                formPdf += "\((guideBoxStartX + Double(guideBoxIndex) * guideBox.x)~) \(y~) l "
                formPdf += "\((guideBoxStartX + Double(guideBoxIndex) * guideBox.x)~) \((y + guideBox.y)~) l "
                formPdf += "\((guideBoxStartX + Double(guideBoxIndex) * guideBox.x)~) \(y~) m "
            }
            formPdf += "S\n"
        }
        // form footer
        var footer = "IS Form 7"
        if !first { footer += " (Reverse)" }
        formPdf += showText(footer, x: 0, y: 0, heading: true)

        let footer2width = strWidth("Star System Data", fontName: fontDetails[1].baseFontName, fontSize: headingPts)
        formPdf += showText("Star System Data", x: form.x - footer2width, y: 0, heading: true)
        return formPdf
    }

    func drawTASForm7() -> String {
        /*bl: CoordPair(x: 0, y: 0),
         tr: CoordPair(x: 364, y: mapBoxSize.y)*/
        let form = CoordPair(x: 364.0, y: mapBoxSize.y)
        
        var result = ""
        if DEBUG {
            result += "% TAS Form 7\n"
            result += "%-----------------------------------------------\n"
        }
        result += "4 w 0 \(headingPts~) \(form) re S 1 w\n"
        result += hline(form.y - 25, minX: 0, maxX: form.x)
        result += hline(form.y - 58, minX: 0, maxX: form.x)
        result += vline(207, minY: form.y + headingPts, maxY: form.y - 58)
        result += hline(form.y - 90, minX: 0, maxX: form.x)
        result += "0.5 w\n"
        for line in 1..<19 {
            let lineOffsetY = 90.0 + Double(line) * listLineHeight
            result += hline(form.y - lineOffsetY, minX: 0, maxX: form.x)
            var x = 108.0
            let y = form.y - lineOffsetY + 3.5
            result += "\(x~) \((y + 16.5)~) m \(x~) \(y~) l "
            for coordGuideIndex in 1...4 {
                result += "\((x + Double(coordGuideIndex) * 12.0)~) \(y~) l "
                result += "\((x + Double(coordGuideIndex) * 12.0)~) \((y + 16.5)~) l "
                result += "\((x + Double(coordGuideIndex) * 12.0)~) \(y~) m "
            }
            result += "S\n"
            x += 60.0
            result += "\(x~) \((y + 16.5)~) m \(x~) \(y~) l "
            for uppGuideIndex in 1...8 {
                result += "\((x + Double(uppGuideIndex) * 12.0)~) \(y~) l "
                result += "\((x + Double(uppGuideIndex) * 12.0)~) \((y + 16.5)~) l "
                result += "\((x + Double(uppGuideIndex) * 12.0)~) \(y~) m "
            }
            result += "S\n"
        }
        result += showText("TAS Form 7", x: 0, y: 0, heading: true)
        let lbl = "Subsector World Data"
        let lblWidth = strWidth(lbl, fontName: fontDetails[1].baseFontName, fontSize: headingPts)
        result += showText(lbl, x: form.x - lblWidth, y: 0, heading: true)
        result += showText("SUBSECTOR WORLD DATA", x: 10, y: form.y - 21, heading: true)
        result += showText("1. Date of Preparation", x: 210, y: form.y)
        result += showText("2. Subsector Name", x: 10, y: form.y - 33)
        result += showText("3. Sector Name", x: 210, y: form.y - 33)
        result += "BT /\(fontDetails[1].fontName) 10 Tf 5 \((form.y - 85)~) Td (World Name)Tj 102 0 Td (Location)Tj 60 0 Td (UPP)Tj 110 0 Td (Remarks)Tj ET\n"
        return result
    }

    func start() {
        procSet = PdfProcSet(id: currObjId)
        pdfObjects[currObjId] = procSet
        currObjId += 1

        for (baseFontName, fontName) in fontDetails {
            let font = PdfFont(id: currObjId, fontName: fontName, baseFontName: baseFontName)
            fonts.append(font)
            pdfObjects[currObjId] = font
            currObjId += 1
        }

        let xobjPlanetDry = PdfXObject(id: currObjId, xobjId: xobjPlanetDryId,
                                       stream: circle(0, y: 0, radius: planetRadius,
                                                      filled: true, blue: true),
                                       bbox: RectCoords(
                                        bottomLeft: CoordPair(
                                            x: -1 * planetRadius,
                                            y: -1 * planetRadius),
                                        topRight: CoordPair(
                                            x: planetRadius,
                                            y: planetRadius)))
        xobjs.append(xobjPlanetDry)
        pdfObjects[currObjId] = xobjPlanetDry
        currObjId += 1

        let xobjPlanetWet = PdfXObject(id: currObjId, xobjId: xobjPlanetWetId,
                                       stream: circle(0, y: 0, radius: planetRadius,
                                                      filled: false, blue: true),
                                       bbox: RectCoords(
                                        bottomLeft: CoordPair(
                                            x: -1.1 * planetRadius ,
                                            y: -1.1 * planetRadius),
                                        topRight: CoordPair(
                                            x: 1.1 * planetRadius,
                                            y: 1.1 * planetRadius)))
        xobjs.append(xobjPlanetWet)
        pdfObjects[currObjId] = xobjPlanetWet
        currObjId += 1

        let xobjGasGiant = PdfXObject(id: currObjId, xobjId: xobjGasGiantId,
                                      stream: circle(0, y: 0, radius: gasGiantRadius,
                                                     filled: true, blue: false),
                                      bbox: RectCoords(
                                        bottomLeft: CoordPair(
                                            x: -1 * gasGiantRadius,
                                            y: -1 * gasGiantRadius),
                                        topRight: CoordPair(
                                            x: gasGiantRadius,
                                            y: gasGiantRadius)))
        xobjs.append(xobjGasGiant)
        pdfObjects[currObjId] = xobjGasGiant
        currObjId += 1

        let xobjNavalBase = PdfXObject(id: currObjId, xobjId: xobjNavalBaseId,
                                       stream: triangle(0, y: 0, size: navalBaseSize),
                                       bbox: RectCoords(
                                        bottomLeft: CoordPair(
                                            x: -1 * navalBaseSize / 2,
                                            y: 0),
                                        topRight: CoordPair(
                                            x: navalBaseSize / 2,
                                            y: navalBaseSize)))
        xobjs.append(xobjNavalBase)
        pdfObjects[currObjId] = xobjNavalBase
        currObjId += 1

        let xobjScoutBase = PdfXObject(id: currObjId, xobjId: xobjScoutBaseId,
                                       stream: star(0, y: 0, size: scoutBaseSize),
                                       bbox: RectCoords(
                                        bottomLeft: CoordPair(
                                            x: -1 * scoutBaseSize,
                                            y: -1 * scoutBaseSize),
                                        topRight: CoordPair(
                                            x: scoutBaseSize,
                                            y: scoutBaseSize)))
        xobjs.append(xobjScoutBase)
        pdfObjects[currObjId] = xobjScoutBase
        currObjId += 1

        let hexXobj = PdfXObject(id: currObjId, xobjId: xobjHexId,
                                 stream: drawHex(0, y: 0, height: hexHeight),
                                 bbox: RectCoords(
                                    bottomLeft: CoordPair(x: 0 - hexWidth, y: 0 - hexHeight),
                                    topRight: CoordPair(x: hexWidth, y: hexHeight)))
        xobjs.append(hexXobj)
        pdfObjects[currObjId] = hexXobj
        currObjId += 1

        let xobjTASForm6 = PdfXObject(id: currObjId, xobjId: xobjTASForm6Id,
                                      stream: drawTASForm6(),
                                      bbox: RectCoords(
                                        bottomLeft: CoordPair(x: -2, y: -2),
                                        topRight: CoordPair(x: 366, y: mapBoxSize.y + headingPts + 2)),
                                      fonts: fonts, xobjs: [hexXobj])
        xobjs.append(xobjTASForm6)
        pdfObjects[currObjId] = xobjTASForm6
        currObjId += 1

        let xobjTASForm7 = PdfXObject(id: currObjId, xobjId: xobjTASForm7Id,
                                      stream: drawTASForm7(),
                                      bbox: RectCoords(
                                        bottomLeft: CoordPair(x: -2, y: -2),
                                        topRight: CoordPair(x: 366, y: mapBoxSize.y + headingPts + 2)),
                                      fonts: fonts)
        xobjs.append(xobjTASForm7)
        pdfObjects[currObjId] = xobjTASForm7
        currObjId += 1

        let xobjISForm7 = PdfXObject(id: currObjId, xobjId: xobjISForm7Id,
                                     stream: drawISForm7(),
                                     bbox: RectCoords(
                                        bottomLeft: CoordPair(x: -2, y: -2),
                                        topRight: CoordPair(x: 366, y: mapBoxSize.y + headingPts + 2)),
                                     fonts: fonts)
        xobjs.append(xobjISForm7)
        pdfObjects[currObjId] = xobjISForm7
        currObjId += 1

        let xobjISForm7a = PdfXObject(id: currObjId, xobjId: xobjISForm7aId,
                                      stream: drawISForm7(false),
                                      bbox: RectCoords(
                                        bottomLeft: CoordPair(x: -2, y: -2),
                                        topRight: CoordPair(x: 366, y: mapBoxSize.y + headingPts + 2)),
                                      fonts: fonts)
        xobjs.append(xobjISForm7a)
        pdfObjects[currObjId] = xobjISForm7a
        currObjId += 1

        pages = PdfPages(id: currObjId)
        pdfObjects[currObjId] = pages

        currObjId += 1

        catalog = PdfCatalog(id: 1, /*outline: outline!, */pages: pages!)
        pdfObjects[1] = catalog

        mapData = xobject(xobjTASForm6Id, atCoords: pageMargin.bottomLeft - CoordPair(x: 0, y: headingPts))

        // create a new TAS Form 7 page string (with append) and start it off with form invocation.
        subsectorData.append(xobject(xobjTASForm7Id, atCoords: pageMargin.bottomLeft - CoordPair(x: 0, y: headingPts)))
    }

    // the purpose of composite is to take the supplied content string and turn
    // it into an appropriate pdf text block. If the string is too long for a
    // single line it will split into two lines and return; if it fits on a
    // single line it will format as a single line and return that line block.
    // blockWidth is in points.
    // proposed algorithm: 
    //    first, check the string width as supplied.
    //    If it fits, we turn it into a single line.
    //    if it didn't fit, then it must be more than one line long. We split it
    //      into words and progressively move the last word to a second line,
    //      until the first line  fits. The first and second lines then become
    //      the return value.
    func composite(_ content: String, blockWidth: Double) -> String {
        var result = ""
        var line1 = content
        var line2 = ""
        if strWidth(line1, fontName: fontDetails[0].baseFontName, fontSize: 11) * 0.6 < blockWidth {
            // 1 line format is 6 0 Td 75 Tz (line1)Tj 100 Tz"
            result = "2 0 Td 60 Tz (\(line1))Tj 100 Tz"
        } else {
            let wordsArray = line1.components(separatedBy: " ")
            let lastIdx = wordsArray.endIndex.advanced(by: -1)
            for (wordIndex, _) in wordsArray.enumerated().reversed() {
                line1 = wordsArray[0...(wordIndex - 1)].joined(separator: " ")
                line2 = wordsArray[wordIndex...lastIdx].joined(separator: " ")
                if strWidth(line1, fontName: fontDetails[0].baseFontName, fontSize: 11) * 0.6 < blockWidth {
                    // we have a short enough line 1 now.
                    result = "2 5.5 Td 60 Tz (\(line1))Tj 0 -11 Td (\(line2))Tj 100 Tz"
                    break
                }
            }
            // 2 line format is "6 5.5 Td 75 Tz (line1)Tj 0 -11 Td (line2))Tj 100 Tz"
        }
        return result
    }
    
    func displaySat(_ orbitstr: String, suborbitstr: String, satellite: Satellite, y: Double, isSat: Bool = false) -> String {
        let orbit1col = 50.0 // right side because right-aligned
        let orbit2col = 77.0 // right side because right-aligned
        let namecol = 90.0
        let uwpcol = 172.0
        let desccol = 270.0
        var pdfText = ""
        
        let orb1W = strWidth(orbitstr, fontName: fontDetails[0].baseFontName, fontSize: listPts) * 0.75
        let orb2W = strWidth(suborbitstr, fontName: fontDetails[0].baseFontName, fontSize: listPts) * 0.75
        pdfText += showText(orbitstr, x: orbit1col - orb1W, y: y, heading: false, small: false, narrow: true)
        pdfText += showText(suborbitstr, x: orbit2col - orb2W, y: y, heading: false, small: false, narrow: true)
        pdfText += showText(satellite.name, x: namecol, y: y, heading: false, small: false)
        if let planet = satellite as? Planet {
            pdfText += "BT /\(fontDetails[0].fontName) \(listPts~) \(uwpcol~) \(y) Td "
            pdfText += pdfPlanet(planet)
            pdfText += "ET\n"
        } else if let gasGiant = satellite as? GasGiant {
            pdfText += showText(gasGiant.size.description, x: desccol, y: y, heading: false, small: false, narrow: true)
        } else if satellite is EmptyOrbit {
            pdfText += showText("Empty orbit", x: namecol, y: y, heading: false, small: false)
        } else if let star = satellite as? Star {
            pdfText += showText("\(star.specSize) companion", x: desccol, y: y, heading: false, small: false, narrow: true)
        }
        
        return pdfText
    }
    
    func display(_ starSystem: StarSystem) {
        let mainWorld = starSystem.mainWorld!
        mainWorld.coordinateX = starSystem.coordinateX
        mainWorld.coordinateY = starSystem.coordinateY
        mainWorld.gasGiant = starSystem.gasGiants
        display(mainWorld)
        for star in starSystem.stars {
            systemData.append(xobject(xobjISForm7Id, atCoords: pageMargin.bottomLeft - CoordPair(x: 0, y: headingPts)))
            
            var pdfText = ""
            let loc = String(format: "%02d%02d", arguments: [mainWorld.coordinateX, mainWorld.coordinateY])
            pdfText += showText(starSystem.subsectorName, x: 250, y: mapBoxSize.y - 10, heading: false, small: false)
            pdfText += showText("\(mainWorld.name) (\(loc))", x: 60, y: mapBoxSize.y - 10, heading: false, small: false)
            pdfText += showText(star.name, x: 100, y: mapBoxSize.y - 35, heading: false, small: false)
            pdfText += showText(star.specSize, x: 250, y: mapBoxSize.y - 35, heading: false, small: false)
            pdfText += showText("\(star.magnitude)", x: 330, y: mapBoxSize.y - 35, heading: false, small: false)
            let sortedOrbits = star.satellites.orbits.sorted(by: {$0.0 < $1.0})
            // make a sorted array of all orbits
            var orbitLines = [(Int, Int, Satellite)]()
            for (orbitNum, satellite) in sortedOrbits {
                orbitLines.append((orbitNum, -1, satellite))
                // if we are doing a planet or a gas giant, we want to look at the satellites, but if
                // we are doing a star, we don't, because it will be processed separately. We do need
                // to make sure close companions are presented, but they have no satellites of their own.
                if satellite is Planet || satellite is GasGiant {
                    let sortedSuborbits = satellite.satellites.orbits.sorted(by: {$0.0 < $1.0})
                    for (subOrbitNum, subOrbitSatellite) in sortedSuborbits {
                        orbitLines.append((-1, subOrbitNum, subOrbitSatellite))
                    }
                }
            }
            if DEBUG {
                for (orbitNum, subOrbitNum, satellite) in orbitLines {
                    var orbitStr = "\t"
                    if orbitNum != -1 { orbitStr += "\(orbitNum)" }
                    orbitStr += "\t"
                    if subOrbitNum != -1 { orbitStr += "\(subOrbitNum)" }
                    orbitStr += "\t\(satellite.name)\t\(satellite.type)"
                    print(orbitStr)
                }
            }
            var line = 0
            for (stellarOrbit, moonOrbit, satellite) in orbitLines {
                if line == 18 {
                    systemData[systemData.endIndex.advanced(by: -1)] += pdfText
                    pdfText = ""
                    systemData.append(xobject(xobjISForm7aId, atCoords: pageMargin.bottomLeft - CoordPair(x: 0, y: headingPts)))
                    pdfText += showText(star.name, x: 100, y: mapBoxSize.y - 10, heading: false, small: false)
                    pdfText += showText(star.specSize, x: 250, y: mapBoxSize.y - 10, heading: false, small: false)
                    pdfText += showText("\(star.magnitude)", x: 330, y: mapBoxSize.y - 10, heading: false, small: false)
                    line = -2 // this *should* put the line two up on where it normally would be, perfect for the continuation...
                }
                let y = mapBoxSize.y - Double(line) * listLineHeight - 78
                if stellarOrbit != -10 { //
                    let orbitstr = stellarOrbit == -1 ? "" : (Double(stellarOrbit) / 10)~
                    let suborbitstr = moonOrbit == -1 ? "" : (Double(moonOrbit) / 10)~
                    pdfText += displaySat(orbitstr, suborbitstr: suborbitstr, satellite: satellite, y: y)
                } else { // close orbit, i.e. must be a star.
                    pdfText += showText(satellite.name, x: 90, y: y, heading: false, small: false)
                    pdfText += showText("\(star.specSize) companion in close orbit", x: 270, y: y, heading: false, small: false, narrow: true)
                }
                line += 1
            }
            systemData[systemData.endIndex.advanced(by: -1)] += pdfText
        }
    }
    
    func pdfPlanet(_ planet: Planet) -> String {
        var planetStr = ""
        planetStr += String(format: "0 Tc (%@)Tj 12 0 Td (%@)Tj 12 0 Td (%1X)Tj 12 0 Td (%1X)Tj 12 0 Td (%1X)Tj 12 0 Td (%1X)Tj 12 0 Td(%1X)Tj 12 0 Td (%1X)Tj 12 0 Td ",
                            arguments: [planet.starport, planet.size,
                                        planet.internalAtmosphere, planet.internalHydrographics, planet.internalPopulation,
                                        planet.internalGovernment, planet.internalLawLevel, planet.internalTechnologicalLevel])
        var basesTCFacilities = ""
        var bases = ""
        if planet.bases.contains(.navalBase) && planet.bases.contains(.scoutBase) {
            bases += "Naval, Scout"
        } else if planet.bases.contains(.navalBase) {
            bases += "Naval"
        } else if planet.bases.contains(.scoutBase) {
            bases += "Scout"
        }
        basesTCFacilities += bases
        if planet.facilitiesStr != "" {
            if bases != "" {
                basesTCFacilities += ", "
            }
            basesTCFacilities += planet.facilitiesStr
        }
        if basesTCFacilities != "" { basesTCFacilities += "; " }
        basesTCFacilities += "\(planet.longTradeClassifications)"
        planetStr += composite(basesTCFacilities, blockWidth: 115)
        planetStr += "\n"

        return planetStr
    }

    func display(_ planet: Planet) {
        if tas7line > 17 {
            tas7line = 0
            // create a new page string (with append) and start it off with a new form invocation.
            subsectorData.append(xobject(xobjTASForm7Id, atCoords: pageMargin.bottomLeft - CoordPair(x: 0, y: headingPts)))
        }
        var pdfText: String = ""
        if DEBUG { pdfText += "% Rendering \(planet.name) to list\n" }
        let coords: CoordPair = listCoords(planet.coordinateX, y: planet.coordinateY)
        pdfText += "BT /\(fontDetails[0].fontName) \(listPts~) Tf \(coords) Td (\(planet.name))Tj "
        pdfText += String(format: "104 0 Td 5.5 Tc (%02d%02d)Tj 0 Tc 60 0 Td ", arguments: [planet.coordinateX, planet.coordinateY])
        pdfText += String(format: "(%@)Tj 12 0 Td (%1X)Tj 12 0 Td (%1X)Tj 12 0 Td (%1X)Tj 12 0 Td (%1X)Tj 12 0 Td (%1X)Tj 12 0 Td(%1X)Tj 12 0 Td (%1X)Tj 12 0 Td ",
                          arguments: [planet.starport, planet.internalSize, planet.internalAtmosphere,
                                      planet.internalHydrographics, planet.internalPopulation, planet.internalGovernment,
                                      planet.internalLawLevel, planet.internalTechnologicalLevel])
        var ggBaseTC = ""
        ggBaseTC += planet.gasGiant ? "G" : ""
        var base = ""
        if planet.bases.contains(.navalBase) && planet.bases.contains(.scoutBase) {
            base += "A"
        } else if planet.bases.contains(.navalBase) {
            base += "N"
        } else if planet.bases.contains(.scoutBase) {
            base += "S"
        } else if planet.facilities.contains(.militaryBase) {
            base += "M"
        }

        if base != "" && ggBaseTC != "" { ggBaseTC += " " }
        ggBaseTC += base
        if ggBaseTC != "" { ggBaseTC += "; " }
        ggBaseTC += planet.shortTradeClassifications
        //        p += "0 -11 Td (\(planet.shortTradeClassifications))Tj 100 Tz\n"
        pdfText += composite(ggBaseTC, blockWidth: 115)
        pdfText += "\nET\n"
        // add it to the current/last page
        subsectorData[subsectorData.endIndex.advanced(by: -1)]  += pdfText

        tas7line += 1

        if DEBUG { mapData += "% Rendering \(planet.name) to map\n" }
        let mapCoords: CoordPair = hexLocToCoord(planet.coordinateX, y: planet.coordinateY)
        var width: Double = strWidth(planet.starport, fontName: fontDetails[0].baseFontName, fontSize: namePts)
        mapData += "BT /\(fontDetails[0].fontName) \(namePts~) Tf \((mapCoords.x - width / 2)~) \((mapCoords.y + 5)~) Td (\(planet.starport))Tj ET\n"
        let dispName = planet.internalPopulation >= 9 ? planet.name.uppercased() : planet.name
        width = strWidth(dispName, fontName: fontDetails[0].baseFontName, fontSize: namePts * 0.75)
        mapData += "BT /\(fontDetails[0].fontName) \(namePts~) Tf \((mapCoords.x - width / 2)~) \((mapCoords.y - 6.0 - namePts)~) Td 75 Tz (\(dispName))Tj 100 Tz ET\n"
        if planet.internalSize == 0 {
            mapData += asteroids(mapCoords.x, y: mapCoords.y, size: asteroidsSize)
        } else {
            if planet.internalHydrographics > 0 {
                mapData += xobject(xobjPlanetDryId, atCoords: mapCoords)
            } else {
                mapData += xobject(xobjPlanetWetId, atCoords: mapCoords)
            }
        }
        if planet.gasGiant {
            mapData += xobject(xobjGasGiantId, atCoords: mapCoords + CoordPair(x: 10, y: 10))
        }
        if planet.bases.contains(.navalBase) {
            mapData += xobject(xobjNavalBaseId, atCoords: mapCoords - CoordPair(x: 10, y: 0))
        }
        if planet.bases.contains(.scoutBase) {
            mapData += xobject(xobjScoutBaseId, atCoords: mapCoords + CoordPair(x: -10, y: 10))
        }
    }

    func newPage(_ data: String) {
        let contents = PdfContents(id: currObjId)
        pdfObjects[currObjId] = contents
        contents.body += "<< /Length \(data.count)\n >>\nstream\n"
        contents.body += data
        contents.body += "\nendstream\n"
        currObjId += 1
        let page = PdfPage(id: currObjId, parent: pages!, contents: contents, procset: procSet!, fonts: fonts, xobjects: xobjs, max: pageMax)
        pages?.kids.append(page)
        pdfObjects[currObjId] = page
        currObjId += 1
    }

    func end() {
        // produce TAS Form 6 page
        newPage(mapData)

        for subsectorPage in subsectorData {
            newPage(subsectorPage)
        }

        // ok now we handle the star system details.
        for systemPage in systemData {
            newPage(systemPage)
        }
        // sort the structure in id order
        let sortedPdfObjects = pdfObjects.sorted(by: {$0.0 < $1.0})

        let pdfHdr = "%PDF-1.4\n%\u{8f}\u{8f}\n"
        pdfContent += pdfHdr

        var offset: Int = pdfHdr.count + 2
        var xref: String = """
                           xref
                           0 \(sortedPdfObjects.count + 1)
                           0000000000 65535 f
                           """
        for (_, pdfObject) in sortedPdfObjects {
            xref += "\(leftPad(offset)) 00000 n \n"
            pdfContent += pdfObject.content
            offset += pdfObject.content.count
        }

        pdfContent += xref

        pdfContent += "trailer\n"
        pdfContent += " << /Size \(sortedPdfObjects.count + 1)\n"
        pdfContent += "    /Root 1 0 R\n"
        pdfContent += "    /ID [ <123456> <123456> ]\n"
        pdfContent += " >>\n"
        pdfContent += "startxref \(offset)\n"
        pdfContent += "%%EOF"
    }
}
