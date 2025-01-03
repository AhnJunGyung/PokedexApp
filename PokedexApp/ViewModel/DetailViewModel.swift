//
//  DetailViewModel.swift
//  PokedexApp
//
//  Created by t2023-m0072 on 12/30/24.
//

import Foundation
import UIKit
import RxSwift

class DetailViewModel {
    
    private let id: String//포켓몬 id
    private let disposeBag = DisposeBag()
    
    // PublishSubject 선언
    let pokemonInfoSubject = PublishSubject<PokemonDetailInfo>()
    
    init(id: String) {
        self.id = id
        fetchPokemonInfo(id)
    }
    
    //포켓몬 정보 fetch
    func fetchPokemonInfo(_ id: String) {

        //URL 세팅
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)/") else {
            pokemonInfoSubject.onError(NetworkError.invalidUrl)
            return
        }
        
        NetworkManager.shared.fetch(url: url).subscribe(onSuccess: { [weak self] (pokemonInfo: PokemonDetailInfo) in
            //정상 방출
            self?.pokemonInfoSubject.onNext(pokemonInfo)
        }, onFailure: { [weak self] error in
            //오류 방출
            self?.pokemonInfoSubject.onError(error)
        }).disposed(by: disposeBag)
    }
    
}
