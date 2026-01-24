//
//  Tile.swift
//  pic-puzzle
//
//  Created by Ossama Abdelwahab on 23/01/26.
//

import UIKit

// MARK: - Tile

/// Model representing a single puzzle piece in the game
/// Tracks tile identity, correct position, current position, and lock state
/// Conforms to Codable for persistence and Equatable for comparison operations
struct Tile: Codable, Equatable {
    
    // MARK: - Properties
    
    /// Unique identifier for this tile (0-8 for 3x3 grid)
    /// Also represents which image slice this tile displays
    let id: Int
    
    /// The grid position where this tile should be in the solved puzzle (0-8)
    let correctPosition: Int
    
    /// The tile's current grid position during gameplay (0-8)
    /// Updated when tiles are swapped by user
    var currentPosition: Int
    
    /// Lock state indicating if tile is in correct position and cannot be moved
    /// Locked tiles are visually indicated with green border/overlay
    var isLocked: Bool
    
    // MARK: - Computed Properties
    
    /// Returns true if tile is currently in its correct position (solved)
    /// When true, tile becomes eligible for locking
    var isInCorrectPosition: Bool {
        return currentPosition == correctPosition
    }
    
    // MARK: - Initialization
    
    /// Creates a new tile with specified properties
    /// - Parameters:
    ///   - id: Unique tile identifier (also determines image slice)
    ///   - correctPosition: Target position in solved puzzle
    ///   - currentPosition: Initial position in grid
    ///   - isLocked: Whether tile starts locked (default false)
    init(id: Int, correctPosition: Int, currentPosition: Int, isLocked: Bool = false) {
        self.id = id
        self.correctPosition = correctPosition
        self.currentPosition = currentPosition
        self.isLocked = isLocked
    }
}
