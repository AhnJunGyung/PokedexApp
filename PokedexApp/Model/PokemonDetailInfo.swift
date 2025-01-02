//
//  PokemonInfo.swift
//  PokedexApp
//
//  Created by t2023-m0072 on 12/27/24.
//

import Foundation

struct PokemonDetailInfo: Codable {
    let id: Int
    let name: String
    let species: Species
    let types: [TypeElement]
    let weight, height: Int
}

struct Species: Codable {
    let name: String
    let url: String
}

struct TypeElement: Codable {
    let slot: Int
    let type: Species
}
