//
//  ViewController.swift
//  StarSystemsGUI
//
//  Created by Christopher Green on 3/8/17.
//  Copyright © 2017 Christopher Green. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var infoTextField: NSTextField!
    @IBOutlet var infoTextView: NSTextView!
    @IBAction func makePlanet(_ sender: NSButton) {
        let planet = Planet()
        planet.generateRandomPlanet()
        infoTextView.textStorage?.mutableString.setString(planet.description)
    }
    @IBAction func makeSubsector(_ sender: NSButton) {
        let subsector: Subsector = Subsector(density: 3, withStarSystems: true)
        infoTextView.textStorage?.mutableString.setString(subsector.description)
        
    }
    @IBAction func makeStar(_ sender: NSButton) {
        let starsystem : StarSystem = StarSystem()
        infoTextView.textStorage?.mutableString.setString(starsystem.description)
//        for star in starsystem.stars {
//            infoTextView.textStorage?.mutableString.append(star.description)
//        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

