//
//  HomeViewModel.swift
//  pic-puzzle
//
//  Created by Ossama Abdelwahab on 23/01/26.
//

import UIKit
import RxSwift
import RxRelay

// MARK: - HomeViewModel
class HomeViewModel {
    
    // MARK: - View State
    enum PuzzleViewState {
        case `default`
        case loading
        case preview(image: UIImage)
        case ready
        case error(message: String)
        case completed
        
        var descriptionText: String {
            switch self {
            case .default:
                return ""
            case .loading:
                return "Loading puzzle..."
            case .preview:
                return "Memorize the image! Game starts in a few seconds..."
            case .ready:
                return "Drag tiles to solve the puzzle!"
            case .error:
                return ""
            case .completed:
                return "🎉 Puzzle completed!"
            }
        }
    }

    // MARK: - Constants
    private enum Constants {
        static let previewDuration: TimeInterval = 5.0
        static let completionDelay: TimeInterval = 0.5
        static let gridSize = 3
    }
    
    // MARK: - Relays
    let isLoading = PublishRelay<Bool>()
    let screenState = BehaviorRelay<PuzzleViewState>(value: .default)
    let tiles = BehaviorRelay<[Tile]>(value: [])
    let tileImages = BehaviorRelay<[Int: UIImage]>(value: [:])
    let movesCount = BehaviorRelay<Int>(value: 0)
    
    // MARK: - Private Properties
    private var puzzleGame: PuzzleGame!
    private let imageLoader = ImageLoader.shared
    private var previewTimer: DispatchWorkItem?
    
    // MARK: - Public Properties
    
    // UI Text Properties
    var screenTitle: String { "TileSwap" }
    var newPuzzleButtonTitle: String { "New Puzzle" }
    func movesText(count: Int) -> String { "Moves: \(count)" }
    
    // Alert Properties
    var errorAlertTitle: String { "Error" }
    var retryButtonTitle: String { "Retry" }
    var cancelButtonTitle: String { "Cancel" }
    var completionAlertTitle: String { "🎉 Congratulations!" }
    var completionAlertMessage: String { "You've completed the puzzle!" }
    var okButtonTitle: String { "OK" }
    
    var isCompleted: Bool { puzzleGame?.isCompleted ?? false }
    var numberOfTiles: Int { tiles.value.count }
    
    // MARK: - Initialization
    init() {
    /// Initializes the ViewModel
        loadPuzzle()
    }
    
    // MARK: - Public Methods
    
    /// Load new puzzle game
    func loadPuzzle() {
        isLoading.accept(true)
        screenState.accept(.loading)
        
        puzzleGame = PuzzleGame()
        tiles.accept(puzzleGame.tiles)
        loadImageAndSetupPuzzle()
    }
    
    /// Reset puzzle and start fresh
    func resetPuzzle() {
        puzzleGame = PuzzleGame()
        tiles.accept(puzzleGame.tiles)
        tileImages.accept([:])
        movesCount.accept(0)
        loadImageAndSetupPuzzle()
    }
    
    /// Handle tile swap with validation and completion check
    /// - Parameters:
    ///   - index1: First tile index
    ///   - index2: Second tile index
    func swapTiles(at index1: Int, with index2: Int) {
        guard puzzleGame.canSwapTiles(at: index1, with: index2) else {
            return
        }
        
        // Perform swap in game model
        puzzleGame.swapTiles(at: index1, with: index2)
        
        // Increment moves counter
        movesCount.accept(movesCount.value + 1)
        
        // Update relay
        tiles.accept(puzzleGame.tiles)
        
        // Check completion with delay for smooth UX
        if puzzleGame.isCompleted {
            scheduleCompletionNotification()
        }
    }
    
    // MARK: - Private Helpers
    
    private func scheduleCompletionNotification() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.completionDelay) { [weak self] in
            guard let self = self else { return }
            self.screenState.accept(.completed)
        }
    }
    
    /// Get tile at specific index
    func getTile(at index: Int) -> Tile? {
        return puzzleGame.getTile(at: index)
    }
    
    /// Get image for tile
    func getTileImage(forId id: Int) -> UIImage? {
        return tileImages.value[id]
    }
    
    // MARK: - Private Methods
    
    private func loadImageAndSetupPuzzle() {
        isLoading.accept(true)
        screenState.accept(.loading)
        movesCount.accept(0)
        
        imageLoader.loadPuzzleImage { [weak self] image in
            guard let self = self else { return }
            
            self.isLoading.accept(false)
            
            guard let image = image else {
                self.screenState.accept(.error(message: "Failed to load puzzle image. Please check your connection and try again."))
                return
            }
            
            // setupPuzzleWithImage will handle the state transition from .preview to .ready
            self.setupPuzzleWithImage(image)
        }
    }
    
    private func setupPuzzleWithImage(_ image: UIImage) {
        let slicedImages = ImageSlicer.sliceImage(image, into: Constants.gridSize)
        
        // Create dictionary mapping tile ID to its image slice
        let imageDict = Dictionary(uniqueKeysWithValues: slicedImages.enumerated().map { ($0.offset, $0.element) })
        
        // Update relay with all tile images
        tileImages.accept(imageDict)
        
        // Cancel any existing preview timer to prevent race conditions
        previewTimer?.cancel()
        
        // Show preview of complete image before starting puzzle
        screenState.accept(.preview(image: image))
        
        // Schedule transition to ready state
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.screenState.accept(.ready)
        }
        previewTimer = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.previewDuration, execute: workItem)
    }
}
