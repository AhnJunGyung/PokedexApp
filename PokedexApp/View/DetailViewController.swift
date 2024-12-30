//
//  DetailViewController.swift
//  PokedexApp
//
//  Created by t2023-m0072 on 12/30/24.
//

import UIKit
import SnapKit
import RxSwift

class DetailViewController: UIViewController {

    private let id: Int

    private lazy var viewModel = DetailViewModel(with: id)
    private let disposeBag = DisposeBag()
    private var pokemonInfo: PokemonInfo?
    
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainRed
        
        bind()
        configureUI()
    }
    
    private func bind() {
        
    }
    
    private func configureUI() {

    }
    
}
