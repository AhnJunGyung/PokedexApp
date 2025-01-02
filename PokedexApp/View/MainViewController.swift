//
//  ViewController.swift
//  PokedexApp
//
//  Created by t2023-m0072 on 12/27/24.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()//뷰 모델 : 비즈니스 로직
    private let disposeBag = DisposeBag()
    private var pokemon = [Pokemon]()
    
    // MARK: - UI 생성
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: ImageResource.pokemonBall)
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.darkRed
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureUI()
    }
    
    // MARK: - 포켓몬 이미지 가져오기
    private func bind() {
        //viewModel의 pokemonSubject 구독
        viewModel.pokemonSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] pokemon in //UI관련 로직이기 때문에 메인쓰레드에 할당
                self?.pokemon.append(contentsOf: pokemon)
                self?.collectionView.reloadData()
            }, onError: { error in
                print("에러 발생: \(error)")
            }).disposed(by: disposeBag)
    }
    
    // MARK: - UI 제약조건
    private func configureUI() {
        view.backgroundColor = UIColor.mainRed
        [imageView, collectionView].forEach { view.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.height.width.equalTo(100)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
        }
    }
}

// MARK: - 컬렉션뷰 레이아웃 설정
private func createLayout() -> UICollectionViewLayout {
    
    //NSCollectionLayoutSize로 itemSize 설정
    let itemSize = NSCollectionLayoutSize (widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0))
    
    //설정한 itemSize를 NSCollectionLayoutItem에 적용
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 3)//아이템 간격
    
    //그룹 크기 설정
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
    
    //groupSize를 그룹에 적용하고 아이템이 수평으로 나열되도록 설정
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    //크기가 설정된 그룹을 섹션에 적용
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 10//그룹 간격
    section.contentInsets = .init(top: 5, leading: 0, bottom: 0, trailing: 0)//섹션 간격
    
    return UICollectionViewCompositionalLayout(section: section)
}

// MARK: - 컬렌션뷰 설정
extension MainViewController: UICollectionViewDelegate {
    //컬렉션 뷰 선택시 이벤트
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailViewController(id: pokemon[indexPath.row].id), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        //현재 로드된 포켓몬 개수 체크
        guard pokemon.count < 1020 else {
            return
        }
        
        if indexPath.row > pokemon.count - 5 {
            viewModel.fetchPokemon()
//            collectionView.rx.contentOffset.throttle(.seconds(1), scheduler: MainScheduler.instance)
//                .subscribe(onNext: { [weak self] _ in
//                    self?.viewModel.fetchPokemon()
//                }).disposed(by: disposeBag)
        }
    }
    
}



extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.id, for: indexPath) as? MainCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(pokemon[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemon.count
    }
}


