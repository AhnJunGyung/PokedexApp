//
//  DetailViewModel.swift
//  PokedexApp
//
//  Created by t2023-m0072 on 12/30/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DetailViewModel {
    
    private let id: String//포켓몬 id
    private let disposeBag = DisposeBag()
    
    // PublishRelay 선언
    let pokemonInfoRelay = PublishRelay<PokemonDetailInfo>()
    
    init(id: String) {
        self.id = id
        fetchPokemonInfo(id)
    }
    
    //포켓몬 정보 fetch
    func fetchPokemonInfo(_ id: String) {

        //URL 세팅
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)/") else {
            return
        }
        
        NetworkManager.shared.fetch(url: url).subscribe(onSuccess: { [weak self] (pokemonInfo: PokemonDetailInfo) in
            //정상 방출
            self?.pokemonInfoRelay.accept(pokemonInfo)
        }).disposed(by: disposeBag)
    }
    
}
