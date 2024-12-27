//
//  PokemonInfo.swift
//  PokedexApp
//
//  Created by t2023-m0072 on 12/27/24.
//

import Foundation

struct PokemonInfoResponse: Codable {
    let results: [PokemonInfo]
}

struct PokemonInfo: Codable {
        let id: Int?
        let name: String?
        let types: String?
        let height: Int?
        let weight: Int?
}
