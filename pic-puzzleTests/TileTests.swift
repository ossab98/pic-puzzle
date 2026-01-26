//
//  TileTests.swift
//  pic-puzzleTests
//
//  Created by Ossama Abdelwahab on 26/01/26.
//

import XCTest
@testable import pic_puzzle

/// Unit tests for Tile model
/// Tests cover initialization, computed properties, and state management
final class TileTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    /// Test that tile initializes with correct properties
    func testTile_WhenInitialized_ShouldHaveCorrectProperties() {
        // Given: Parameters for a new tile
        let id = 5
        let correctPosition = 5
        let currentPosition = 2
        let isLocked = false
        
        // When: We create a tile
        let tile = Tile(id: id, 
                       correctPosition: correctPosition, 
                       currentPosition: currentPosition, 
                       isLocked: isLocked)
        
        // Then: All properties should match
        XCTAssertEqual(tile.id, id, "Tile ID should match")
        XCTAssertEqual(tile.correctPosition, correctPosition, "Correct position should match")
        XCTAssertEqual(tile.currentPosition, currentPosition, "Current position should match")
        XCTAssertEqual(tile.isLocked, isLocked, "Lock state should match")
    }
    
    // MARK: - Computed Property Tests
    
    /// Test that tile is in correct position when currentPosition matches correctPosition
    func testTile_WhenInCorrectPosition_IsInCorrectPositionShouldBeTrue() {
        // Given: A tile where current position matches correct position
        let tile = Tile(id: 3, correctPosition: 3, currentPosition: 3)
        
        // When: We check if it's in correct position
        let isInCorrectPosition = tile.isInCorrectPosition
        
        // Then: Should return true
        XCTAssertTrue(isInCorrectPosition, "Tile should be in correct position")
    }
    
    /// Test that tile is not in correct position when positions don't match
    func testTile_WhenNotInCorrectPosition_IsInCorrectPositionShouldBeFalse() {
        // Given: A tile where current position doesn't match correct position
        let tile = Tile(id: 3, correctPosition: 3, currentPosition: 7)
        
        // When: We check if it's in correct position
        let isInCorrectPosition = tile.isInCorrectPosition
        
        // Then: Should return false
        XCTAssertFalse(isInCorrectPosition, "Tile should not be in correct position")
    }
    
    // MARK: - Lock State Tests
    
    /// Test that tile can be locked when in correct position
    func testTile_WhenInCorrectPositionAndLocked_ShouldBeLockedAndInCorrectPosition() {
        // Given: A tile in correct position that is locked
        let tile = Tile(id: 4, correctPosition: 4, currentPosition: 4, isLocked: true)
        
        // When: We check both properties
        let isLocked = tile.isLocked
        let isInCorrectPosition = tile.isInCorrectPosition
        
        // Then: Both should be true
        XCTAssertTrue(isLocked, "Tile should be locked")
        XCTAssertTrue(isInCorrectPosition, "Tile should be in correct position")
    }
    
    /// Test that tile lock state can be modified
    func testTile_WhenLockStateChanged_ShouldUpdateCorrectly() {
        // Given: A tile that starts unlocked
        var tile = Tile(id: 2, correctPosition: 2, currentPosition: 5, isLocked: false)
        
        // When: We lock the tile
        tile.isLocked = true
        
        // Then: Tile should be locked
        XCTAssertTrue(tile.isLocked, "Tile lock state should be updated to true")
        
        // When: We unlock the tile
        tile.isLocked = false
        
        // Then: Tile should be unlocked
        XCTAssertFalse(tile.isLocked, "Tile lock state should be updated to false")
    }
    
    // MARK: - Equality Tests
    
    /// Test that two tiles with same properties are equal
    @MainActor
    func testTile_WithSameProperties_ShouldBeEqual() {
        // Given: Two tiles with identical properties
        let tile1 = Tile(id: 1, correctPosition: 1, currentPosition: 3, isLocked: false)
        let tile2 = Tile(id: 1, correctPosition: 1, currentPosition: 3, isLocked: false)
        
        // When: We compare them
        let areEqual = tile1 == tile2
        
        // Then: They should be equal
        XCTAssertTrue(areEqual, "Tiles with same properties should be equal")
    }
    
    /// Test that two tiles with different properties are not equal
    @MainActor
    func testTile_WithDifferentProperties_ShouldNotBeEqual() {
        // Given: Two tiles with different properties
        let tile1 = Tile(id: 1, correctPosition: 1, currentPosition: 3, isLocked: false)
        let tile2 = Tile(id: 2, correctPosition: 2, currentPosition: 5, isLocked: true)
        
        // When: We compare them
        let areEqual = tile1 == tile2
        
        // Then: They should not be equal
        XCTAssertFalse(areEqual, "Tiles with different properties should not be equal")
    }
}
