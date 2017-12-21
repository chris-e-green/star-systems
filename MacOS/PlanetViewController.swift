//
//  PlanetViewController.swift
//  StarSystemsGUI
//
//  Created by Christopher Green on 12/9/17.
//  Copyright © 2017 Christopher Green. All rights reserved.
//

import Cocoa

class PlanetViewController: NSViewController {
    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var starport: NSTextField!
    @IBOutlet weak var size: NSTextField!
    @IBOutlet weak var hydrographics: NSTextField!
    @IBOutlet weak var population: NSTextField!
    @IBOutlet weak var government: NSTextField!
    @IBOutlet weak var atmosphere: NSTextField!
    @IBOutlet weak var lawLevel: NSTextField!
    @IBOutlet weak var techLevel: NSTextField!
    
    @IBOutlet weak var bases: NSTextField!
    @IBOutlet var planetDescription: NSTextView!
    @IBOutlet weak var tradeClass: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let planet = Planet()
        planet.generateRandomPlanet()
        name.stringValue = planet.name
        starport.stringValue = planet.starport
        size.stringValue = planet.size
        atmosphere.stringValue = planet.atmosphere
        hydrographics.stringValue = planet.hydrographics
        population.stringValue = planet.population
        government.stringValue = planet.government
        lawLevel.stringValue = planet.lawLevel
        techLevel.stringValue = planet.technologicalLevel
        planetDescription.textStorage?.mutableString.setString(planet.fullDescription)
        bases.stringValue = planet.baseStr
        tradeClass.stringValue = planet.shortTradeClassifications
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

