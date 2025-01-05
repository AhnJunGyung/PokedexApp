//
//  MainViewModel.swift
//  PokedexApp
//
//  Created by 2023-m0072 on 12/27/24.
//

import Foundation
import RxSwift
import Kingfisher
import RxCocoa

class MainViewModel {
    
    private let disposeBag = DisposeBag()
    private var offset = -20
    
    //BehaviorRelay는 onError, onCompleted 이벤트가 없다.
    //즉, 정상적인 방출은 모두 받을 수 있기 때문에 UI에 사용하기 적합.
    let pokemonRelay = BehaviorRelay(value: [Pokemon]())
    
    init() {
        fetchPokemon()
    }
    
    //포켓몬 이미지 fetch
    func fetchPokemon() {
        
        offset += 20
        
        //URL 생성
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20&offset=\(offset)") else {
            return
        }
        
        //NetworkManager 구독
        NetworkManager.shared.fetch(url: url).subscribe(onSuccess: { [weak self] (pokemonResponse: PokemonResponse) in
            self?.pokemonRelay.accept(pokemonResponse.results)
        }).disposed(by: disposeBag)
    }
}
