//
//  DetailViewController.swift
//  StarSystemsiOS
//
//  Created by Christopher Green on 17/9/17.
//  Copyright © 2017 Christopher Green. All rights reserved.
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
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
        }
        if let planet = detailPlanet {
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
    var detailPlanet: Planet? {
        didSet {
            configureView()
        }
    }
    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

