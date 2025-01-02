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
    
    private let id: Int//포켓몬 id
    
    private lazy var viewModel = DetailViewModel(with: id)//뷰모델 객체 생성
    private let disposeBag = DisposeBag()
    private var pokemonInfo: PokemonDetailInfo?
    
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 생성
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
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        return label
    }()
    
    private var typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private var heightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private var weightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainRed
        bind()
        configureUI()
    }
    
    // MARK: - 포켓몬 정보 가져오기 & 세팅
    private func bind() {
        //UI작업 MainScheduler에서 작업
        viewModel.pokemonInfoSubject.observe(on: MainScheduler()).subscribe(onNext: { pokemonInfo in
            
            self.configureImageView(id: self.id)//포켓몬 이미지
            
            //번호, 이름(한국어 변환)
            self.idNameLabel.text = "No." + String(pokemonInfo.id) + " " + PokemonTranslator.getKoreanName(for: pokemonInfo.name)
            
            //타입(한국어 변환)
            if let type = pokemonInfo.types.first?.type.name {
                self.typeLabel.text = "타입: " + (PokemonTypeName(rawValue: type)?.displayName ?? "")
            }
            
            //키, 몸무게 - 단위 : 몸무게(그램), 키(데시미터. 1/10m = 10cm)
            self.heightLabel.text = "키: " + String(Double(pokemonInfo.height) / 10) + " m"
            self.weightLabel.text = "몸무게: " + String(Double(pokemonInfo.weight) / 10) + " kg"
            
        }, onError: { error in
            print("에러 발생: \(error)")
        }).disposed(by: disposeBag)
    }
    
    // MARK: - 포켓몬 이미지 작업
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
    
    // MARK: - UI 제약조건
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

// MARK: - 포켓몬 속성 한국어 버젼
enum PokemonTypeName: String, CaseIterable, Codable {
    case normal
    case fire
    case water
    case electric
    case grass
    case ice
    case fighting
    case poison
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
    case dragon
    case dark
    case steel
    case fairy

    var displayName: String {
        switch self {
        case .normal: return "노말"
        case .fire: return "불꽃"
        case .water: return "물"
        case .electric: return "전기"
        case .grass: return "풀"
        case .ice: return "얼음"
        case .fighting: return "격투"
        case .poison: return "독"
        case .ground: return "땅"
        case .flying: return "비행"
        case .psychic: return "에스퍼"
        case .bug: return "벌레"
        case .rock: return "바위"
        case .ghost: return "고스트"
        case .dragon: return "드래곤"
        case .dark: return "어둠"
        case .steel: return "강철"
        case .fairy: return "페어리"
        }
    }
    
}

