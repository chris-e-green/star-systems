//
//  DetailViewController.swift
//  StarSystemsiOS
//
//  Created by Christopher Green on 17/9/17.
//  Copyright © 2017 Christopher Green. All rights reserved.
//
//  The Traveller game in all forms is owned by Far Future Enterprises.
//  Copyright 1977 - 2008 Far Future Enterprises.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var planetNameField: UITextField!
    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var starportField: UITextField!
    
    @IBOutlet weak var atmosphereField: UITextField!
    @IBOutlet weak var sizeField: UITextField!
    @IBOutlet weak var hydrographicsField: UITextField!
    @IBOutlet weak var populationField: UITextField!
    @IBOutlet weak var governmentField: UITextField!
    @IBOutlet weak var lawLevelField: UITextField!
    @IBOutlet weak var techLevelField: UITextField!
    @IBOutlet weak var basesField: UITextField!
    @IBOutlet weak var tradeClassField: UITextField!
    func configureView() {
        // Update the user interface for the detail item.

        if let planet = detailItem {
            if let planetname = planetNameField {
                planetname.text = planet.name
            }
            if let tradeclass = tradeClassField {
                tradeclass.text = planet.shortTradeClassifications
            }
            if let bases = basesField {
                bases.text = planet.baseStr
            }
            if let starport = starportField {
                starport.text = planet.starport
            }
            if let atmosphere = atmosphereField {
                atmosphere.text = planet.atmosphere
            }
            if let size = sizeField {
                size.text = planet.size
            }
            if let hydrographics = hydrographicsField {
                hydrographics.text = planet.hydrographics
            }
            if let population = populationField {
                population.text = planet.population
            }
            if let government = governmentField {
                government.text = planet.government
            }
            if let lawLevel = lawLevelField {
                lawLevel.text = planet.lawLevel
            }
            if let techLevel = techLevelField {
                techLevel.text = planet.technologicalLevel
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var detailItem: Planet? {
        didSet {
            configureView()
        }
    }
}

