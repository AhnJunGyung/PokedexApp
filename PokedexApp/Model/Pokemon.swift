//
//  Pokemon.swift
//  PokedexApp
//
//  Created by t2023-m0072 on 12/27/24.
//

import Foundation

struct PokemonResponse: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name: String?
    let url: String?
}
