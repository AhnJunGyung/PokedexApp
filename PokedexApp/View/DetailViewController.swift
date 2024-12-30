//
//  DetailViewController.swift
//  PokedexApp
//
//  Created by t2023-m0072 on 12/30/24.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    private let id: Int
    
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainRed
        
        configureUI()
    }
    
    private func configureUI() {
        
    }
    
}
