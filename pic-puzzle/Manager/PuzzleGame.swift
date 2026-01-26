//
//  PuzzleGame.swift
//  pic-puzzle
//
//  Created by Ossama Abdelwahab on 23/01/26.
//

import UIKit

// MARK: - PuzzleGame

/// Core game logic manager for the puzzle game
/// Handles tile management, swap operations, position tracking, and completion state
/// Supports save/load functionality for game persistence
class PuzzleGame {
    
    // MARK: - Properties
    
    /// Array of tiles in their current grid positions (index represents position)
    private(set) var tiles: [Tile]
    
    /// Size of the puzzle grid (3 = 3x3 = 9 tiles)
    private let gridSize = 3
    
    // MARK: - Computed Properties
    
    /// Returns true when all tiles are in their correct positions (puzzle solved)
    var isCompleted: Bool {
        return tiles.allSatisfy { $0.isInCorrectPosition }
    }
    
    // MARK: - Initialization
    
    /// Creates a new puzzle game with shuffled tiles
    /// Initializes 9 tiles (3x3 grid) and shuffles them into random positions
    init() {
        // Initialize 9 tiles with sequential IDs (each tile knows its correct position)
        self.tiles = (0..<9).map { Tile(id: $0, correctPosition: $0, currentPosition: $0) }
        shuffleTiles()
    }
    
    // MARK: - Game Logic
    
    /// Checks if two tiles at given indices can be swapped
    /// Checks if two tiles can be swapped
    /// Tiles cannot be swapped if either is locked (already in correct position)
    /// Note: Adjacency is validated by the UI layer (PuzzleGridView) based on visual positions
    /// - Parameters:
    ///   - index1: Grid index of first tile
    ///   - index2: Grid index of second tile
    /// - Returns: True if swap is allowed, false if either tile is locked or indices invalid
    func canSwapTiles(at index1: Int, with index2: Int) -> Bool {
        // Can't swap a tile with itself
        guard index1 != index2 else { return false }
        
        guard let tile1 = tiles[safe: index1],
              let tile2 = tiles[safe: index2] else {
            return false
        }
        
        // Prevent swapping locked tiles (already in correct position)
        return !tile1.isLocked && !tile2.isLocked
    }
    
    /// Performs tile swap operation and automatically locks tiles that end up in correct position
    /// Updates tile positions and lock states after swap
    /// - Parameters:
    ///   - index1: Grid index of first tile
    ///   - index2: Grid index of second tile
    func swapTiles(at index1: Int, with index2: Int) {
        guard canSwapTiles(at: index1, with: index2) else { return }
        
        // Swap the tiles in the array
        tiles.swapAt(index1, index2)
        
        // Update current position tracking
        tiles[index1].currentPosition = index1
        tiles[index2].currentPosition = index2
        
        // Auto-lock tiles that are now in correct position
        [index1, index2].forEach { index in
            if tiles[index].isInCorrectPosition {
                tiles[index].isLocked = true
            }
        }
    }
    
    /// Retrieves the tile at a specific grid position
    /// - Parameter index: Grid position index (0-8 for 3x3 grid)
    /// - Returns: The tile at that position, or nil if index is invalid
    func getTile(at index: Int) -> Tile? {
        return tiles[safe: index]
    }
    
    // MARK: - Private Methods

    /// Randomizes tile positions to create a new unsolved puzzle.
    /// Uses Fisher–Yates shuffle and retries until the puzzle is not already solved.
    private func shuffleTiles() {
        repeat {
            applyRandomPositions()
        } while isCompleted
    }

    /// Applies a random permutation of positions to all tiles
    private func applyRandomPositions() {
        let shuffledPositions = generateShuffledPositions(count: tiles.count)

        for (index, position) in shuffledPositions.enumerated() {
            tiles[index].currentPosition = position
        }

        sortTilesByCurrentPosition()
    }

    /// Generates a shuffled array of positions [0..<count]
    private func generateShuffledPositions(count: Int) -> [Int] {
        var positions = Array(0..<count)
        positions.shuffle()
        return positions
    }

    /// Sorts tiles to match their visual grid order
    private func sortTilesByCurrentPosition() {
        tiles.sort { $0.currentPosition < $1.currentPosition }
    }

    
}
