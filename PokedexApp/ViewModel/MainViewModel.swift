//
//  MainViewModel.swift
//  PokedexApp
//
//  Created by 2023-m0072 on 12/27/24.
//

import Foundation
import RxSwift

class MainViewModel {
    
    private let disposeBag = DisposeBag()

    //Subject(Observable + Observer) 선언 & 초기값 생성
    let pokemonSubject = BehaviorSubject(value: [Pokemon]())
    
    init() {
        fetchPokemon()
    }
    
    //포켓몬 이미지 fetch
    func fetchPokemon() {
                
        //URL 생성
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0") else {
            pokemonSubject.onError(NetworkError.invalidUrl)
            return
        }
        
        //NetworkManager 구독
        NetworkManager.shared.fetch(url: url).subscribe(onSuccess: { [weak self] (pokemonResponse: PokemonResponse) in
            //정상적인 값이 방출된 경우
            self?.pokemonSubject.onNext(pokemonResponse.results)
        }, onFailure: { [weak self] error in
            //오류가 방출된 경우
            self?.pokemonSubject.onError(error)
        }).disposed(by: disposeBag)
    }
}
