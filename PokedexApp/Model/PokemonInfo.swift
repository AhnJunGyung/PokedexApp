//
//  PokemonInfo.swift
//  PokedexApp
//
//  Created by t2023-m0072 on 12/27/24.
//

import Foundation

// MARK: - PokemonInfo
struct PokemonInfo: Codable {
    let id: Int
    let name: String
    let species: Species
    let types: [TypeElement]
    let weight, height: Int
}

// MARK: - Species
struct Species: Codable {
    let name: String
    let url: String
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let slot: Int
    let type: Species
}
