//
//  Pdf.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import Foundation
import AppKit

extension Double {
    func f1() -> String {
        return String(format: "%.1f", self)
    }
}

struct CoordPair {
    var x: Double
    var y: Double
    var xs: String {
        return x.f1()
    }
    var ys: String {
        return y.f1()
    }
    var s: String {
        return "\(xs) \(ys)"
    }
}

func -(left: CoordPair, right: CoordPair) -> CoordPair {
    return CoordPair(x: left.x - right.x, y: left.y - right.y)
}

func +(left: CoordPair, right: CoordPair) -> CoordPair {
    return CoordPair(x: left.x + right.x, y: left.y + right.y)
}

struct RectCoords {
    var bl: CoordPair
    var tr: CoordPair
    var s: String {
        return "\(bl.s) \(tr.s)"
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

class Catalog: PdfObj {
    var pages : Pages?
    override var body: String {
        var s: String = ""
        s += "<<\n"
        s += "   /Type /Catalog\n"
        s += "   /Pages \(pages!.id) 0 R\n"
        s += ">>\n"
        return s
    }
    init(id:Int, pages:Pages) {
        super.init(id: id)
        self.pages = pages
    }
}

class Pages: PdfObj {
    var kids:[Page?] = []
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

class Page: PdfObj {
    var parent: Pages?
    var contents: Contents?
    var procset: ProcSet?
    var fonts:[PdfFont]=[]
    var xobjects:[PdfXObject]?
    var max: CoordPair?
    override var body: String {
        var s: String = ""
        s += "<<\n"
        s += "   /Type /Page\n"
        s += "   /Parent \(parent!.id) 0 R\n"
        s += "   /MediaBox [0 0 \(max!.s)]\n"
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
    init(id:Int, parent: Pages, contents: Contents, procset: ProcSet, fonts:[PdfFont], xobjects:[PdfXObject], max: CoordPair) {
        super.init(id: id)
        self.parent = parent
        self.contents = contents
        self.procset = procset
        self.fonts = fonts
        self.xobjects = xobjects
        self.max = max
    }
}

class ProcSet: PdfObj {
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

class Contents: PdfObj {
    var bodyStr : String = ""
    override var body: String {
        get {
            return bodyStr
        }
        set {
            bodyStr = newValue
        }
    }
//    override init(id: Int) {
//        super.init(id: id)
//    }
}

class PdfXObject: PdfObj {
    var xobjId: String?
    var stream : String?
    var bbox : RectCoords?
    var fonts:[PdfFont]=[]
    override var body: String {
        var s: String = ""
        s += "<<\n"
        s += "   /Type /XObject\n"
        s += "   /Subtype /Form\n"
        s += "   /BBox [\(bbox!.s)]\n"
        s += "   /Resources <<\n"
        s += "      /ProcSet [/PDF /Text]\n"
        if fonts.count > 0 {
            s += "      /Font <<\n"
            for f in fonts {
                s += "          /\(f.fontId!) \(f.id) 0 R\n"
            }
            s += "      >>\n"
        }
        s += "   >>\n"
        s += "   /Length \(stream!.characters.count - 1)\n"
        s += ">>\n"
        s += "stream\n"
        s += stream!
        s += "endstream\n"
        return s
    }
    init(id: Int, xobjId: String, stream: String, bbox: RectCoords, fonts:[PdfFont]) {
        super.init(id: id)
        self.xobjId = xobjId
        self.stream = stream
        self.bbox = bbox
        self.fonts = fonts
    }
}

class Pdf {
    let fontDetails    : [(name: String, id: String)] = [("Helvetica", "F1"), ("Helvetica-Bold", "F2"), ("Helvetica-Oblique", "F3"), ("Courier", "F4")]
    let fontName1      : String = "Helvetica"
    let fontId1        : String = "F1"
    let fontName2      : String = "Helvetica-Bold"
    let fontId2        : String = "F2"
    let fontName3      : String = "Helvetica-Oblique"
    let fontId3        : String = "F3"
    let fontName4      : String = "Courier"
    let fontId4        : String = "F4"
//    let xobjId1        : String = "img1"
    let xobjPlanetDry  : String = "circle-blue-filled"
    let xobjPlanetWet  : String = "circle-blue-empty"
    let xobjGasGiant   : String = "circle-black-filled"
    let xobjNavalBase  : String = "triangle-black-filled"
    let xobjScoutBase  : String = "star-black-filled"
    let xobjTASForm7   : String = "tas-form-7"
    let xobjHex        : String = "hex"
    let coordPts       : Double = 5.0
    let namePts        : Double = 8.0
    let listPts        : Double = 11.0
    let listLineHeight : Double = 23.5
    let headingPts     : Double = 12.0
    let textPts        : Double = 8.0
    let mapRows        : Int = 10
    let mapCols        : Int = 8
    let sqrt3          : Double = sqrt(3.0)
    let pageMax        : CoordPair = CoordPair(x: 841.0, y: 595.0)
    let pageMargin     : RectCoords = RectCoords(
        bl: CoordPair(x: 26.0, y: 41.0),
        tr: CoordPair(x: 30.0, y: 22.5)
    )
    let mapBoxMargin   : RectCoords = RectCoords(
        bl: CoordPair(x: 10.0, y: 10.0),
        tr: CoordPair(x: 10.0, y: 10.0)
    )
    var mapBoxSize     : CoordPair {
        return CoordPair(x: mapBoxMargin.bl.x + mapBoxMargin.bl.x + 328, y: pageMax.y - pageMargin.tr.y - pageMargin.bl.y)
    }
    var mapBoxCoords   : RectCoords {
        return RectCoords(bl:CoordPair(x: pageMargin.bl.x + mapBoxMargin.bl.x, y: pageMargin.bl.y + mapBoxMargin.bl.y), tr:CoordPair(x: pageMargin.bl.x + mapBoxSize.x, y: pageMargin.bl.y + mapBoxSize.y))
    }
    let mapListSepMargin: Double = 50.0
    var oddListTL         : CoordPair {
        return CoordPair(
            x: pageMargin.bl.x * 2 + 364.0 + 7.0 + pageMargin.tr.x,
            y: pageMax.y - pageMargin.tr.y - 93.0)
    }
    var evenListTL         : CoordPair {
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
    var line           : Int    = 0
    var listPage       : Int    = 1
    var pageContent    : String = ""
    var page2Content   : String = ""
    var page3Content   : String = ""
    var pdfContent     : String = ""
    var catalog        : Catalog?
    var contents1      : Contents?
    var contents2      : Contents?
    var contents3      : Contents?
    var pages          : Pages?
    var procset        : ProcSet?
    var page           : Page?
    var page2          : Page?
    var page3          : Page?
    var xobjs          : [PdfXObject] = []
    var fontObjs       : [PdfFont] = []
    var structure      : [Int:PdfObj] = [:]
    var fonts          : [PdfFont] = []
    var nsfonts        : [String : NSFont] = [:]
    var currObjId = 2
    
    func leftPad(num: Int)->String {
        let ofsStr = ("0000000000" + String(num))
        return ofsStr.substringFromIndex(ofsStr.endIndex.advancedBy(-10))
    }
 
    func strWidth(str:String, fontName: String, fontSize:Double) -> Double {
        var font:NSFont?
        font = nsfonts[fontName + fontSize.f1()]
        if font == nil {
            font = NSFont(name: fontName, size:CGFloat(fontSize))
            nsfonts[fontName + fontSize.f1()] = font
        }
        let ctl:CTLine = CTLineCreateWithAttributedString(NSAttributedString(string:str, attributes: [NSFontAttributeName:font!]))
        let width:Double = CTLineGetTypographicBounds(ctl, nil, nil, nil)// / 12.0 * fontSize
        return width
    }
    
    func circle(x:Double, y:Double, radius: Double, filled:Bool, blue:Bool)->String {
        let magic:Double = radius * 0.551784
        var circleStr = "% circle at (\(x.f1()), \(y.f1())) r=\(radius.f1())\n"
        if filled && blue {
            circleStr += "0 0.5 1.0 rg "
        }
        circleStr += "0.5 w \((x - radius).f1()) \((y).f1()) m "
        circleStr += "\((x - radius).f1()) \((y + magic).f1()) \((x - magic).f1()) \((y + radius).f1()) \((x).f1()) \((y + radius).f1()) c "
        circleStr += "\((x + magic).f1()) \((y + radius).f1()) \((x + radius).f1()) \((y + magic).f1()) \((x + radius).f1()) \((y).f1()) c "
        circleStr += "\((x + radius).f1()) \((y - magic).f1()) \((x + magic).f1()) \((y - radius).f1()) \((x).f1()) \((y - radius).f1()) c "
        circleStr += "\((x - magic).f1()) \((y - radius).f1()) \((x - radius).f1()) \((y - magic).f1()) \((x - radius).f1()) \((y).f1()) c "
        if filled {circleStr += "f "}
        circleStr += "S 1 w "
        if filled && blue {
            circleStr += "0.0 0.0 0.0 rg"
        }
        circleStr += "\n"
        return circleStr
    }
    
    func asteroids(x:Double, y:Double, size: Double)->String {
        var asteroidStr = "% asteroid at (\(x.f1()), \(y.f1()))\n"
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
    
    func triangle(x:Double, y:Double, size:Double)->String {
        var triangleStr = "% triangle at (\(x.f1()), \(y.f1()))\n"
        triangleStr += "\((x - size / 2.0).f1()) \(y.f1()) m \(x.f1()) \((y + 0.866 * size).f1()) l "
        triangleStr += "\((x + size / 2.0).f1()) \(y.f1()) l h f S\n"
        return triangleStr
    }
    
    func star(x:Double, y: Double, size:Double)->String {
        let xf1 = 0.809 * size
        let yf1 = 0.182 * size
        let xf2 = 0.191 * size
        let yf2 = 0.77 * size
        let xf3 = 0.309 * size
        let xf4 = 0.5 * size
        let yf3 = 0.406 * size
        var starStr = "% asterisk at (\(x.f1()), \(y.f1()))\n"
        starStr += "\((x - xf1).f1()) \((y + yf1).f1()) m \((x - xf2).f1()) \((y + yf1).f1()) l "
        starStr += "\(x.f1()) \((y + yf2).f1()) l \((x + xf2).f1()) \((y + yf1).f1()) l "
        starStr += "\((x + xf1).f1()) \((y + yf1).f1()) l \((x + xf3).f1()) \((y - yf1).f1()) l "
        starStr += "\((x + xf4).f1()) \((y - yf2).f1()) l \(x.f1()) \((y - yf3).f1()) l "
        starStr += "\((x - xf4).f1()) \((y - yf2).f1()) l \((x - xf3).f1()) \((y - yf1).f1()) l h f S\n"
        return starStr
    }
    
    func drawHex(x: Double, y: Double, height: Double)-> String {
        let invSqrt3 = 1.0 / sqrt(3.0)
        let topBottomVar = invSqrt3 * height / 2.0
        let middleVar = invSqrt3 * height
        let heightVar = height / 2.0
        var s = "% hex at (\(x.f1()), \(y.f1()))\n"
        s += "\((x - topBottomVar).f1()) \((y - heightVar).f1()) m "
        s += "\((x + topBottomVar).f1()) \((y - heightVar).f1()) l "
        s += "\((x + middleVar).f1()) \(y.f1()) l "
        s += "\((x + topBottomVar).f1()) \((y + heightVar).f1()) l "
        s += "\((x - topBottomVar).f1()) \((y + heightVar).f1()) l "
        s += "\((x - middleVar).f1()) \(y.f1()) l "
        s += "\((x - topBottomVar).f1()) \((y - heightVar).f1()) l h S\n"
        return s
    }
    
    func hex(x: Double, y: Double, height: Double, label: String)-> String {
        var hexStr = "% hex at (\(x.f1()), \(y.f1()))\n"
        let (fn, fid) = fontDetails[0]
        hexStr += "q 1 0 0 1 \(x.f1()) \(y.f1()) cm /\(xobjHex) Do Q\n"
        let labelWidth:Double = strWidth(label, fontName: fn, fontSize:coordPts)
        hexStr += "BT /\(fid) \(coordPts) Tf \((x - labelWidth / 2.0).f1()) \((y + 14.0).f1()) Td (\(label))Tj ET\n"
        return hexStr
    }
    
    func hexLocToCoord(x: Int, y: Int) -> CoordPair {
        let ptsX:Double = pageMargin.bl.x + mapBoxMargin.bl.x + hexWidth + hexWidth * 1.5 * (Double(x) - 1.0)
        var ptsY:Double = pageMargin.bl.y + mapBoxMargin.bl.y - 2 + 1.5 * hexHeight + hexHeight * (Double(y) - 1.0)
        if x % 2 == 1 {
            ptsY = ptsY - hexHeight / 2.0
        }
        ptsY = pageMax.y - ptsY
        let c:CoordPair = CoordPair(x: ptsX, y: ptsY)
        return c
    }
    
    func listCoords(x: Int, y: Int) -> CoordPair {
        var newX: Double = 0
        var newY: Double = 0
        if listPage % 2 == 1 {
            newX = oddListTL.x
            newY = oddListTL.y
        } else {
            newX = evenListTL.x
            newY = evenListTL.y
        }
        newY = newY - Double(line + 1) * listLineHeight
        let c:CoordPair = CoordPair(x: newX, y: newY)
        return c
    }
    
    
//    func drawTASForm6(form:RectCoords)->String {
//        // bl and tr are the coordinates of the box in absolute
//        // terms relative to the page itself.
//        var formPdf = "% TAS Form 6\n"
//        formPdf += "%-----------------------------------------------\n"
//        //----------------------------------------------------------
//        // Draw TAS Form 6.
//        //----------------------------------------------------------
//        // draw box around map
//        formPdf += "4 w \(form.bl.s) \((form.tr - form.bl).s) re S\n"
//        let box = RectCoords(bl:form.bl + mapBoxMargin.bl, tr: CoordPair(x: form.tr.x - mapBoxMargin.tr.x, y: form.tr.y - mapBoxMargin.tr.y - 39))
//        
//        formPdf += "\(box.bl.s) \((box.tr - box.bl).s) re S\n"
//        formPdf += "\(form.bl.xs) \(box.tr.ys) m \(form.tr.xs) \(box.tr.ys) l S\n"
//
//        // draw labels on map form
//        formPdf += "BT /\(fontId2) \(headingPts) Tf \(form.bl.xs) \(form.bl.y - headingPts) Td (TAS Form 6)Tj ET\n"
//        let lbl1 = "Subsector Map Grid"
//        let w = strWidth(lbl1, fontName: fontName2, fontSize: headingPts)
//        formPdf += "BT /\(fontId2) \(headingPts) Tf \((box.tr.x - w).f1()) \(form.bl.y - headingPts) Td (\(lbl1))Tj ET\n"
//        formPdf += "BT /\(fontId2) \(headingPts) Tf \(form.bl.x + 6) \(form.tr.y - 33) Td  (SUBSECTOR MAP GRID)Tj ET\n"
//        formPdf += "BT /\(fontId1) \(textPts) Tf 200 \(form.tr.y - textPts * 1.5) Td  (1. Subsector Name)Tj ET\n"
//
//        // draw hexagons in map
//        formPdf += "1 w\n"
//        formPdf += "190 \(form.tr.ys) m 190 \(box.tr.ys) l S\n"
//        formPdf += "340 \(form.tr.ys) m 340 \(box.tr.ys) l S\n"
//        formPdf += "0.5 g 0.5 G\n"
//        
//        for x in 1 ... 8 {
//            for y in 1 ... 10 {
//                let c:CoordPair = hexLocToCoord(x, y: y)
//                let s:String = String(format:"%02d%02d",arguments:[x,y])
//                formPdf += hex(c.x, y:c.y, height:hexHeight, label: s)
//            }
//        }
//        formPdf += "0.0 g 0.0 G\n"
//        return formPdf
//
//    }
    
    func drawTASForm7(form:RectCoords)->String {
        var formPdf = "% TAS Form 7\n"
        formPdf += "%-----------------------------------------------\n"
        formPdf += "4 w \(form.bl.s) \((form.tr - form.bl).s) re S 1 w\n"
        formPdf += "\(form.bl.x) \(form.tr.y - headingPts - 25) m \(form.tr.x) \(form.tr.y - headingPts - 25) l S\n"
        formPdf += "\(form.bl.x) \(form.tr.y - headingPts - 58) m \(form.tr.x) \(form.tr.y - headingPts - 58) l S\n"
        formPdf += "\(form.bl.x + 207) \(form.tr.y) m \(form.bl.x + 207) \(form.tr.y - headingPts - 58) l S\n"
        formPdf += "\(form.bl.x) \(form.tr.y - headingPts - 90) m \(form.tr.x) \(form.tr.y - headingPts - 90) l S\n"
        formPdf += "0.5 w\n"
        for i in 1..<19 {
            let j = 90.0 + Double(i) * listLineHeight
            formPdf += "\(form.bl.x) \(form.tr.y - headingPts - j) m \(form.tr.x) \(form.tr.y - headingPts - j) l S\n"
            var x = form.bl.x + 108
            let y = form.tr.y - headingPts - j + 3.5
            formPdf += "\(x) \(y + 16.5) m \(x) \(y) l "
            for k in 1...4 {
                formPdf += "\(x + Double(k) * 12.0) \(y) l "
                formPdf += "\(x + Double(k) * 12.0) \(y + 16.5) l "
                formPdf += "\(x + Double(k) * 12.0) \(y) m "
            }
            formPdf += "S\n"
            x += 60.0
            formPdf += "\(x) \(y + 16.5) m \(x) \(y) l "
            for k in 1...8 {
                formPdf += "\(x + Double(k) * 12.0) \(y) l "
                formPdf += "\(x + Double(k) * 12.0) \(y + 16.5) l "
                formPdf += "\(x + Double(k) * 12.0) \(y) m "
            }
            formPdf += "S\n"
        }
        formPdf += "BT /F2 \(headingPts) Tf \(form.bl.x) \(form.bl.y - headingPts) Td (TAS Form 7)Tj ET\n"
        formPdf += "BT /F2 \(headingPts) Tf \(form.bl.x + 241.9) \(form.bl.y - headingPts) Td (Subsector World Data)Tj ET\n"
        formPdf += "BT /F2 \(headingPts) Tf \(form.bl.x + 10) \(form.tr.y - headingPts - 21) Td (SUBSECTOR WORLD DATA)Tj ET\n"
        formPdf += "BT /F1 \(textPts) Tf \(form.bl.x + 210) \(form.tr.y - headingPts) Td (1. Date of Preparation)Tj ET\n"
        formPdf += "BT /F1 \(textPts) Tf \(form.bl.x + 10) \(form.tr.y - headingPts - 33) Td (2. Subsector Name)Tj ET\n"
        formPdf += "BT /F1 \(textPts) Tf \(form.bl.x + 210) \(form.tr.y - headingPts - 33) Td (3. Sector Name)Tj ET\n"
        formPdf += "BT /F3 10 Tf \(form.bl.x + 5) \(form.tr.y - headingPts - 85) Td (World Name)Tj 102 0 Td (Location)Tj 60 0 Td (UPP)Tj 110 0 Td (Remarks)Tj ET\n"
        return formPdf
    }
    
    func start() {
        procset = ProcSet(id: currObjId)
        structure[currObjId] = procset
        currObjId += 1
        
        var font = PdfFont(id: currObjId, fontId: fontId1, fontName: fontName1)
        fonts.append(font)
        structure[currObjId] = font
        currObjId += 1
        font = PdfFont(id: currObjId, fontId: fontId2, fontName: fontName2)
        fonts.append(font)
        structure[currObjId] = font
        currObjId += 1
        font = PdfFont(id: currObjId, fontId: fontId3, fontName: fontName3)
        fonts.append(font)
        structure[currObjId] = font
        currObjId += 1
        font = PdfFont(id: currObjId, fontId: fontId4, fontName: fontName4)
        fonts.append(font)
        structure[currObjId] = font
        currObjId += 1
        
        var xobj = PdfXObject(id: currObjId, xobjId: xobjPlanetDry,
                              stream: circle(0, y:0, radius: planetRadius,
                                filled:true, blue: true),
                              bbox: RectCoords(
                                bl: CoordPair(
                                    x: -1 * planetRadius,
                                    y: -1 * planetRadius),
                                tr: CoordPair(
                                    x: planetRadius,
                                    y:planetRadius)), fonts:[])
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
                                y:1.1 * planetRadius)), fonts:[])
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
                                y:gasGiantRadius)), fonts:[])
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
                                y: navalBaseSize)), fonts:[])
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
                                y:scoutBaseSize)),
                          fonts:[])
        xobjs.append(xobj)
        structure[currObjId] = xobj
        currObjId += 1
        
        xobj = PdfXObject(id: currObjId, xobjId: xobjTASForm7,
                          stream: drawTASForm7(
                            RectCoords(
                                bl: CoordPair(x: 0, y: 0),
                                tr: CoordPair(x: 364, y: mapBoxSize.y))),
                          bbox: RectCoords(
                            bl: CoordPair(x: -2, y: -14.0),
                            tr: CoordPair(x: 366, y: mapBoxSize.y + 2)),
                          fonts:fonts)
        xobjs.append(xobj)
        structure[currObjId] = xobj
        currObjId += 1
        
        xobj = PdfXObject(id: currObjId, xobjId: xobjHex,
                          stream: drawHex(0, y: 0, height: hexHeight),
                          bbox: RectCoords(
                            bl: CoordPair(x: 0 - hexWidth, y: 0 - hexHeight),
                            tr: CoordPair(x: hexWidth, y:hexHeight)),
                          fonts:[])
        xobjs.append(xobj)
        structure[currObjId] = xobj
        currObjId += 1
        
        let pagesId = currObjId
        
        currObjId += 1

        contents1 = Contents(id:currObjId)
        structure[currObjId] = contents1
        currObjId += 1
        
        pages = Pages(id:pagesId)
        structure[pagesId] = pages

        page = Page(id: currObjId, parent: pages!,
            contents: contents1!, procset: procset!,
            fonts: fonts, xobjects: xobjs, max: pageMax)
        pages?.kids.append(page)
        structure[currObjId] = page
        currObjId += 1
        
        catalog = Catalog(id: 1, /*outline: outline!, */pages: pages!)
        structure[1] = catalog

        //----------------------------------------------------------
        // Draw TAS Form 6.
        pageContent += "%-----------------------------------------------\n"
        pageContent += "% Draw TAS Form 6.\n"
        pageContent += "%-----------------------------------------------\n"
        //----------------------------------------------------------
        // draw box around map
        pageContent += "4 w \(pageMargin.bl.s) \(mapBoxSize.s) re S\n"
        let innerBoxBL = pageMargin.bl + mapBoxMargin.bl - CoordPair(x: 3, y: 3)
        let innerBoxSzX = mapBoxSize.x + 5 - (mapBoxMargin.tr.x + mapBoxMargin.bl.x)
        let innerBoxSzY = mapBoxSize.y + 6 - (mapBoxMargin.tr.y + mapBoxMargin.bl.y) - 39
        pageContent += "\(innerBoxBL.s) \(innerBoxSzX) \(innerBoxSzY) re S\n"
        pageContent += "\(pageMargin.bl.x) \(pageMargin.bl.y + mapBoxSize.y - 39) m \(pageMargin.bl.x + mapBoxSize.x) \(pageMargin.bl.y + mapBoxSize.y - 39) l S\n"
        // draw labels on map form
        pageContent += "BT /\(fontId2) \(headingPts) Tf \(pageMargin.bl.x) \(pageMargin.bl.y - 12) Td (TAS Form 6)Tj ET\n"

        let lbl1 = "Subsector Map Grid"
        let w = strWidth(lbl1, fontName: fontName2, fontSize: headingPts)
        pageContent += "BT /\(fontId2) \(headingPts) Tf \((pageMargin.bl.x + mapBoxSize.x - w).f1()) \(pageMargin.bl.y - headingPts) Td (\(lbl1))Tj ET\n"
        pageContent += "BT /\(fontId2) \(headingPts) Tf \(pageMargin.bl.x + 6) \(pageMax.y - pageMargin.tr.y - 33) Td  (SUBSECTOR MAP GRID)Tj ET\n"
        pageContent += "BT /\(fontId1) \(textPts) Tf 200 \(pageMax.y - pageMargin.tr.y - textPts * 1.5) Td  (1. Subsector Name)Tj ET\n"

        // draw hexagons in map
        pageContent += "1 w\n"
        pageContent += "190 \(pageMargin.bl.y + mapBoxSize.y) m 190 \(pageMargin.bl.y + mapBoxSize.y - 39) l S\n"
        pageContent += "340 \(pageMargin.bl.y + mapBoxSize.y) m 340 \(pageMargin.bl.y + mapBoxSize.y - 39) l S\n"
        pageContent += "0.5 g 0.5 G\n"

        for x in 1 ... 8 {
            for y in 1 ... 10 {
                let c:CoordPair = hexLocToCoord(x, y: y)
                let s:String = String(format:"%02d%02d",arguments:[x,y])
                pageContent += hex(c.x, y:c.y, height:hexHeight, label: s)
            }
        }
        pageContent += "0.0 g 0.0 G\n"
        pageContent += "%-----------------------------------------------\n"
       
        pageContent += "q 1 0 0 1 \(pageMargin.bl.x * 2 + 364 + pageMargin.tr.x) \(pageMargin.bl.y) cm /\(xobjTASForm7) Do Q\n"
    }
    
    func display(planet: Planet) {
        if line > 17 {
            listPage += 1
            
            switch(listPage) {
            case 3:
                page2Content += "q 1 0 0 1 \(pageMargin.bl.x * 2 + 364 + pageMargin.tr.x) \(pageMargin.bl.y) cm /\(xobjTASForm7) Do Q\n"
                
            case 2:
                page2Content += "q 1 0 0 1 \(pageMargin.bl.s) cm /\(xobjTASForm7) Do Q\n"
            case 5:
                page3Content += "q 1 0 0 1 \(pageMargin.bl.x * 2 + 364 + pageMargin.tr.x) \(pageMargin.bl.y) cm /\(xobjTASForm7) Do Q\n"
            case 4:
                page3Content += "q 1 0 0 1 \(pageMargin.bl.s) cm /\(xobjTASForm7) Do Q\n"
            default: break
            }
            
            line = 0
            if listPage % 2 == 0 {
                let contents = Contents(id:currObjId)
                structure[currObjId] = contents
                currObjId += 1
                
                let page = Page(id: currObjId, parent: pages!,
                                contents: contents, procset: procset!,
                                fonts: fonts, xobjects: xobjs, max: pageMax)
                pages?.kids.append(page)
                structure[currObjId] = page
                currObjId += 1
            }
        }
        var p: String = ""
        p += "% Rendering \(planet.description) to list\n"
        let c:CoordPair = listCoords(planet.coordinateX, y:planet.coordinateY)
        p += "BT /\(fontId1) \(listPts) Tf \(c.s) Td (\(planet.name))Tj 104 0 Td "
        let ins = 12.0
        p += String(format:"5.5 Tc (%02d%02d)Tj 0 Tc 60 0 Td (%@)Tj \(ins) 0 Td (%1X)Tj \(ins) 0 Td (%1X)Tj \(ins) 0 Td (%1X)Tj \(ins) 0 Td (%1X)Tj \(ins) 0 Td (%1X)Tj \(ins) 0 Td(%1X)Tj \(ins) 0 Td (%1X)Tj \(ins) 0 Td ",
            arguments:[planet.coordinateX, planet.coordinateY, planet.starport,
                planet.size, planet.atmosphere,
                planet.hydrographics, planet.population,
                planet.government, planet.lawLevel,
                planet.technologicalLevel])
        p += "6 5.5 Td 90 Tz ("
        p += planet.gasGiant ? "G " : ""
        p += planet.navalBase ? "N " : ""
        p += planet.scoutBase ? "S " : ""
        p += ")Tj "
        p += "0 -11 Td ("
        p += planet.shortTradeClassifications
        p += ")Tj 100 Tz\n"
        p += "ET\n"
        switch(listPage) {
            case 1: pageContent += p
            case 2, 3: page2Content += p
            default: page3Content += p
        }

        line = line + 1
        
        pageContent += "% Rendering \(planet.description) to map\n"
        let c1:CoordPair = hexLocToCoord(planet.coordinateX,y:planet.coordinateY)
        var w:Double = strWidth(planet.starport, fontName: fontName1, fontSize: namePts)
        pageContent += "BT /\(fontId1) \(namePts) Tf \((c1.x - w / 2).f1()) \(c1.y + 5) Td (\(planet.starport))Tj ET\n"
        let dispName = planet.population >= 9 ? planet.name!.uppercaseString : planet.name
        w = strWidth(dispName!, fontName: fontName1, fontSize: namePts * 0.75)
        pageContent += "BT /\(fontId1) \(namePts) Tf \((c1.x - w / 2).f1()) \(c1.y - 6.0 - namePts) Td 75 Tz (\(dispName))Tj 100 Tz ET\n"
        if planet.size == 0 {
            pageContent += asteroids(c1.x, y: c1.y, size: asteroidsSize)
        } else {
            pageContent += "q 1 0 0 1 \(c1.s) cm "
            if planet.hydrographics > 0 {
                pageContent += "/\(xobjPlanetDry)"
            } else {
                pageContent += "/\(xobjPlanetWet)"
            }
            pageContent +=  " Do Q\n"
        }
        if planet.gasGiant {
            pageContent += "q 1 0 0 1 \((c1 + CoordPair(x:10,y:10)).s) cm /\(xobjGasGiant) Do Q\n"
        }
        if planet.navalBase {
            pageContent += "q 1 0 0 1 \((c1 - CoordPair(x:10,y:0)).s) cm /\(xobjNavalBase) Do Q\n"
        }
        if planet.scoutBase {
            pageContent += "q 1 0 0 1 \((c1 + CoordPair(x:-10, y:10)).s) cm /\(xobjScoutBase) Do Q\n"
        }
    }
    
    func end() {
        // finish contents objects first
        contents1?.body += "<< /Length \(pageContent.characters.count)\n >>\nstream\n"
        contents1?.body += pageContent
        contents1?.body += "\nendstream\n"
        
        if pages!.kids.count > 1 {
            pages!.kids[1]?.contents?.body += "<< /Length \(page2Content.characters.count)\n >>\nstream\n"
            pages!.kids[1]?.contents?.body += page2Content
            pages!.kids[1]?.contents?.body += "\nendstream\n"
        }
        if pages!.kids.count > 2 {
            pages!.kids[2]?.contents?.body += "<< /Length \(page3Content.characters.count)\n >>\nstream\n"
            pages!.kids[2]?.contents?.body += page3Content
            pages!.kids[2]?.contents?.body += "\nendstream\n"
        }
        
        let structure1 = structure.sort({$0.0 < $1.0})
        
        let pdfHdr = "%PDF-1.4\n%\u{8f}\u{8f}\n"
        pdfContent += pdfHdr
        
        var offset:Int = pdfHdr.characters.count + 2
        var xref : String = "xref\n0 \(structure1.count + 1)\n0000000000 65535 f \n"
        for (_, m) in structure1 {
            xref += "\(leftPad(offset)) 00000 n \n"
            pdfContent += m.content
            offset += m.content.characters.count
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
