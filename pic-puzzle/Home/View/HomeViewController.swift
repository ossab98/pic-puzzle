//
//  HomeViewController.swift
//  pic-puzzle
//
//  Created by Ossama Abdelwahab on 23/01/26.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    // MARK: - UI Components
    
    // 3x3 grid view for puzzle tiles
    private var puzzleGridView: PuzzleGridView!
    
    // Spinner shown during image loading
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // Preview image view to show complete image before puzzle starts
    private lazy var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Button to start a new puzzle
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("New Puzzle", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Vertical stack containing all UI elements
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 30
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - ViewModel
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
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
        setObservers()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = viewModel.screenTitle
        
        // Puzzle grid
        puzzleGridView = PuzzleGridView()
        puzzleGridView.delegate = self
        puzzleGridView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup stack view
        stackView.addArrangedSubviews([puzzleGridView, resetButton])
        view.addSubview(stackView)

        // Preview image view
        view.addSubview(previewImageView)
        
        // Loading indicator
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            // Stack view - centered with padding
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            
            // Puzzle grid - square aspect ratio only
            puzzleGridView.heightAnchor.constraint(equalTo: puzzleGridView.widthAnchor),
            
            // Reset button - fixed height only
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Preview image view - same position as puzzle grid
            previewImageView.leadingAnchor.constraint(equalTo: puzzleGridView.leadingAnchor),
            previewImageView.trailingAnchor.constraint(equalTo: puzzleGridView.trailingAnchor),
            previewImageView.topAnchor.constraint(equalTo: puzzleGridView.topAnchor),
            previewImageView.bottomAnchor.constraint(equalTo: puzzleGridView.bottomAnchor),
            
            // Loading indicator - centered on puzzle grid
            loadingIndicator.centerXAnchor.constraint(equalTo: puzzleGridView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: puzzleGridView.centerYAnchor)
        ])
    }
    
    // MARK: - Data Binding
    
    private func setObservers() {
        // Observe loading state
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.loadingIndicator.startAnimating()
                } else {
                    self.loadingIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        // Observe screen state
        viewModel.screenState
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                self.handleState(state)
            })
            .disposed(by: disposeBag)
        
        // Bind tiles
        viewModel.tiles
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] tiles in
                guard let self = self else { return }
                self.updatePuzzleGrid(with: tiles)
            })
            .disposed(by: disposeBag)
        
        // Bind tile images
        viewModel.tileImages
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.refreshPuzzleGrid()
            })
            .disposed(by: disposeBag)
    }
    
    private func handleState(_ state: HomeViewModel.PuzzleViewState) {
        switch state {
        case .default:
            puzzleGridView.alpha = 0
            previewImageView.alpha = 0
            
        case .loading:
            loadingIndicator.startAnimating()
            puzzleGridView.alpha = 0
            previewImageView.alpha = 0
            
        case .preview(let image):
            loadingIndicator.stopAnimating()
            previewImageView.image = image
            puzzleGridView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.previewImageView.alpha = 1
            }
            
        case .ready:
            loadingIndicator.stopAnimating()
            UIView.animate(withDuration: 1.0) {
                self.previewImageView.alpha = 0
                self.puzzleGridView.alpha = 1
            }
            
        case .error(let message):
            loadingIndicator.stopAnimating()
            previewImageView.alpha = 0
            showErrorAlert(message: message)
            
        case .completed:
            showCompletionAlert()
        }
    }
    
    private func updatePuzzleGrid(with tiles: [Tile]) {
        guard !tiles.isEmpty else { return }
        
        // Update each tile in the grid
        for (index, tile) in tiles.enumerated() {
            if let image = viewModel.getTileImage(forId: tile.id) {
                puzzleGridView.updateTile(at: index, with: tile, image: image)
            }
        }
    }
    
    private func refreshPuzzleGrid() {
        // Configure the grid view with current state
        for (index, tile) in viewModel.tiles.value.enumerated() {
            if let image = viewModel.getTileImage(forId: tile.id) {
                puzzleGridView.updateTile(at: index, with: tile, image: image)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func resetButtonTapped() {
        viewModel.resetPuzzle()
    }
    
    // MARK: - Alerts
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.loadPuzzle()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func showCompletionAlert() {
        let alert = UIAlertController(
            title: "🎉 Congratulations!",
            message: "You've completed the puzzle!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "New Puzzle", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.resetPuzzle()
        })
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - PuzzleGridViewDelegate

extension HomeViewController: PuzzleGridViewDelegate {
    // Handle tile swap from user drag gesture
    func puzzleGrid(_ gridView: PuzzleGridView, didSwapTileAt index1: Int, with index2: Int) {
        // Delegate to ViewModel
        viewModel.swapTiles(at: index1, with: index2)
        
        // Update UI with new tile positions
        if let tile1 = viewModel.getTile(at: index1),
           let tile2 = viewModel.getTile(at: index2) {
            let image1 = viewModel.getTileImage(forId: tile1.id)
            let image2 = viewModel.getTileImage(forId: tile2.id)
            
            gridView.updateTile(at: index1, with: tile1, image: image1)
            gridView.updateTile(at: index2, with: tile2, image: image2)
        }
    }
}
