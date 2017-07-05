//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation

enum PlanetType: Int, CustomStringConvertible {
    case acheronian, arean, arid, asphodelian, asteroidBelt, chthonian, dwarf
    case hebean, helian, janiLithic, jovian, meltball, oceanic, panthalassic
    case promethean, rockball, smallBody, snowball, stygian, tectonic
    case telluric, terrestrial, vesperian, star
    var longDescription: String {
        switch self {
        case .acheronian: return "These are worlds that were directly affected by their primary's transition from the main sequence; the atmosphere and oceans have been boiled away, leaving a scorched, dead planet."
        case .arean: return "These are worlds with little liquid, that move through a slow geological cycle of a gradual build-up, a short wet and clement period, and a long decline."
        case .arid: return "These are worlds with limited amounts of surface liquid, that maintain an equilibrium with the help of their tectonic activity and their biosphere."
        case .asphodelian: return "These are worlds that were directly affected by their primary's transition from the main sequence; their atmosphere has been boiled away, leaving the surface exposed."
        case .chthonian: return "These are worlds that were directly affected by their primary's transition from the main sequence, or that have simply spent too long in a tight epistellar orbit; their atmospheres have been stripped away."
        case .hebean: return "These are highly active worlds, due to tidal flexing, but with some regions of stability; the larger ones may be able to maintain some atmosphere and surface liquid."
        case .helian: return "These are typical helian or \"subgiant\" worlds – large enough to retain helium atmospheres."
        case .janiLithic: return "These worlds, tide-locked to the primary, are rocky, dry, and geologically active."
        case .jovian: return "These are huge worlds with helium-hydrogen envelopes and compressed cores; the largest emit more heat than they absorb."
        case .meltball: return "These are dwarfs with molten or semi-molten surfaces, either from extreme tidal flexing, or extreme approach to a star."
        case .oceanic: return "These are worlds with a continuous hydrological cycle and deep oceans, due to either dense greenhouse atmosphere or active plate tectonics."
        case .panthalassic: return "These are massive worlds, aborted gas giants, largely composed of water and hydrogen."
        case .promethean: return "These are worlds that, through tidal-flexing, have a geological cycle similar to plate tectonics, that supports surface liquid and atmosphere."
        case .rockball: return "These are mostly dormant worlds, with surfaces largely unchanged since the early period of planetary formation."
        case .smallBody: return "These are bodies too small to sustain hydrostatic equilibrium; nearly all asteroids and comets are small bodies."
        case .snowball: return "These worlds are composed of mostly ice and some rock. They may have varying degrees of activity, ranging from completely cold and still to cryo-volcanically active with extensive subsurface oceans."
        case .stygian: return "These are worlds that were directly affected by their primary's transition from the main sequence; they are melted and blasted lumps."
        case .tectonic: return "These are worlds with active plate tectonics and large bodies of surface liquid, allowing for stable atmospheres and a high likelihood of life."
        case .telluric: return "These are worlds with geoactivity but no hydrological cycle at all, leading to dense runaway-greenhouse atmospheres."
        case .vesperian: return "These worlds are tide-locked to their primary, but at a distance that permits surface liquid and the development of life."
        default: return shortDescription
        }
    }
    var shortDescription: String {
        switch self {
        case .acheronian: return "Terrestrial Group, Telluric Class, Acheronian Type"
        case .arean: return "Dwarf Group, GeoCyclic Class, Arean / Utgardian / Titanian Types"
        case .arid: return "Terrestrial Group, Arid Class, Darwinian / Saganian / Asimovian Types"
        case .asphodelian: return "Helian Group, GeoHelian Class, Asphodelian Type"
        case .asteroidBelt: return "Asteroid Belt"
        case .chthonian: return "Jovian Group, Chthonian Class"
        case .dwarf: return "Dwarf Planet"
        case .hebean: return "Dwarf Group, GeoTidal Class, Hebean / Idunnian Types"
        case .helian: return "Helian Group, GeoHelian / Nebulous Classes"
        case .janiLithic: return "Terrestrial Group, Epistellar Class, JaniLithic Type"
        case .jovian: return "Jovian Planet"
        case .meltball: return "Dwarf Group, GeoThermic Class, Phaethonic / Apollonian / Sethian Types, or GeoTidal Class, Hephaestian / Lokian Types"
        case .oceanic: return "Terrestrial Group, Oceanic Class, Pelagic / Nunnic / Teathic Types, or Tectonic Class, BathyGaian / BathyAmunian / BathyTartarian Types"
        case .panthalassic: return "Helian Group, Panthalassic Class"
        case .promethean: return "Dwarf Group, GeoTidal Class, Promethean / Burian / Atlan Types"
        case .rockball: return "Dwarf Group, GeoPassive Class, Ferrinian / Lithic / Carbonian Types"
        case .smallBody: return "Small Body Group"
        case .snowball: return "Dwarf Group, GeoPassive Class, Gelidian Type, or GeoThermic Class, Erisian Type, or GeoTidal Class, Plutonian Type."
        case .stygian: return "Dwarf Group, GeoPassive Class, Stygian Type"
        case .tectonic: return "Terrestrial Group, Tectonic Class, Gaian / Amunian / Tartarian Types"
        case .telluric: return "Terrestrial Group, Telluric Class, Phosphorian / Cytherean Types"
        case .terrestrial: return "Terrestrial Planet"
        case .vesperian: return "Dwarf Group, Epistellar Class, Vesperian Type"
        case .star: return "Star"
        }
    }
    var description: String {
        switch self {
        case .acheronian: return "Acheronian Planet"
        case .arean: return "Arean Planet"
        case .arid: return "Arid Planet"
        case .asphodelian: return "Asphodelian Planet"
        case .asteroidBelt: return "Asteroid Belt"
        case .chthonian: return "Chthonian Planet"
        case .dwarf: return "Dwarf Planet"
        case .hebean: return "Hebean Planet"
        case .helian: return "Helian Planet"
        case .janiLithic: return "JaniLithic Planet"
        case .jovian: return "Jovian Planet"
        case .meltball: return "Meltball"
        case .oceanic: return "Oceanic Planet"
        case .panthalassic: return "Panthalassic Planet"
        case .promethean: return "Promethean Planet"
        case .rockball: return "Rockball"
        case .smallBody: return "Small Bodies"
        case .snowball: return "Snowball"
        case .stygian: return "Stygian Planet"
        case .tectonic: return "Tectonic Planet"
        case .telluric: return "Telluric Planet"
        case .terrestrial: return "Terrestrial Planet"
        case .vesperian: return "Vesperian Planet"
        case .star: return "Star"
        }
    }
}
