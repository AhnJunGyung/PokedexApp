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
    
    var id: String {
        //url에서 포켓몬 id에 해당하는 부분 추출
        guard let pokemonUrl = url else { return "" }
        let urlSplit = pokemonUrl.split(separator: "/")
        
        return String(urlSplit[5])
    }
}
