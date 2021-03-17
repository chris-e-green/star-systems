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
        for splitViewItem in splitViewItems {
            if splitViewItem.viewController is StarSystemMsgViewController {
                msgController = splitViewItem.viewController as? StarSystemMsgViewController
            }
            if splitViewItem.viewController is StarSystemViewController {
                ssController = splitViewItem.viewController as? StarSystemViewController
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
    var starSystem: StarSystem?

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
            let selectedItem = outline.item(atRow: outline.selectedRow)

            if let planet = selectedItem as? Planet {
                msgView?.setMsg(to: planet.verboseDesc)
            } else if let star = selectedItem as? Star {
                msgView?.setMsg(to: star.verboseDesc)
            } else if let gasGiant = selectedItem as? GasGiant {
                msgView?.setMsg(to: gasGiant.verboseDesc)
            } else if (selectedItem as? EmptyOrbit) != nil {
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
        if let item = item as? Satellite {
            return item.satellites.count > 0
        } else {
            return false
        }
//        return (item as! Satellite).satellites.count > 0
    }

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        var result: Int
        if let satellite = item as? Satellite {
            result = satellite.satellites.count
        } else if item == nil {
            result = 1
        } else {
            result = 0
        }
        return result
    }

    func outlineView(_ outlineView: NSOutlineView,
                     objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {

        var result: NSCell?
        let satellite = item as? Satellite
        switch tableColumn!.title {
        case "Orbit": result = NSCell(textCell: "\(satellite!.orbit)")
        case "Name":
            if let empty = item as? EmptyOrbit {
                result = NSCell(textCell: "\(empty)")
            } else {
                result = NSCell(textCell: satellite!.name)
            }
        case "UPP":
            if let planet = item as? Planet {
                result = NSCell(textCell: "\(planet.uwp) \(planet.baseStr)")
            } else if let star = item as? Star {
                result = NSCell(textCell: star.specSize)
            } else if (item as? EmptyOrbit) != nil {
                result = NSCell(textCell: "")
            } else if let gasGiant = item as? GasGiant {
                result = NSCell(textCell: "\(gasGiant.size)")
            }
        case "Remarks":
            if let planet = item as? Planet {
                var remarks = ""
                if !planet.facilitiesStr.isEmpty { remarks += "\(planet.facilitiesStr). "}
                remarks += "\(planet.longTradeClassifications)"
                result = NSCell(textCell: remarks)
            } else if let star = item as? Star {
                result = NSCell(textCell: star.specSizeDescription)
            } else {
                result = NSCell(textCell: "")
            }
        default:
            result = NSCell(textCell: "")
        }
        return result
    }
}
