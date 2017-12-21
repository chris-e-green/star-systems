//
//  Pdf.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

postfix operator ~
postfix func ~ (value: Double)->String {
    var result = String(format: "%.1f", value)
    if result[result.index(result.endIndex, offsetBy: -2)...result.index(result.endIndex, offsetBy: -1)] == ".0" {
        result.remove(at: result.index(result.endIndex, offsetBy: -1))
        result.remove(at: result.index(result.endIndex, offsetBy: -1))
    }
    return result
}
postfix func ~ (value: Float)->String {
    var result = String(format: "%.1f", value)
    if result[result.index(result.endIndex, offsetBy: -2)...result.index(result.endIndex, offsetBy: -1)] == ".0" {
        result.remove(at: result.index(result.endIndex, offsetBy: -1))
        result.remove(at: result.index(result.endIndex, offsetBy: -1))
    }
    return result
}

struct CoordPair: CustomStringConvertible {
    var x: Double
    var y: Double
    var description: String {
        return "\(x~) \(y~)"
    }
}

func -(left: CoordPair, right: CoordPair) -> CoordPair {
    return CoordPair(x: left.x - right.x, y: left.y - right.y)
}

func +(left: CoordPair, right: CoordPair) -> CoordPair {
    return CoordPair(x: left.x + right.x, y: left.y + right.y)
}

struct RectCoords: CustomStringConvertible {
    var bl: CoordPair
    var tr: CoordPair
    var description: String {
        return "\(bl) \(tr)"
    }
}

func -(left: RectCoords, right: RectCoords) -> RectCoords {
    return RectCoords(bl: left.bl - right.bl, tr: left.tr - right.tr)
}

func +(left: RectCoords, right: RectCoords) -> RectCoords {
    return RectCoords(bl: left.bl + right.bl, tr: left.tr + right.tr)
}

class PdfObj {
    var id: Int
    var content: String { return "\(id) 0 obj\n\(body)endobj\n" }
    var body: String { return "" }
    
    init(id: Int) {
        self.id = id
    }
}

class PdfCatalog: PdfObj {
    var pages : PdfPages?
    override var body: String {
        var s: String = ""
        s += "<<\n"
        s += "   /Type /Catalog\n"
        s += "   /Pages \(pages!.id) 0 R\n"
        s += ">>\n"
        return s
    }
    
    init(id:Int, pages:PdfPages) {
        super.init(id: id)
        self.pages = pages
    }
}

class PdfPages: PdfObj {
    var kids:[PdfPage?] = []
    override var body: String {
        var s: String = ""
        s += "<<\n"
        s += "   /Type /Pages\n"
        s += "   /Kids ["
        for k in kids {
            s += "\(k!.id) 0 R "
        }
        s += "]\n"
        s += "   /Count \(kids.count)\n"
        s += ">>\n"
        return s
    }
}

class PdfPage: PdfObj {
    var parent: PdfPages?
    var contents: PdfContents?
    var procset: PdfProcSet?
    var fonts:[PdfFont]=[]
    var xobjects:[PdfXObject]?
    var max: CoordPair?
    override var body: String {
        var s: String = ""
        s += "<<\n"
        s += "   /Type /Page\n"
        s += "   /Parent \(parent!.id) 0 R\n"
        s += "   /MediaBox [0 0 \(max!)]\n"
        s += "   /Contents \(contents!.id) 0 R\n"
        s += "   /Resources <<\n"
        s += "      /ProcSet \(procset!.id) 0 R\n"
        s += "      /Font <<\n"
        for f in fonts {
            s += "          /\(f.fontId!) \(f.id) 0 R\n"
        }
        s += "      >>\n"
        if xobjects!.count > 0 {
            s += "      /XObject <<\n"
            for x in xobjects! {
                s += "          /\(x.xobjId!) \(x.id) 0 R\n"
            }
            s += "      >>\n"
        }
        s += "   >>\n"
        s += ">>\n"
        return s
    }
    
    init(id:Int, parent: PdfPages, contents: PdfContents, procset: PdfProcSet, fonts:[PdfFont], xobjects:[PdfXObject], max: CoordPair) {
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
        return "   [/PDF /Text]\n"
    }
}

class PdfFont: PdfObj {
    var fontId: String?
    var fontName: String?
    override var body: String {
        var s: String = ""
        s += "<<\n"
        s += "   /Type /Font\n"
        s += "   /Subtype /Type1\n"
        s += "   /Name /\(fontId!) /BaseFont /\(fontName!)\n"
        s += ">>\n"
        return s
    }
    init(id: Int, fontId: String, fontName: String) {
        super.init(id: id)
        self.fontId = fontId
        self.fontName = fontName
    }
}

class PdfContents: PdfObj {
    var bodyStr : String = ""
    override var body: String {
        get {
            return bodyStr
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
    var stream : String?
    var bbox : RectCoords?
    var xobjs: [PdfXObject]=[]
    var fonts:[PdfFont]=[]
    override var body: String {
        var s: String = ""
        s += "<<\n"
        s += "   /Type /XObject\n"
        s += "   /Subtype /Form\n"
        s += "   /BBox [\(bbox!)]\n"
        s += "   /Resources <<\n"
        s += "      /ProcSet [/PDF /Text]\n"
        if fonts.count > 0 {
            s += "      /Font <<\n"
            for f in fonts {
                s += "          /\(f.fontId!) \(f.id) 0 R\n"
            }
            s += "      >>\n"
        }
        if xobjs.count > 0 {
            s += "      /XObject <<\n"
            for x in xobjs {
                s += "        /\(x.xobjId!) \(x.id) 0 R\n"
            }
            s += "      >>\n"
        }
        s += "   >>\n"
        s += "   /Length \(stream!.count - 1)\n"
        s += ">>\n"
        s += "stream\n"
        s += stream!
        s += "endstream\n"
        return s
    }
    
    init(id: Int, xobjId: String, stream: String, bbox: RectCoords, fonts:[PdfFont] = [], xobjs: [PdfXObject] = []) {
        super.init(id: id)
        self.xobjId = xobjId
        self.stream = stream
        self.bbox = bbox
        self.fonts = fonts
        self.xobjs = xobjs
    }
}

class Pdf {
    let fontDetails    : [(name: String, id: String)] = [("Helvetica", "F1"), ("Helvetica-Bold", "F2"), ("Helvetica-Oblique", "F3"), ("Courier", "F4")]
    let fontName1      : String = "Helvetica"
    let fontId1        : String = "F1"
    let fontName2      : String = "Helvetica-Bold"
    let fontId2        : String = "F2"
    let xobjPlanetDry  : String = "circle-blue-filled"
    let xobjPlanetWet  : String = "circle-blue-empty"
    let xobjGasGiant   : String = "circle-black-filled"
    let xobjNavalBase  : String = "triangle-black-filled"
    let xobjScoutBase  : String = "star-black-filled"
    let xobjTASForm6   : String = "tas-form-6"
    let xobjTASForm7   : String = "tas-form-7"
    let xobjISForm7    : String = "is-form-7"
    let xobjISForm7a   : String = "is-form-7-continuation"
    let xobjHex        : String = "hex"
    let coordPts       : Double = 5.0
    let namePts        : Double = 8.0
    let listPts        : Double = 11.0
    let listLineHeight : Double = 23.5
    let headingPts     : Double = 12.0
    let textPts        : Double = 8.0
    let sqrt3          : Double = sqrt(3.0)
    let invsqrt3       : Double = 1.0 / sqrt(3.0)
    let pageMax        : CoordPair = CoordPair(x: 420, y: 595.0) // A5
    let pageMargin     : RectCoords = RectCoords(
        bl: CoordPair(x: 26.0, y: 41.0),
        tr: CoordPair(x: 30.0, y: 22.5)
    )
    let contentMargin   : RectCoords = RectCoords(
        bl: CoordPair(x: 10.0, y: 10.0),
        tr: CoordPair(x: 10.0, y: 10.0)
    )
    var mapBoxSize     : CoordPair {
        return CoordPair(
            x: contentMargin.bl.x + contentMargin.bl.x + 328,
            y: pageMax.y - pageMargin.tr.y - pageMargin.bl.y
        )
    }
    var tasForm7ListTL         : CoordPair {
        return CoordPair(
            x: pageMargin.bl.x + 7.0,
            y: pageMax.y - pageMargin.tr.y - 93.0)
    }
    
    var hexHeight      : Double = 45.0
    var hexWidth       : Double { return hexHeight / sqrt3 }
    let planetRadius   : Double = 3.0
    let asteroidsSize  : Double = 6.0
    let gasGiantRadius : Double = 1.5
    let navalBaseSize  : Double = 4.0
    let scoutBaseSize  : Double = 4.0
    var tas7line       : Int    = 0
    var is7line        : Int    = 0
    var is7continued   : Bool   = false
    var mapData    : String = ""
    var subsectorData = [String]()
    var systemData = [String]()
    var pdfContent     : String = ""
    var catalog        : PdfCatalog?
    var pages          : PdfPages?
    var procset        : PdfProcSet?
    var xobjs          : [PdfXObject] = []
    var structure      : [Int:PdfObj] = [:]
    var fonts          : [PdfFont] = []
    #if os(macOS)
    var nsfonts        : [String : NSFont] = [:]
    #else
    var nsfonts        : [String : UIFont] = [:]
    #endif
    var currObjId = 2
    
    func leftPad(_ num: Int)->String {
        let ofsStr = ("0000000000" + String(num))
        return String(ofsStr[ofsStr.index(ofsStr.endIndex, offsetBy: -10)...])
    }
    
    func strWidth(_ str:String, fontName: String, fontSize:Double) -> Double {
        #if os(macOS)
        var font:NSFont?
        #else
        var font:UIFont?
        #endif
        font = nsfonts["\(fontName)\(fontSize)"]
        if font == nil {
            #if os(macOS)
            font = NSFont(name: fontName, size:CGFloat(fontSize))
            #else
            font = UIFont(name: fontName, size: CGFloat(fontSize))
            #endif
            nsfonts["\(fontName)\(fontSize)"] = font
        }
        let ctl:CTLine = CTLineCreateWithAttributedString(NSAttributedString(string:str, attributes: [NSAttributedStringKey.font:font!]))
        let width:Double = CTLineGetTypographicBounds(ctl, nil, nil, nil)// / 12.0 * fontSize
        return width
    }
    
    func hline(_ y: Double, minX: Double, maxX: Double)->String {
        return "\(minX~) \(y~) m \(maxX~) \(y~) l S\n"
    }
    
    func vline(_ x: Double, minY: Double, maxY: Double)->String {
        return "\(x~) \(minY~) m \(x~) \(maxY~) l S\n"
    }
    
    func xobject(_ xobjName: String, at: CoordPair)->String {
        return "q 1 0 0 1 \(at) cm /\(xobjName) Do Q\n"
    }
    
    func circle(_ x:Double, y:Double, radius: Double, filled:Bool, blue:Bool)->String {
        let magic:Double = radius * 0.551784
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
    
    func asteroids(_ x:Double, y:Double, size: Double)->String {
        var asteroidStr = ""
        if DEBUG { asteroidStr += "% asteroid at (\(x~), \(y~))\n" }
        var xdisp : Double = 0.0
        var ydisp : Double = 0.0
        let intsz = UInt32(size)
        for _ in 1..<20 {
            xdisp = Double(arc4random_uniform(intsz)+arc4random_uniform(intsz)) - size
            ydisp = Double(arc4random_uniform(intsz)+arc4random_uniform(intsz)) - size
            asteroidStr += circle(x + xdisp, y: y + ydisp, radius: 0.5, filled: true, blue: false)
        }
        return asteroidStr
    }
    
    func triangle(_ x:Double, y:Double, size:Double)->String {
        var triangleStr = ""
        if DEBUG { triangleStr += "% triangle at (\(x~), \(y~))\n" }
        triangleStr += "\((x - size / 2.0)~) \(y~) m \(x~) \((y + 0.866 * size)~) l "
        triangleStr += "\((x + size / 2.0)~) \(y~) l h f S\n"
        return triangleStr
    }
    
    func star(_ x:Double, y: Double, size:Double)->String {
        let xf1:Double = 0.809 * size
        let yf1:Double = 0.182 * size
        let xf2:Double = 0.191 * size
        let yf2:Double = 0.77 * size
        let xf3:Double = 0.309 * size
        let xf4:Double = 0.5 * size
        let yf3:Double = 0.406 * size
        var starStr = ""
        if DEBUG { starStr += "% asterisk at (\(x~), \(y~))\n" }
        starStr += "\((x - xf1)~) \((y + yf1)~) m \((x - xf2)~) \((y + yf1)~) l "
        starStr += "\(x~) \((y + yf2)~) l \((x + xf2)~) \((y + yf1)~) l "
        starStr += "\((x + xf1)~) \((y + yf1)~) l \((x + xf3)~) \((y - yf1)~) l "
        starStr += "\((x + xf4)~) \((y - yf2)~) l \(x~) \((y - yf3)~) l "
        starStr += "\((x - xf4)~) \((y - yf2)~) l \((x - xf3)~) \((y - yf1)~) l h f S\n"
        return starStr
    }
    
    func drawHex(_ x: Double, y: Double, height: Double)-> String {
        let topBottomVar:Double = invsqrt3 * height / 2.0
        let middleVar:Double = invsqrt3 * height
        let heightVar:Double = height / 2.0
        var s = ""
        if DEBUG { s += "% hex at (\(x~), \(y~))\n" }
        s += "\((x - topBottomVar)~) \((y - heightVar)~) m "
        s += "\((x + topBottomVar)~) \((y - heightVar)~) l "
        s += "\((x + middleVar)~) \(y~) l "
        s += "\((x + topBottomVar)~) \((y + heightVar)~) l "
        s += "\((x - topBottomVar)~) \((y + heightVar)~) l "
        s += "\((x - middleVar)~) \(y~) l "
        s += "\((x - topBottomVar)~) \((y - heightVar)~) l h S\n"
        return s
    }
    
    func hex(_ x: Double, y: Double, height: Double, label: String)-> String {
        var hexStr = ""
        if DEBUG { hexStr += "% hex at (\(x~), \(y~))\n" }
        let (fn, fid) = fontDetails[0]
        hexStr += "q 1 0 0 1 \(x~) \(y~) cm /\(xobjHex) Do Q\n"
        let labelWidth:Double = strWidth(label, fontName: fn, fontSize:coordPts)
        hexStr += "BT /\(fid) \(coordPts~) Tf \((x - labelWidth / 2.0)~) \((y + 14.0)~) Td (\(label))Tj ET\n"
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
            ptsY = ptsY - hexHeight / 2.0
        }
        if map {
            ptsY = mapBoxSize.y - 12 - ptsY
        } else {
            ptsY = mapBoxSize.y + 17 - ptsY
        }
        return CoordPair(x: ptsX, y: ptsY)
    }
    
    func listCoords(_ x: Int, y: Int) -> CoordPair {
        return CoordPair(x: tasForm7ListTL.x,
                         y: tasForm7ListTL.y - Double(tas7line + 1) * listLineHeight)
    }
    
    func showText(_ text: String, x: Double, y: Double, heading:Bool = false, small: Bool = true, narrow: Bool = false)->String {
        var result = "BT /F"
        if heading {
            result += "2 \(headingPts~)"
        } else {
            result += "1 "
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
    
    func drawTASForm6()->String {
        var result = ""
        
        //----------------------------------------------------------
        // Draw TAS Form 6.
        if DEBUG {
            result += "%-----------------------------------------------\n"
            result += "% Draw TAS Form 6.\n"
            result += "%-----------------------------------------------\n"
            //----------------------------------------------------------
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
        let lblWidth = strWidth(lbl, fontName: fontName2, fontSize: headingPts)
        result += showText(lbl, x: mapBoxSize.x - lblWidth, y: 0, heading: true)
        result += showText("SUBSECTOR MAP GRID", x: 6, y: form.y - 15, heading: true)
        result += showText("1. Subsector Name", x: 200, y: form.y)
        
        // draw vertical lines in header
        result += "1 w\n"
        result += vline(190, minY: form.y + headingPts, maxY: form.y - 20)
        result += vline(340, minY: form.y + headingPts, maxY: form.y - 20)
        
        // draw hexagons in map
        
        result += "0.5 g 0.5 G\n"
        
        for x in 1 ... 8 {
            for y in 1 ... 10 {
                let c:CoordPair = hexLocToCoord(x, y: y, map: true)
                let s:String = String(format:"%02d%02d",arguments:[x,y])
                result += hex(c.x, y:c.y, height:hexHeight, label: s)
            }
        }
        result += "0 g 0 G\n"
        if DEBUG {
            result += "%-----------------------------------------------\n"
        }
        return result
    }
    
    func drawISForm7(_ first:Bool = true)->String {
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
        
        func lineToY(_ lineNum:Double)->Double {
            return form.y - 20 - (lineNum - 1) * hLineHeight
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
            //line below fourth row
            formPdf += hline(lineToY(curLineNum), minX: 0, maxX: form.x)
        }
        
        formPdf += "0.5 w\n"
        var rows = 19
        if !first { rows = 21 }
        for i in 1..<rows {
            let j = Double(i) * listLineHeight
            formPdf += hline(lineToY(curLineNum) - j, minX: 0, maxX: form.x)
            let y = lineToY(curLineNum) - j + 3.5
            // orbit boxes
            formPdf += "\(headingInset~) \(y~) \(orbitBox) re S\n"
            formPdf += "\((headingInset + orbitBox.x + orbitBoxSep)~) \(y~) \(orbitBox) re S\n"
            // UWP boxes
            formPdf += "\(guideBoxStartX~) \((y + guideBox.y)~) m \(guideBoxStartX~) \(y~) l "
            for k in 1...8 {
                formPdf += "\((guideBoxStartX + Double(k) * guideBox.x)~) \(y~) l "
                formPdf += "\((guideBoxStartX + Double(k) * guideBox.x)~) \((y + guideBox.y)~) l "
                formPdf += "\((guideBoxStartX + Double(k) * guideBox.x)~) \(y~) m "
            }
            formPdf += "S\n"
        }
        // form footer
        var footer = "IS Form 7"
        if !first { footer += " (Reverse)" }
        formPdf += showText("IS Form 7", x: 0, y: 0, heading: true)
        let footer2width = strWidth("Star System Data", fontName: fontName2, fontSize: headingPts)
        formPdf += showText("Star System Data", x: form.x - footer2width, y: 0, heading: true)
        return formPdf
    }
    
    func drawTASForm7()->String {
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
        for i in 1..<19 {
            let j = 90.0 + Double(i) * listLineHeight
            result += hline(form.y - j, minX: 0, maxX: form.x)
            var x = 108.0
            let y = form.y - j + 3.5
            result += "\(x~) \((y + 16.5)~) m \(x~) \(y~) l "
            for k in 1...4 {
                result += "\((x + Double(k) * 12.0)~) \(y~) l "
                result += "\((x + Double(k) * 12.0)~) \((y + 16.5)~) l "
                result += "\((x + Double(k) * 12.0)~) \(y~) m "
            }
            result += "S\n"
            x += 60.0
            result += "\(x~) \((y + 16.5)~) m \(x~) \(y~) l "
            for k in 1...8 {
                result += "\((x + Double(k) * 12.0)~) \(y~) l "
                result += "\((x + Double(k) * 12.0)~) \((y + 16.5)~) l "
                result += "\((x + Double(k) * 12.0)~) \(y~) m "
            }
            result += "S\n"
        }
        result += showText("TAS Form 7", x: 0, y: 0, heading: true)
        let lbl = "Subsector World Data"
        let lblWidth = strWidth(lbl, fontName: fontName2, fontSize: headingPts)
        result += showText(lbl, x: form.x - lblWidth, y: 0, heading: true)
        result += showText("SUBSECTOR WORLD DATA", x: 10, y: form.y - 21, heading: true)
        result += showText("1. Date of Preparation", x: 210, y: form.y)
        result += showText("2. Subsector Name", x: 10, y: form.y - 33)
        result += showText("3. Sector Name", x: 210, y: form.y - 33)
        result += "BT /F3 10 Tf 5 \((form.y - 85)~) Td (World Name)Tj 102 0 Td (Location)Tj 60 0 Td (UPP)Tj 110 0 Td (Remarks)Tj ET\n"
        return result
    }
    
    func start() {
        procset = PdfProcSet(id: currObjId)
        structure[currObjId] = procset
        currObjId += 1
        
        for (fontName, fontId) in fontDetails {
            let font = PdfFont(id: currObjId, fontId: fontId, fontName: fontName)
            fonts.append(font)
            structure[currObjId] = font
            currObjId += 1
        }
        
        var xobj = PdfXObject(id: currObjId, xobjId: xobjPlanetDry,
                              stream: circle(0, y:0, radius: planetRadius,
                                filled:true, blue: true),
                              bbox: RectCoords(
                                bl: CoordPair(
                                    x: -1 * planetRadius,
                                    y: -1 * planetRadius),
                                tr: CoordPair(
                                    x: planetRadius,
                                    y:planetRadius)))
        xobjs.append(xobj)
        structure[currObjId] = xobj
        currObjId += 1
        
        xobj = PdfXObject(id: currObjId, xobjId: xobjPlanetWet,
                          stream: circle(0, y:0, radius:planetRadius,
                            filled:false, blue: true),
                          bbox: RectCoords(
                            bl: CoordPair(
                                x: -1.1 * planetRadius ,
                                y: -1.1 * planetRadius),
                            tr: CoordPair(
                                x: 1.1 * planetRadius,
                                y:1.1 * planetRadius)))
        xobjs.append(xobj)
        structure[currObjId] = xobj
        currObjId += 1
        
        xobj = PdfXObject(id: currObjId, xobjId: xobjGasGiant,
                          stream: circle(0, y:0, radius:gasGiantRadius,
                            filled:true, blue: false),
                          bbox: RectCoords(
                            bl: CoordPair(
                                x: -1 * gasGiantRadius,
                                y: -1 * gasGiantRadius),
                            tr: CoordPair(
                                x: gasGiantRadius,
                                y:gasGiantRadius)))
        xobjs.append(xobj)
        structure[currObjId] = xobj
        currObjId += 1
        
        xobj = PdfXObject(id: currObjId, xobjId: xobjNavalBase,
                          stream: triangle(0, y:0, size: navalBaseSize),
                          bbox: RectCoords(
                            bl: CoordPair(
                                x: -1 * navalBaseSize / 2,
                                y: 0),
                            tr: CoordPair(
                                x: navalBaseSize / 2,
                                y: navalBaseSize)))
        xobjs.append(xobj)
        structure[currObjId] = xobj
        currObjId += 1
        
        xobj = PdfXObject(id: currObjId, xobjId: xobjScoutBase,
                          stream: star(0, y:0, size:scoutBaseSize),
                          bbox: RectCoords(
                            bl: CoordPair(
                                x: -1 * scoutBaseSize,
                                y: -1 * scoutBaseSize),
                            tr: CoordPair(
                                x: scoutBaseSize,
                                y:scoutBaseSize)))
        xobjs.append(xobj)
        structure[currObjId] = xobj
        currObjId += 1
        
        let hexXobj = PdfXObject(id: currObjId, xobjId: xobjHex,
                                 stream: drawHex(0, y: 0, height: hexHeight),
                                 bbox: RectCoords(
                                    bl: CoordPair(x: 0 - hexWidth, y: 0 - hexHeight),
                                    tr: CoordPair(x: hexWidth, y:hexHeight)))
        xobjs.append(hexXobj)
        structure[currObjId] = hexXobj
        currObjId += 1
        
        xobj = PdfXObject(id: currObjId, xobjId: xobjTASForm6,
                          stream: drawTASForm6(),
                          bbox: RectCoords(
                            bl: CoordPair(x: -2, y: -2),
                            tr: CoordPair(x:366, y: mapBoxSize.y + headingPts + 2)),
                          fonts: fonts, xobjs:[hexXobj])
        xobjs.append(xobj)
        structure[currObjId] = xobj
        currObjId += 1
        
        xobj = PdfXObject(id: currObjId, xobjId: xobjTASForm7,
                          stream: drawTASForm7(),
                          bbox: RectCoords(
                            bl: CoordPair(x: -2, y: -2),
                            tr: CoordPair(x: 366, y: mapBoxSize.y + headingPts + 2)),
                          fonts:fonts)
        xobjs.append(xobj)
        structure[currObjId] = xobj
        currObjId += 1
        
        xobj = PdfXObject(id: currObjId, xobjId: xobjISForm7,
                          stream: drawISForm7(),
                          bbox: RectCoords(
                            bl: CoordPair(x: -2, y: -2),
                            tr: CoordPair(x: 366, y: mapBoxSize.y + headingPts + 2)),
                          fonts:fonts)
        xobjs.append(xobj)
        structure[currObjId] = xobj
        currObjId += 1
        
        xobj = PdfXObject(id: currObjId, xobjId: xobjISForm7a,
                          stream: drawISForm7(false),
                          bbox: RectCoords(
                            bl: CoordPair(x: -2, y: -2),
                            tr: CoordPair(x: 366, y: mapBoxSize.y + headingPts + 2)),
                          fonts:fonts)
        xobjs.append(xobj)
        structure[currObjId] = xobj
        currObjId += 1
        
        pages = PdfPages(id:currObjId)
        structure[currObjId] = pages
        
        currObjId += 1
        
        catalog = PdfCatalog(id: 1, /*outline: outline!, */pages: pages!)
        structure[1] = catalog
        
        mapData = xobject(xobjTASForm6, at: pageMargin.bl - CoordPair(x:0, y:headingPts))
        //        mapData = "q 1 0 0 1 \(pageMargin.bl - CoordPair(x:0, y:headingPts)) cm /\(xobjTASForm6) Do Q\n"
        // create a new TAS Form 7 page string (with append) and start it off with form invocation.
        subsectorData.append(xobject(xobjTASForm7, at: pageMargin.bl - CoordPair(x:0, y:headingPts)))
        //        subsectorData.append("q 1 0 0 1 \(pageMargin.bl - CoordPair(x:0, y:headingPts)) cm /\(xobjTASForm7) Do Q\n")
        
        // create a new IS Form 7 page string (with append) and start it off with form invocation.
        //        systemData.append(xobject(xobjISForm7, at: pageMargin.bl - CoordPair(x:0, y:headingPts)))
        //        systemData.append("q 1 0 0 1 \(pageMargin.bl - CoordPair(x:0, y:headingPts)) cm /\(xobjISForm7) Do Q\n")
    }
    
    // the purpose of composite is to take the supplied content string and turn it into an appropriate pdf text block.
    // if the string is too long for a single line it will split into two lines and return; if it fits on a single line
    // it will format as a single line and return that line block.
    // blockWidth is in points.
    // proposed algorithm: 
    //    first, check the string width as supplied. If it fits, we turn it into a single line.
    //    if it didn't fit, then it must be more than one line long. We split it into words
    //      and progressively move the last word to a second line, until the first line
    //      fits. The first and second lines then become the return value.
    func composite(_ content: String, blockWidth: Double)->String {
        var result = ""
        var line1 = content
        var line2 = ""
        if strWidth(line1, fontName: fontName1, fontSize: 11) * 0.6 < blockWidth {
            // 1 line format is 6 0 Td 75 Tz (line1)Tj 100 Tz"
            result = "2 0 Td 60 Tz (\(line1))Tj 100 Tz"
        } else {
            var contentArray = line1.components(separatedBy: " ")
            let lastIdx = contentArray.endIndex.advanced(by: -1)
            for (i, _) in contentArray.enumerated().reversed() {
                line1 = contentArray[0...(i - 1)].joined(separator: " ")
                line2 = contentArray[i...lastIdx].joined(separator: " ")
                if strWidth(line1, fontName: fontName1, fontSize: 11) * 0.6 < blockWidth {
                    // we have a short enough line 1 now.
                    result = "2 5.5 Td 60 Tz (\(line1))Tj 0 -11 Td (\(line2))Tj 100 Tz"
                    break
                }
            }
            // 2 line format is "6 5.5 Td 75 Tz (line1)Tj 0 -11 Td (line2))Tj 100 Tz"
        }
        return result
    }
    
    func displaySat(_ orbitstr: String, suborbitstr: String, o: Satellite, y: Double, isSat: Bool = false) -> String {
        let orbit1col = 50.0 // right side because right-aligned
        let orbit2col = 77.0 // right side because right-aligned
        let namecol = 90.0
        let uwpcol = 172.0
        let desccol = 270.0
        var s = ""
        let orb1W = strWidth(orbitstr, fontName: fontName1, fontSize: listPts) * 0.75
        let orb2W = strWidth(suborbitstr, fontName: fontName1, fontSize: listPts) * 0.75
        s += showText(orbitstr, x: orbit1col - orb1W, y: y, heading: false, small: false, narrow: true)
        s += showText(suborbitstr, x: orbit2col - orb2W, y: y, heading: false, small: false, narrow: true)
        s += showText(o.name, x: namecol, y: y, heading: false, small: false)
        if o is Planet {
            let p = o as! Planet
            s += "BT /\(fontId1) \(listPts~) \(uwpcol~) \(y) Td "
            s += pdfPlanet(p)
            s += "ET\n"
        } else if o is GasGiant {
            let g = o as! GasGiant
            s += showText(g.size.description, x: desccol, y: y, heading: false, small: false, narrow: true)
        } else if o is EmptyOrbit {
            s += showText("Empty orbit", x: namecol, y: y, heading: false, small: false)
        } else if o is Star {
            let st = o as! Star
            s += showText("\(st.specSize) companion", x: desccol, y: y, heading: false, small: false, narrow: true)
        }
        
        return s
    }
    
    func display(_ starSystem: StarSystem) {
        let p = starSystem.mainWorld!
        p.coordinateX = starSystem.coordinateX
        p.coordinateY = starSystem.coordinateY
        p.gasGiant = starSystem.gasGiants
        display(p)
        for star in starSystem.stars {
            systemData.append(xobject(xobjISForm7, at: pageMargin.bl - CoordPair(x:0, y:headingPts)))
            
            var s = ""
            let loc = String(format: "%02d%02d", arguments:[p.coordinateX, p.coordinateY])
            s += showText(starSystem.subsectorName, x: 250, y: mapBoxSize.y - 10, heading: false, small: false)
            s += showText("\(p.name) (\(loc))", x: 60, y: mapBoxSize.y - 10, heading: false, small: false)
            s += showText(star.name, x: 100, y: mapBoxSize.y - 35, heading: false, small: false)
            s += showText(star.specSize, x: 250, y: mapBoxSize.y - 35, heading: false, small: false)
            s += showText("\(star.magnitude)", x: 330, y: mapBoxSize.y - 35, heading: false, small: false)
            let sortedOrbits = star.satellites.orbits.sorted(by: {$0.0 < $1.0})
            // make a sorted array of all orbits
            var orbitLines = [(Int,Int,Satellite)]()
            for (i, o) in sortedOrbits {
                orbitLines.append((i,-1,o))
                // if we are doing a planet or a gas giant, we want to look at the satellites, but if
                // we are doing a star, we don't, because it will be processed separately. We do need
                // to make sure close companions are presented, but they have no satellites of their own.
                if o is Planet || o is GasGiant {
                    let sortedSuborbits = o.satellites.orbits.sorted(by: {$0.0 < $1.0})
                    for (i1, o1) in sortedSuborbits {
                        orbitLines.append((-1, i1, o1))
                    }
                }
            }
            if DEBUG {
                for (i, j, s) in orbitLines {
                    var r = "\t"
                    if i != -1 { r += "\(i)" }
                    r += "\t"
                    if j != -1 { r += "\(j)" }
                    r += "\t\(s.name)\t\(s.type)"
                    print(r)
                }
            }
            var line = 0.0
            for (stellarOrbit, moonOrbit, satellite) in orbitLines {
                if line == 18 {
                    systemData[systemData.endIndex.advanced(by: -1)] += s
                    s = ""
                    systemData.append(xobject(xobjISForm7a, at: pageMargin.bl - CoordPair(x: 0, y: headingPts)))
                    s += showText(star.name, x: 100, y: mapBoxSize.y - 10, heading: false, small: false)
                    s += showText(star.specSize, x: 250, y: mapBoxSize.y - 10, heading: false, small: false)
                    s += showText("\(star.magnitude)", x: 330, y: mapBoxSize.y - 10, heading: false, small: false)
                    line = -2 // this *should* put the line two up on where it normally would be, perfect for the continuation...
                }
                let y = mapBoxSize.y - line * listLineHeight - 78
                if stellarOrbit != -10 { //
                    let orbitstr = stellarOrbit == -1 ? "" : (Double(stellarOrbit) / 10)~
                    // String(format:"%.1f", arguments:[Float(stellarOrbit) / 10])
                    let suborbitstr = moonOrbit == -1 ? "" : (Double(moonOrbit) / 10)~
                    // String(format:"%.1f", arguments:[Float(moonOrbit) / 10])
                    s += displaySat(orbitstr, suborbitstr: suborbitstr, o: satellite, y: y)
                } else { // close orbit, i.e. must be a star.
                    s += showText(satellite.name, x: 90, y: y, heading: false, small: false)
                    s += showText("\(star.specSize) companion in close orbit", x: 270, y: y, heading: false, small: false, narrow: true)
                }
                line += 1
            }
            systemData[systemData.endIndex.advanced(by: -1)] += s
        }
    }
    
    func pdfPlanet(_ planet: Planet)->String {
        var planetStr = ""
        planetStr += String(format:"0 Tc (%@)Tj 12 0 Td (%@)Tj 12 0 Td (%1X)Tj 12 0 Td (%1X)Tj 12 0 Td (%1X)Tj 12 0 Td (%1X)Tj 12 0 Td(%1X)Tj 12 0 Td (%1X)Tj 12 0 Td ", arguments:[planet.starport, planet.size,
            planet._atmosphere, planet._hydrographics, planet._population,
            planet._government, planet._lawLevel, planet._technologicalLevel])
        var basesTCFacilities = ""
        var bases = ""
        if planet.bases.contains(.N) && planet.bases.contains(.S) {
            bases += "Naval, Scout"
        } else if planet.bases.contains(.N) {
            bases += "Naval"
        } else if planet.bases.contains(.S) {
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
            subsectorData.append(xobject(xobjTASForm7, at: pageMargin.bl - CoordPair(x:0, y:headingPts)))
        }
        var p: String = ""
        if DEBUG { p += "% Rendering \(planet.name) to list\n" }
        let c:CoordPair = listCoords(planet.coordinateX, y:planet.coordinateY)
        p += "BT /\(fontId1) \(listPts~) Tf \(c) Td (\(planet.name))Tj "
        p += String(format:"104 0 Td 5.5 Tc (%02d%02d)Tj 0 Tc 60 0 Td ", arguments:[planet.coordinateX, planet.coordinateY])
        p += String(format:"(%@)Tj 12 0 Td (%1X)Tj 12 0 Td (%1X)Tj 12 0 Td (%1X)Tj 12 0 Td (%1X)Tj 12 0 Td (%1X)Tj 12 0 Td(%1X)Tj 12 0 Td (%1X)Tj 12 0 Td ", arguments:[planet.starport, planet._size, planet._atmosphere, planet._hydrographics, planet._population, planet._government, planet._lawLevel,
            planet._technologicalLevel])
//        p += "6 5.5 Td 90 Tz ("
        var ggBaseTC = ""
        ggBaseTC += planet.gasGiant ? "G" : ""
        var base = ""
        if planet.bases.contains(.N) && planet.bases.contains(.S) { base += "A" }
        else if planet.bases.contains(.N) { base += "N" }
        else if planet.bases.contains(.S) { base += "S" }
        else if planet.facilities.contains(.MilitaryBase) { base += "M" }
//        p += planet.bases.contains(.N) ? "N " : ""
//        p += planet.bases.contains(.S) ? "S " : ""
//        p += ")Tj "
        if base != "" && ggBaseTC != "" { ggBaseTC += " " }
        ggBaseTC += base
        if ggBaseTC != "" { ggBaseTC += "; " }
        ggBaseTC += planet.shortTradeClassifications
//        p += "0 -11 Td (\(planet.shortTradeClassifications))Tj 100 Tz\n"
        p += composite(ggBaseTC, blockWidth: 115)
        p += "\nET\n"
        // add it to the current/last page
        subsectorData[subsectorData.endIndex.advanced(by: -1)]  += p
        
        tas7line = tas7line + 1
        
        if DEBUG { mapData += "% Rendering \(planet.name) to map\n" }
        let c1:CoordPair = hexLocToCoord(planet.coordinateX,y:planet.coordinateY)
        var w:Double = strWidth(planet.starport, fontName: fontName1, fontSize: namePts)
        mapData += "BT /\(fontId1) \(namePts~) Tf \((c1.x - w / 2)~) \((c1.y + 5)~) Td (\(planet.starport))Tj ET\n"
        let dispName = planet._population >= 9 ? planet.name.uppercased() : planet.name
        w = strWidth(dispName, fontName: fontName1, fontSize: namePts * 0.75)
        mapData += "BT /\(fontId1) \(namePts~) Tf \((c1.x - w / 2)~) \((c1.y - 6.0 - namePts)~) Td 75 Tz (\(dispName))Tj 100 Tz ET\n"
        if planet._size == 0 {
            mapData += asteroids(c1.x, y: c1.y, size: asteroidsSize)
        } else {
            mapData += "q 1 0 0 1 \(c1) cm "
            if planet._hydrographics > 0 {
                mapData += "/\(xobjPlanetDry)"
            } else {
                mapData += "/\(xobjPlanetWet)"
            }
            mapData +=  " Do Q\n"
        }
        if planet.gasGiant {
            mapData += xobject(xobjGasGiant, at: c1 + CoordPair(x:10,y:10))
            //            mapData += "q 1 0 0 1 \((c1 + CoordPair(x:10,y:10))) cm /\(xobjGasGiant) Do Q\n"
        }
        if planet.bases.contains(.N) {
            mapData += xobject(xobjNavalBase, at: c1 - CoordPair(x:10,y:0))
            //            mapData += "q 1 0 0 1 \((c1 - CoordPair(x:10,y:0))) cm /\(xobjNavalBase) Do Q\n"
        }
        if planet.bases.contains(.S) {
            mapData += xobject(xobjScoutBase, at: c1 + CoordPair(x:-10,y:10))
            //            mapData += "q 1 0 0 1 \((c1 + CoordPair(x:-10, y:10))) cm /\(xobjScoutBase) Do Q\n"
        }
    }
    
    func newPage(_ data: String) {
        let contents = PdfContents(id:currObjId)
        structure[currObjId] = contents
        contents.body += "<< /Length \(data.count)\n >>\nstream\n"
        contents.body += data
        contents.body += "\nendstream\n"
        currObjId += 1
        let page = PdfPage(id: currObjId, parent: pages!, contents: contents, procset: procset!, fonts: fonts, xobjects: xobjs, max: pageMax)
        pages?.kids.append(page)
        structure[currObjId] = page
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
        let structure1 = structure.sorted(by: {$0.0 < $1.0})
        
        let pdfHdr = "%PDF-1.4\n%\u{8f}\u{8f}\n"
        pdfContent += pdfHdr
        
        var offset:Int = pdfHdr.count + 2
        var xref : String = "xref\n0 \(structure1.count + 1)\n0000000000 65535 f \n"
        for (_, m) in structure1 {
            xref += "\(leftPad(offset)) 00000 n \n"
            pdfContent += m.content
            offset += m.content.count
        }
        
        pdfContent += xref
        
        pdfContent += "trailer\n"
        pdfContent += " << /Size \(structure1.count + 1)\n"
        pdfContent += "    /Root 1 0 R\n"
        pdfContent += "    /ID [ <123456> <123456> ]\n"
        pdfContent += " >>\n"
        pdfContent += "startxref \(offset)\n"
        pdfContent += "%%EOF"
    }
}
