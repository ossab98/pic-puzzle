//
//  HomeViewController.swift
//  pic-puzzle
//
//  Created by Ossama Abdelwahab on 23/01/26.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Dependencies
    let viewModel: HomeViewModel
    
    // MARK: - Initializer
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: HomeViewController.self), bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "TileSwap"
    }
    
}
