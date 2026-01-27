//
//  PuzzleGameTests.swift
//  pic-puzzleTests
//
//  Created by Ossama Abdelwahab on 26/01/26.
//

import XCTest
@testable import pic_puzzle

/// Unit tests for PuzzleGame class
/// Tests cover initialization, tile management, swap operations, and game completion logic
final class PuzzleGameTests: XCTestCase {
    
    // System Under Test
    var sut: PuzzleGame!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        // Use shared singleton instance
        sut = PuzzleGame.shared
        // Reset game to ensure clean state for each test
        sut.resetGame()
    }
    
    override func tearDown() {
        // Clean up after each test
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    /// Test that puzzle initializes with correct number of tiles based on GameConfiguration
    func testPuzzleGame_WhenInitialized_ShouldHaveCorrectNumberOfTiles() {
        // Given: A new puzzle game (created in setUp) and expected count from configuration
        let expectedTilesCount = GameConfiguration.totalTiles
        
        // When: We check the tiles count
        let tilesCount = sut.tiles.count
        
        // Then: Should have correct number of tiles based on grid size
        XCTAssertEqual(tilesCount, expectedTilesCount, 
                       "Puzzle should have \(expectedTilesCount) tiles for a \(GameConfiguration.gridSize)x\(GameConfiguration.gridSize) grid")
    }
    
    /// Test that tiles are shuffled during initialization (not in solved state)
    func testPuzzleGame_WhenInitialized_ShouldShuffleTiles() {
        // Given: A new puzzle game (created in setUp)
        
        // When: We check if any tile is not in its correct position
        let tiles = sut.tiles
        var isShuffled = false
        
        for (index, tile) in tiles.enumerated() {
            if tile.correctPosition != index {
                isShuffled = true
                break
            }
        }
        
        // Then: At least one tile should be out of place
        XCTAssertTrue(isShuffled, "Tiles should be shuffled on initialization")
    }
    
    /// Test that puzzle is not completed when first initialized
    func testPuzzleGame_WhenInitialized_ShouldNotBeCompleted() {
        // Given: A new puzzle game (created in setUp)
        
        // When: We check if puzzle is completed
        let isCompleted = sut.isCompleted
        
        // Then: Should not be completed (tiles are shuffled)
        XCTAssertFalse(isCompleted, "Puzzle should not be completed when initialized")
    }
    
    // MARK: - Tile Access Tests
    
    /// Test retrieving a tile at a valid index
    func testGetTile_WithValidIndex_ShouldReturnTile() {
        // Given: A puzzle game with tiles
        let validIndex = 0
        
        // When: We get a tile at valid index
        let tile = sut.getTile(at: validIndex)
        
        // Then: Should return a tile (not nil)
        XCTAssertNotNil(tile, "Should return a tile for valid index")
    }
    
    /// Test retrieving a tile at negative index returns nil
    func testGetTile_WithNegativeIndex_ShouldReturnNil() {
        // Given: A puzzle game
        let invalidIndex = -1
        
        // When: We try to get a tile at negative index
        let tile = sut.getTile(at: invalidIndex)
        
        // Then: Should return nil (safe array access)
        XCTAssertNil(tile, "Should return nil for negative index")
    }
    
    /// Test retrieving a tile at out of bounds index returns nil
    func testGetTile_WithOutOfBoundsIndex_ShouldReturnNil() {
        // Given: A puzzle game with 9 tiles
        let invalidIndex = 10
        
        // When: We try to get a tile beyond array bounds
        let tile = sut.getTile(at: invalidIndex)
        
        // Then: Should return nil (safe array access)
        XCTAssertNil(tile, "Should return nil for out of bounds index")
    }
    
    // MARK: - Swap Validation Tests
    
    /// Test that tiles at valid indices can be checked for swap ability based on lock status
    func testCanSwapTiles_WithUnlockedTiles_ShouldReturnTrue() {
        // Given: Two tiles at valid indices that are not locked
        let index1 = 0
        let index2 = 1
        
        // When: We check if they can be swapped
        let canSwap = sut.canSwapTiles(at: index1, with: index2)
        
        // Then: Result depends on whether tiles are locked
        let tile1Locked = sut.tiles[index1].isLocked
        let tile2Locked = sut.tiles[index2].isLocked
        XCTAssertEqual(canSwap, !tile1Locked && !tile2Locked,
                      "Can swap only if both tiles are unlocked")
    }
    
    /// Test that swapping with negative index is invalid
    func testCanSwapTiles_WithNegativeIndex_ShouldReturnFalse() {
        // Given: A valid index and a negative index
        let validIndex = 0
        let invalidIndex = -1
        
        // When: We check if they can be swapped
        let canSwap = sut.canSwapTiles(at: validIndex, with: invalidIndex)
        
        // Then: Should return false (invalid index)
        XCTAssertFalse(canSwap, "Should not allow swap with negative index")
    }
    
    /// Test that swapping with out of bounds index is invalid
    func testCanSwapTiles_WithOutOfBoundsIndex_ShouldReturnFalse() {
        // Given: A valid index and an out of bounds index
        let validIndex = 0
        let invalidIndex = 10
        
        // When: We check if they can be swapped
        let canSwap = sut.canSwapTiles(at: validIndex, with: invalidIndex)
        
        // Then: Should return false (invalid index)
        XCTAssertFalse(canSwap, "Should not allow swap with out of bounds index")
    }
    
    /// Test that swapping a tile with itself is invalid
    func testCanSwapTiles_WithSameIndex_ShouldReturnFalse() {
        // Given: Same index for both parameters
        let index = 0
        
        // When: We try to swap a tile with itself
        let canSwap = sut.canSwapTiles(at: index, with: index)
        
        // Then: Should return false (can't swap with self)
        XCTAssertFalse(canSwap, "Should not allow swapping a tile with itself")
    }
    
    // MARK: - Swap Operation Tests
    
    /// Test that swapping tiles updates their positions correctly
    func testSwapTiles_WhenExecuted_ShouldSwapTilePositions() {
        // Given: Two adjacent tiles that can be swapped
        let index1 = 0
        let index2 = 1
        
        // Store original tile IDs
        let originalTile1Id = sut.tiles[index1].id
        let originalTile2Id = sut.tiles[index2].id
        
        // When: We swap the tiles
        sut.swapTiles(at: index1, with: index2)
        
        // Then: Tiles should be swapped (IDs at positions should be reversed)
        // OR tiles were locked and didn't swap
        let swapped = sut.tiles[index1].id == originalTile2Id && 
                      sut.tiles[index2].id == originalTile1Id
        let bothLocked = sut.tiles[index1].isLocked && sut.tiles[index2].isLocked
        
        XCTAssertTrue(swapped || bothLocked,
                     "Tiles should swap positions or both should be locked")
    }
}
