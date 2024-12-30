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
    let sprites: Sprites
    let types: [TypeElement]
    let weight, height: Int
}

// MARK: - Species
struct Species: Codable {
    let name: String
    let url: String
}

// MARK: - Sprites
class Sprites: Codable {
    let frontDefault: String
    let frontShiny: String
    let animated: Sprites?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case animated
    }

    init(frontDefault: String, frontShiny: String, animated: Sprites?) {
        self.frontDefault = frontDefault
        self.frontShiny = frontShiny
        self.animated = animated
    }
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let slot: Int
    let type: Species
}
