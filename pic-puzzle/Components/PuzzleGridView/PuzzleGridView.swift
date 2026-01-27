//
//  PuzzleGridView.swift
//  pic-puzzle
//
//  Created by Ossama Abdelwahab on 23/01/26.
//

import UIKit

// MARK: - PuzzleGridViewDelegate Protocol

/// Delegate protocol to communicate tile swap events from the grid view to the view controller
protocol PuzzleGridViewDelegate: AnyObject {
    /// Called when user successfully swaps two tiles through drag-and-drop interaction
    /// - Parameters:
    ///   - gridView: The puzzle grid view where the swap occurred
    ///   - index1: The index of the first tile being swapped
    ///   - index2: The index of the second tile being swapped
    func puzzleGrid(_ gridView: PuzzleGridView, didSwapTileAt index1: Int, with index2: Int)
}

// MARK: - PuzzleGridView

/// Custom UIView that displays a dynamic grid of puzzle tiles with drag-and-drop swap functionality
/// Grid size is determined by GameConfiguration.gridSize (e.g., 3x3, 4x4, 5x5)
/// Manages tile layout, user interactions, and visual animations for tile swapping
class PuzzleGridView: UIView {
    
    // MARK: - Public Properties
    
    /// Delegate to receive tile swap events
    weak var delegate: PuzzleGridViewDelegate?
    
    // MARK: - Private Properties
    
    /// Array of tile views arranged in a grid layout (size based on GameConfiguration)
    private var tileViews: [TileView] = []
    
    /// Number of tiles per row/column (dynamically set from GameConfiguration)
    private let gridSize: Int
    
    /// Visual spacing between tiles in points
    private let spacing: CGFloat = 4
    
    /// Reference to the tile view currently being dragged by the user
    private var draggedTileView: TileView?
    
    /// Original center position of the dragged tile (used to animate return on invalid drop)
    private var draggedTileOriginalCenter: CGPoint = .zero
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        self.gridSize = GameConfiguration.gridSize
        super.init(frame: frame)
        setupGrid()
    }
    
    required init?(coder: NSCoder) {
        self.gridSize = GameConfiguration.gridSize
        super.init(coder: coder)
        setupGrid()
    }
    
    // MARK: - Setup
    
    /// Creates and configures tile views with pan gesture recognizers
    /// Number of tiles is determined by gridSize² (e.g., 3x3=9 tiles, 4x4=16 tiles)
    /// Sets up the initial grid structure with empty tiles ready to be populated
    private func setupGrid() {
        backgroundColor = .systemBackground
        
        let totalTiles = gridSize * gridSize
        // Create tile views based on grid size
        for i in 0..<totalTiles {
            let tileView = TileView()
            tileView.tag = i // Tag for easy identification during debugging
            
            // Add pan gesture recognizer to enable drag-and-drop interaction
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            tileView.addGestureRecognizer(panGesture)
            tileView.isUserInteractionEnabled = true
            
            addSubview(tileView)
            tileViews.append(tileView)
        }
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTiles()
    }
    
    /// Calculates and positions all tiles in a grid with proper spacing
    /// Grid dimensions are determined by GameConfiguration.gridSize
    /// Ensures tiles are square and evenly distributed within the view bounds
    private func layoutTiles() {
        // Calculate available space after accounting for spacing between tiles
        let totalSpacing = spacing * CGFloat(gridSize - 1)
        let availableWidth = bounds.width - totalSpacing
        let availableHeight = bounds.height - totalSpacing
        
        // Calculate tile size (ensure square tiles by using minimum dimension)
        let tileWidth = availableWidth / CGFloat(gridSize)
        let tileHeight = availableHeight / CGFloat(gridSize)
        let tileSize = min(tileWidth, tileHeight)
        
        // Position each tile in the grid
        for (index, tileView) in tileViews.enumerated() {
            let row = index / gridSize
            let col = index % gridSize
            
            let x = CGFloat(col) * (tileSize + spacing)
            let y = CGFloat(row) * (tileSize + spacing)
            
            tileView.frame = CGRect(x: x, y: y, width: tileSize, height: tileSize)
        }
    }
    
    // MARK: - Public Methods
    
    /// Updates a single tile at the specified index after a swap operation
    /// - Parameters:
    ///   - index: The grid index where the tile should be updated
    ///   - tile: The tile model containing position and state data
    ///   - image: The image to display on the tile (optional)
    func updateTile(at index: Int, with tile: Tile, image: UIImage?) {
        tileViews[safe: index]?.configure(with: image, tile: tile, index: index)
    }
    
    // MARK: - Gesture Handling
    
    /// Handles pan gesture for drag-and-drop tile swapping
    /// Manages three gesture states: began (start drag), changed (track movement), ended (complete or cancel swap)
    /// - Parameter gesture: The pan gesture recognizer attached to the tile view
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let tileView = gesture.view as? TileView else { return }
        
        // Prevent dragging locked tiles (e.g., already in correct position)
        if tileView.isLocked {
            return
        }
        
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .began:
            // Start dragging: store reference and original position
            draggedTileView = tileView
            draggedTileOriginalCenter = tileView.center
            tileView.setHighlighted(true) // Visual feedback
            bringSubviewToFront(tileView) // Ensure tile appears above others
            
        case .changed:
            // Update tile position as user drags
            tileView.center = CGPoint(
                x: draggedTileOriginalCenter.x + translation.x,
                y: draggedTileOriginalCenter.y + translation.y
            )
            
        case .ended, .cancelled:
            // Finish dragging: determine if swap should occur
            tileView.setHighlighted(false)
            
            // Find the tile we're hovering over (collision detection)
            let centerPoint = tileView.center
            if let targetTileView = findTileView(at: centerPoint, excluding: tileView) {
                // Check if target tile can be swapped (not locked)
                if !targetTileView.isLocked {
                    // Perform swap animation and notify delegate
                    let fromIndex = tileView.index
                    let toIndex = targetTileView.index
                    
                    animateSwap(from: tileView, to: targetTileView) { [weak self] in
                        guard let self = self else { return }
                        self.delegate?.puzzleGrid(self, didSwapTileAt: fromIndex, with: toIndex)
                    }
                } else {
                    // Target is locked: return tile to original position
                    returnToOriginalPosition(tileView)
                }
            } else {
                // No valid drop target: return tile to original position
                returnToOriginalPosition(tileView)
            }
            
            draggedTileView = nil
            
        default:
            break
        }
    }
    
    // MARK: - Private Helper Methods
    
    /// Finds a tile view at the specified point (used for collision detection during drag)
    /// - Parameters:
    ///   - point: The point to check for tile collision
    ///   - excludedView: The tile view to exclude from the search (typically the dragged tile)
    /// - Returns: The tile view at the specified point, or nil if no tile found
    private func findTileView(at point: CGPoint, excluding excludedView: TileView) -> TileView? {
        for tileView in tileViews {
            if tileView != excludedView && tileView.frame.contains(point) {
                return tileView
            }
        }
        return nil
    }
    
    /// Animates a smooth tile swap transition between two tiles
    /// Swaps the frame positions of two tiles with animation, then triggers completion callback
    /// - Parameters:
    ///   - tile1: The first tile to swap
    ///   - tile2: The second tile to swap
    ///   - completion: Callback to execute after animation completes (typically notifies delegate)
    private func animateSwap(from tile1: TileView, to tile2: TileView, completion: @escaping () -> Void) {
        let tile1OriginalFrame = tile1.frame
        let tile2OriginalFrame = tile2.frame
        
        UIView.animate(withDuration: 0.3, animations: {
            tile1.frame = tile2OriginalFrame
            tile2.frame = tile1OriginalFrame
        }) { _ in
            completion()
        }
    }
    
    /// Returns a tile to its original position with animation (used for invalid drop attempts)
    /// - Parameter tileView: The tile view to return to its original position
    private func returnToOriginalPosition(_ tileView: TileView) {
        UIView.animate(withDuration: 0.3) {
            tileView.center = self.draggedTileOriginalCenter
        }
    }
}
