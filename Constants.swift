//
//  Constants.swift
//  Pokedex3
//
//  Created by Hussein Ghoniam on 24/05/2017.
//  Copyright © 2017 Hussein Ghoniam. All rights reserved.
//

import Foundation
//globally available

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"

typealias DownloadComplete = () -> () //closure
//creatinga closure or a block of code, that is run at a later time
//pass this closure to pokemondetail function in Pokemon.swift
