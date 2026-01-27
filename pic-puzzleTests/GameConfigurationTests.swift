//
//  GameConfigurationTests.swift
//  pic-puzzleTests
//
//  Created by Ossama Abdelwahab on 27/01/26.
//

import XCTest
@testable import pic_puzzle

/// Unit tests for GameConfiguration
/// Tests verify grid size configuration and its impact on game components
final class GameConfigurationTests: XCTestCase {
    
    // MARK: - Configuration Tests
    
    /// Test that gridSize is properly configured
    func testGameConfiguration_GridSize_ShouldBePositiveInteger() {
        // Given & When: Current grid size from configuration
        let gridSize = GameConfiguration.gridSize
        
        // Then: Grid size should be a positive integer
        XCTAssertGreaterThan(gridSize, 0, "Grid size must be greater than 0")
    }
    
    /// Test that totalTiles calculation is correct
    func testGameConfiguration_TotalTiles_ShouldEqualGridSizeSquared() {
        // Given: Current grid size
        let gridSize = GameConfiguration.gridSize
        let expectedTotalTiles = gridSize * gridSize
        
        // When: We get total tiles from configuration
        let actualTotalTiles = GameConfiguration.totalTiles
        
        // Then: Total tiles should equal gridSize²
        XCTAssertEqual(actualTotalTiles, expectedTotalTiles, 
                       "Total tiles should equal gridSize squared (gridSize: \(gridSize), expected: \(expectedTotalTiles))")
    }
    
    // MARK: - Integration Tests with PuzzleGame
    
    /// Test that PuzzleGame initializes with correct number of tiles based on configuration
    func testPuzzleGame_WhenInitialized_ShouldHaveCorrectNumberOfTiles() {
        // Given: Expected tiles count from configuration
        let expectedTilesCount = GameConfiguration.totalTiles
        
        // When: We use the shared puzzle game instance
        let puzzleGame = PuzzleGame.shared
        puzzleGame.resetGame() // Reset to ensure clean state
        
        // Then: Game should have correct number of tiles
        XCTAssertEqual(puzzleGame.tiles.count, expectedTilesCount,
                       "PuzzleGame should initialize with \(expectedTilesCount) tiles (gridSize: \(GameConfiguration.gridSize))")
    }
    
    /// Test that all tiles have valid positions based on grid size
    func testPuzzleGame_AllTiles_ShouldHaveValidPositions() {
        // Given: The shared puzzle game instance and valid range
        let puzzleGame = PuzzleGame.shared
        puzzleGame.resetGame() // Reset to ensure clean state
        let validRange = 0..<GameConfiguration.totalTiles
        
        // When: We check all tile positions
        let allPositionsValid = puzzleGame.tiles.allSatisfy { tile in
            validRange.contains(tile.currentPosition) &&
            validRange.contains(tile.correctPosition)
        }
        
        // Then: All positions should be within valid range
        XCTAssertTrue(allPositionsValid,
                     "All tile positions should be in range 0..<\(GameConfiguration.totalTiles)")
    }
    
    // MARK: - Grid Size Variation Tests
    
    /// Test that configuration supports different grid sizes
    /// This test documents expected behavior for different grid sizes
    func testGameConfiguration_DifferentGridSizes_ShouldProduceCorrectTotalTiles() {
        // Given: Different grid sizes and their expected total tiles
        let testCases: [(gridSize: Int, expectedTiles: Int)] = [
            (3, 9),   // Easy: 3x3 = 9 tiles
            (4, 16),  // Medium: 4x4 = 16 tiles
            (5, 25),  // Hard: 5x5 = 25 tiles
            (6, 36),  // Expert: 6x6 = 36 tiles
        ]
        
        // When & Then: Verify calculation for each case
        for testCase in testCases {
            let calculatedTiles = testCase.gridSize * testCase.gridSize
            XCTAssertEqual(calculatedTiles, testCase.expectedTiles,
                          "Grid size \(testCase.gridSize) should produce \(testCase.expectedTiles) tiles")
        }
    }
    
    // MARK: - Edge Cases
    
    /// Test minimum viable grid size (2x2)
    func testGameConfiguration_MinimumGridSize_ShouldWorkCorrectly() {
        // Given: Minimum viable grid size
        let minGridSize = 2
        let expectedMinTiles = minGridSize * minGridSize
        
        // When & Then: Should produce valid tile count
        XCTAssertEqual(expectedMinTiles, 4, "Minimum 2x2 grid should have 4 tiles")
        XCTAssertGreaterThan(expectedMinTiles, 0, "Minimum grid should have positive tiles")
    }
    
    /// Test that current configuration is within reasonable bounds
    func testGameConfiguration_CurrentGridSize_ShouldBeReasonable() {
        // Given: Current grid size
        let gridSize = GameConfiguration.gridSize
        
        // Then: Should be within reasonable bounds for gameplay
        XCTAssertGreaterThanOrEqual(gridSize, 2, "Grid size should be at least 2 for meaningful gameplay")
        XCTAssertLessThanOrEqual(gridSize, 10, "Grid size should not exceed 10 for practical UX")
    }
}
