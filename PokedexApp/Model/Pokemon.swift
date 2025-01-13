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

extension Pokemon {
    var id: String {
        //url에서 포켓몬 id에 해당하는 부분 추출
        guard let pokemonUrl = url else { return "" }
        
        let urlSplit = pokemonUrl.split(separator: "/")
        
        guard let id = urlSplit.safeElement(at: 5) else { return "" }
        
        return String(id)
    }
}

extension Array {
    //옵셔널 인덱스 접근을 위한 확장
    func safeElement(at index: Int) -> Element? {
        return (index >= 0 && index < count) ? self[index] : nil
    }
}
