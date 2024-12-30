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
    
    private let id: Int
    private let disposeBag = DisposeBag()
    
    //PublishSubject 선언
    let pokemonInfoSubject = PublishSubject<PokemonInfo>()
    
    init(with id: Int) {
        self.id = id
        fetchPokemonInfo(id)
    }
    
    //포켓몬 상세정보 가져오기
    func fetchPokemonInfo(_ id: Int) {
        
        //URL 세팅
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)/") else {
            pokemonInfoSubject.onError(NetworkError.invalidUrl)
            return
        }
        
        NetworkManager.shared.fetch(url: url).subscribe(onSuccess: { [weak self] (pokemonInfo: PokemonInfo) in
            //정상 방출
            self?.pokemonInfoSubject.onNext(pokemonInfo)
        }, onFailure: { [weak self] error in
            //오류 방출
            self?.pokemonInfoSubject.onError(error)
        }).disposed(by: disposeBag)
    }
}
