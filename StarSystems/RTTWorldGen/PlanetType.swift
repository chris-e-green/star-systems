//
// Created by Christopher Green on 16/06/2016.
// Copyright (c) 2016 Christopher Green. All rights reserved.
//

import Foundation

enum PlanetType: Int, CustomStringConvertible {
    case Acheronian, Arean, Arid, Asphodelian, AsteroidBelt, Chthonian, Dwarf
    case Hebean, Helian, JaniLithic, Jovian, Meltball, Oceanic, Panthalassic
    case Promethean, Rockball, SmallBody, Snowball, Stygian, Tectonic
    case Telluric, Terrestrial, Vesperian, Star
    var longDescription: String {
        switch self {
        case Acheronian: return "These are worlds that were directly affected by their primary's transition from the main sequence; the atmosphere and oceans have been boiled away, leaving a scorched, dead planet."
        case Arean: return "These are worlds with little liquid, that move through a slow geological cycle of a gradual build-up, a short wet and clement period, and a long decline."
        case Arid: return "These are worlds with limited amounts of surface liquid, that maintain an equilibrium with the help of their tectonic activity and their biosphere."
        case Asphodelian: return "These are worlds that were directly affected by their primary's transition from the main sequence; their atmosphere has been boiled away, leaving the surface exposed."
        case Chthonian: return "These are worlds that were directly affected by their primary's transition from the main sequence, or that have simply spent too long in a tight epistellar orbit; their atmospheres have been stripped away."
        case Hebean: return "These are highly active worlds, due to tidal flexing, but with some regions of stability; the larger ones may be able to maintain some atmosphere and surface liquid."
        case Helian: return "These are typical helian or \"subgiant\" worlds – large enough to retain helium atmospheres."
        case JaniLithic: return "These worlds, tide-locked to the primary, are rocky, dry, and geologically active."
        case Jovian: return "These are huge worlds with helium-hydrogen envelopes and compressed cores; the largest emit more heat than they absorb."
        case Meltball: return "These are dwarfs with molten or semi-molten surfaces, either from extreme tidal flexing, or extreme approach to a star."
        case Oceanic: return "These are worlds with a continuous hydrological cycle and deep oceans, due to either dense greenhouse atmosphere or active plate tectonics."
        case Panthalassic: return "These are massive worlds, aborted gas giants, largely composed of water and hydrogen."
        case Promethean: return "These are worlds that, through tidal-flexing, have a geological cycle similar to plate tectonics, that supports surface liquid and atmosphere."
        case Rockball: return "These are mostly dormant worlds, with surfaces largely unchanged since the early period of planetary formation."
        case SmallBody: return "These are bodies too small to sustain hydrostatic equilibrium; nearly all asteroids and comets are small bodies."
        case Snowball: return "These worlds are composed of mostly ice and some rock. They may have varying degrees of activity, ranging from completely cold and still to cryo-volcanically active with extensive subsurface oceans."
        case Stygian: return "These are worlds that were directly affected by their primary's transition from the main sequence; they are melted and blasted lumps."
        case Tectonic: return "These are worlds with active plate tectonics and large bodies of surface liquid, allowing for stable atmospheres and a high likelihood of life."
        case Telluric: return "These are worlds with geoactivity but no hydrological cycle at all, leading to dense runaway-greenhouse atmospheres."
        case Vesperian: return "These worlds are tide-locked to their primary, but at a distance that permits surface liquid and the development of life."
        default: return shortDescription
        }
    }
    var shortDescription: String {
        switch self {
        case Acheronian: return "Terrestrial Group, Telluric Class, Acheronian Type"
        case Arean: return "Dwarf Group, GeoCyclic Class, Arean / Utgardian / Titanian Types"
        case Arid: return "Terrestrial Group, Arid Class, Darwinian / Saganian / Asimovian Types"
        case Asphodelian: return "Helian Group, GeoHelian Class, Asphodelian Type"
        case AsteroidBelt: return "Asteroid Belt"
        case Chthonian: return "Jovian Group, Chthonian Class"
        case Dwarf: return "Dwarf Planet"
        case Hebean: return "Dwarf Group, GeoTidal Class, Hebean / Idunnian Types"
        case Helian: return "Helian Group, GeoHelian / Nebulous Classes"
        case JaniLithic: return "Terrestrial Group, Epistellar Class, JaniLithic Type"
        case Jovian: return "Jovian Planet"
        case Meltball: return "Dwarf Group, GeoThermic Class, Phaethonic / Apollonian / Sethian Types, or GeoTidal Class, Hephaestian / Lokian Types"
        case Oceanic: return "Terrestrial Group, Oceanic Class, Pelagic / Nunnic / Teathic Types, or Tectonic Class, BathyGaian / BathyAmunian / BathyTartarian Types"
        case Panthalassic: return "Helian Group, Panthalassic Class"
        case Promethean: return "Dwarf Group, GeoTidal Class, Promethean / Burian / Atlan Types"
        case Rockball: return "Dwarf Group, GeoPassive Class, Ferrinian / Lithic / Carbonian Types"
        case SmallBody: return "Small Body Group"
        case Snowball: return "Dwarf Group, GeoPassive Class, Gelidian Type, or GeoThermic Class, Erisian Type, or GeoTidal Class, Plutonian Type."
        case Stygian: return "Dwarf Group, GeoPassive Class, Stygian Type"
        case Tectonic: return "Terrestrial Group, Tectonic Class, Gaian / Amunian / Tartarian Types"
        case Telluric: return "Terrestrial Group, Telluric Class, Phosphorian / Cytherean Types"
        case Terrestrial: return "Terrestrial Planet"
        case Vesperian: return "Dwarf Group, Epistellar Class, Vesperian Type"
        case Star: return "Star"
        }
    }
    var description: String {
        switch self {
        case Acheronian: return "Acheronian Planet"
        case Arean: return "Arean Planet"
        case Arid: return "Arid Planet"
        case Asphodelian: return "Asphodelian Planet"
        case AsteroidBelt: return "Asteroid Belt"
        case Chthonian: return "Chthonian Planet"
        case Dwarf: return "Dwarf Planet"
        case Hebean: return "Hebean Planet"
        case Helian: return "Helian Planet"
        case JaniLithic: return "JaniLithic Planet"
        case Jovian: return "Jovian Planet"
        case Meltball: return "Meltball"
        case Oceanic: return "Oceanic Planet"
        case Panthalassic: return "Panthalassic Planet"
        case Promethean: return "Promethean Planet"
        case Rockball: return "Rockball"
        case SmallBody: return "Small Bodies"
        case Snowball: return "Snowball"
        case Stygian: return "Stygian Planet"
        case Tectonic: return "Tectonic Planet"
        case Telluric: return "Telluric Planet"
        case Terrestrial: return "Terrestrial Planet"
        case Vesperian: return "Vesperian Planet"
        case Star: return "Star"
        }
    }
}
