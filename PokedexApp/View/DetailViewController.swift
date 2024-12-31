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
    
    private let rect: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkRed
        view.layer.cornerRadius = 10
        return view
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private var idNameLabel: UILabel = {
        let label = UILabel()
        label.text = "No. 이름"
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        return label
    }()
    
    private var typeLabel: UILabel = {
        let label = UILabel()
        label.text = "타입: "
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private var heightLabel: UILabel = {
        let label = UILabel()
        label.text = "키: "
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private var weightLabel: UILabel = {
        let label = UILabel()
        label.text = "몸무게: "
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainRed
        bind()
        configureUI()
    }
    
    private func bind() {//포켓몬 정보 가져오기
        viewModel.pokemonInfoSubject.observe(on: MainScheduler()).subscribe(onNext: { pokemonInfo in
            
            self.configureImageView(id: self.id)//포켓몬 이미지
            self.idNameLabel.text = "No." + String(pokemonInfo.id) + " " + pokemonInfo.name//번호, 이름
            
            if let type = pokemonInfo.types.first?.type.name {//타입
                self.typeLabel.text = "타입: " + type
            }
            
            //키, 몸무게 - 단위 : 몸무게(그램), 키(데시미터. 1/10m = 10cm)
            self.heightLabel.text = "키: " + String(Double(pokemonInfo.height) / 10) + " m"
            self.weightLabel.text = "몸무게: " + String(Double(pokemonInfo.weight) / 10) + " kg"
            
        }, onError: { error in
            print("에러 발생: \(error)")
        }).disposed(by: disposeBag)
    }
    
    private func configureImageView(id: Int) {
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        guard let url = URL(string: urlString) else { return }
        
        //백그라운드에서 데이터 변환 작업
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    
                    //UI는 메인 쓰레드에서 작업
                    DispatchQueue.main.sync {
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.mainRed
        view.addSubview(rect)
        
        [imageView, idNameLabel, typeLabel, heightLabel, weightLabel]
            .forEach { rect.addSubview($0) }
        
        [idNameLabel, typeLabel, heightLabel, weightLabel]
            .forEach { $0.textColor = .white }
        
        rect.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(300)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges).inset(30)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(rect.snp.top).inset(20)
            $0.centerX.equalTo(rect)
            $0.width.equalTo(200)
            $0.height.equalTo(200)
        }
        
        idNameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.centerX.equalTo(rect)
            $0.height.equalTo(50)
        }
        
        typeLabel.snp.makeConstraints {
            $0.top.equalTo(idNameLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        heightLabel.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        weightLabel.snp.makeConstraints {
            $0.top.equalTo(heightLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
    
}
