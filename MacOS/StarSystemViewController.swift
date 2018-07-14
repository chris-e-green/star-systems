//
//  StarSystemViewController.swift
//  StarSystemsGUI
//
//  Created by Christopher Green on 13/11/17.
//  Copyright © 2017 Christopher Green. All rights reserved.
//
//  The Traveller game in all forms is owned by Far Future Enterprises.
//  Copyright 1977 - 2008 Far Future Enterprises.
//

import Cocoa

class StarSystemSplitViewController: NSSplitViewController {
    var msgController: StarSystemMsgViewController?
    var ssController: StarSystemViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in self.splitViewItems {
            if i.viewController is StarSystemMsgViewController {
                msgController = i.viewController as? StarSystemMsgViewController
            }
            if i.viewController is StarSystemViewController {
                ssController = i.viewController as? StarSystemViewController
            }
        }
        ssController?.msgView = msgController
        msgController?.setMsg(to: "Hello there.")
    }
    
    func setMsg(to msg: String) {
        msgController?.setMsg(to: msg)
    }
}

class StarSystemMsgViewController:
NSViewController {
    @IBOutlet var details: NSTextView!
    func setMsg(to msg: String) {
        details.textStorage?.mutableString.setString(msg)
    }
}

class StarSystemViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {

    @IBOutlet weak var outline: NSOutlineView!
    var msgView: StarSystemMsgViewController?
    var starSystem:StarSystem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if starSystem == nil {
            starSystem = StarSystem()
        }
        outline.columnAutoresizingStyle = .sequentialColumnAutoresizingStyle
        outline.autoresizesOutlineColumn = true
        outline.expandItem(nil, expandChildren: true)
        outline.sizeToFit()
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        if let outline = notification.object as? NSOutlineView {
            let i = outline.item(atRow:outline.selectedRow)

            if let planet = i as? Planet {
                msgView?.setMsg(to: planet.verboseDesc)
            } else if let star = i as? Star {
                msgView?.setMsg(to: star.verboseDesc)
            } else if let gg = i as? GasGiant {
                msgView?.setMsg(to: gg.verboseDesc)
            } else if (i as? EmptyOrbit) != nil {
                msgView?.setMsg(to: "This is an empty orbit.")
            }
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let satellite = item as? Satellite {
            return satellite.satellites.byIndex(index)!
        } else {
            return starSystem!.primary
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return (item as! Satellite).satellites.count > 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        var result: Int
        if let s = item as? Satellite {
            result = s.satellites.count
        } else if item == nil {
            result = 1
        } else {
            result = 0
        }
        return result
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        
        var result: NSCell?
        let s = item as! Satellite?
        switch tableColumn!.title {
        case "Orbit": result = NSCell(textCell:"\(s!.orbit)")
        case "Name":
            if let empty = item as? EmptyOrbit {
                result = NSCell(textCell:"\(empty)")
            } else {
                result = NSCell(textCell:s!.name)
            }
        case "UPP":
            if let planet = item as? Planet {
                result = NSCell(textCell:"\(planet.uwp) \(planet.baseStr)")
            }
            if let star = item as? Star {
                result = NSCell(textCell:star.specSize)
            }
            if (item as? EmptyOrbit) != nil {
                result = NSCell(textCell:"")
            }
            if let gg = item as? GasGiant {
                result = NSCell(textCell:"\(gg.size)")
            }
        case "Remarks":
            if let planet = item as? Planet {
                var remarks = ""
                if !planet.facilitiesStr.isEmpty { remarks += "\(planet.facilitiesStr). "}
                remarks += "\(planet.longTradeClassifications)"
                result = NSCell(textCell:remarks)
            } else if let star = item as? Star {
                result = NSCell(textCell:star.specSizeDescription)
            }
            else {
                result = NSCell(textCell:"")
            }
        default:
            result = NSCell(textCell:"")
        }
        return result
    }
}

