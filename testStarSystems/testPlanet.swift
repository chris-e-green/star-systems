//
//  testPlanet.swift
//  StarSystems
//
//  Created by Christopher Green on 27/03/2016.
//  Copyright © 2016 Christopher Green. All rights reserved.
//

import XCTest
import StarSystems

class TestPlanet: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDescribePlanet() {
       let planet: Planet = Planet()
        planet.generateRandomPlanet(99, starType: .Z, zone: .Z)
       print(planet.fullDescription)
    }

    func testGeneratePlanet() {
        let planet = Planet()
        planet.generateRandomPlanet(99, starType: .Z, zone: .Z)
        print(planet)
    }

    func testPrecreatedPlanet() {
        let upp = "A123456-3"
        var planet = Planet(upp: upp, scoutBase: true, navalBase: true, gasGiant: true)
        XCTAssertNotEqual("A123456-3", planet.description)
        XCTAssertEqual("A123456-3 N S G", planet.description)
        planet = Planet(upp: upp, scoutBase: false, navalBase: false, gasGiant: false)
        XCTAssertEqual("A123456-3", planet.description)
        planet = Planet(upp: upp, scoutBase: false, navalBase: false, gasGiant: true)
        XCTAssertEqual("A123456-3 G", planet.description)
        planet = Planet(upp: upp, scoutBase: false, navalBase: true, gasGiant: false)
        XCTAssertEqual("A123456-3 N", planet.description)

    }
    func testGeneratePlanetPerformance() {
        // This is an example of a performance test case.
        let planet: Planet = Planet()
        self.measureBlock {
            // Put the code you want to measure the time of here.
            planet.generateRandomPlanet(99, starType: .Z, zone: .Z)
        }
    }

}
