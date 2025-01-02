//
//  MainCollectionViewCell.swift
//  PokedexApp
//
//  Created by t2023-m0072 on 12/27/24.
//

import UIKit
import SnapKit

class MainCollectionViewCell: UICollectionViewCell {
    
    static let id = "MainCollectionViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.cellBackground
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds//이미지 뷰 크기를 컨텐트뷰와 동일하게 만듦
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //셀 재활용 전에 동작하는 함수
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil//셀 이미지를 비워 버벅거림을 줄여줌
    }
    
    /*
    func configure(indexPath: Int) {
        //셀 indexPath로 포켓몬 id 식별. indexPath는 0부터 시작되기 때문에 +1
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(indexPath + 1).png"

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
     */
    
    func configure(indexPath: Int) {
        //셀 indexPath로 포켓몬 id 식별. indexPath는 0부터 시작되기 때문에 +1
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(indexPath + 1).png"

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
}
