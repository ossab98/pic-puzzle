//
//  GameConfiguration.swift
//  pic-puzzle
//
//  Created by Ossama Abdelwahab on 27/01/26.
//

import Foundation

/// Global game configuration
/// Change gridSize to adjust puzzle difficulty (3 = 3x3 = 9 tiles, 4 = 4x4 = 16 tiles, etc.)
enum GameConfiguration {
    /// Size of the puzzle grid
    /// - 3 = 3x3 grid (9 tiles) - Easy
    /// - 4 = 4x4 grid (16 tiles) - Medium
    /// - 5 = 5x5 grid (25 tiles) - Hard
    static let gridSize: Int = 3
    
    /// Total number of tiles based on grid size
    static var totalTiles: Int {
        return gridSize * gridSize
    }
}
