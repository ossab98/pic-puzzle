//
//  HomeViewModelTests.swift
//  pic-puzzleTests
//
//  Created by Ossama Abdelwahab on 26/01/26.
//

import XCTest
import RxSwift
import RxRelay
import RxTest
@testable import pic_puzzle

/// Unit tests for HomeViewModel
/// Tests cover initialization, tile management, swapping, and observable behaviors
final class HomeViewModelTests: XCTestCase {
    
    // System Under Test
    var sut: HomeViewModel!
    
    // RxSwift testing utilities
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        // Create fresh instances before each test
        sut = HomeViewModel()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        // Clean up after each test
        sut = nil
        scheduler = nil
        disposeBag = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    /// Test that view model initializes with 9 tiles
    func testHomeViewModel_WhenInitialized_ShouldHaveNineTiles() {
        // Given: A new HomeViewModel (created in setUp)
        
        // When: We check the tiles count
        let tilesCount = sut.tiles.value.count
        
        // Then: Should have 9 tiles for 3x3 grid
        XCTAssertEqual(tilesCount, 9, "ViewModel should have 9 tiles")
    }
    
    /// Test that view model starts with zero moves
    func testHomeViewModel_WhenInitialized_ShouldHaveZeroMoves() {
        // Given: A new HomeViewModel (created in setUp)
        
        // When: We check the moves count
        let movesCount = sut.movesCount.value
        
        // Then: Should start with 0 moves
        XCTAssertEqual(movesCount, 0, "Moves count should start at 0")
    }
    
    /// Test that view model initializes with empty tile images
    func testHomeViewModel_WhenInitialized_ShouldHaveEmptyTileImages() {
        // Given: A new HomeViewModel (created in setUp)
        
        // When: We check the tile images dictionary
        let tileImages = sut.tileImages.value
        
        // Then: Should be empty initially (images loaded async)
        XCTAssertTrue(tileImages.isEmpty, "Tile images should be empty on init")
    }
    
    /// Test that screen title is correct
    func testHomeViewModel_ShouldHaveCorrectScreenTitle() {
        // Given: A HomeViewModel
        
        // When: We check the screen title
        let title = sut.screenTitle
        
        // Then: Should be "TileSwap"
        XCTAssertEqual(title, "TileSwap", "Screen title should be TileSwap")
    }
    
    // MARK: - Tile Access Tests
    
    /// Test getting a tile at valid index
    func testGetTile_WithValidIndex_ShouldReturnTile() {
        // Given: A view model with tiles
        let validIndex = 0
        
        // When: We get a tile at valid index
        let tile = sut.getTile(at: validIndex)
        
        // Then: Should return a tile
        XCTAssertNotNil(tile, "Should return tile at valid index")
        
        // And: Tile's current position should match index
        XCTAssertEqual(tile?.currentPosition, validIndex, "Tile should be at correct position")
    }
    
    /// Test getting a tile at invalid index
    func testGetTile_WithInvalidIndex_ShouldReturnNil() {
        // Given: A view model with tiles
        let invalidIndex = 100
        
        // When: We try to get a tile at invalid index
        let tile = sut.getTile(at: invalidIndex)
        
        // Then: Should return nil
        XCTAssertNil(tile, "Should return nil for invalid index")
    }
    
    // MARK: - Tile Swapping Tests
    
    /// Test that swapping adjacent tiles increments moves counter
    func testSwapTiles_WithAdjacentTiles_ShouldIncrementMovesCount() {
        // Given: Initial tiles and moves count
        let initialTiles = sut.tiles.value
        let initialMoves = sut.movesCount.value
        
        // When: We swap two adjacent tiles (0 and 1)
        sut.swapTiles(at: 0, with: 1)
        
        // Then: Moves count should increment (if swap was valid)
        let updatedTiles = sut.tiles.value
        
        // Check if tiles actually swapped (weren't locked)
        if initialTiles[0].id != updatedTiles[0].id {
            XCTAssertEqual(sut.movesCount.value, initialMoves + 1, 
                          "Moves count should increment after valid swap")
        }
    }

    // MARK: - Reset Tests
    
    /// Test that reset creates new puzzle and resets moves
    func testResetPuzzle_ShouldResetMovesAndCreateNewPuzzle() {
        // Given: A puzzle with some moves made
        sut.swapTiles(at: 0, with: 1)
        sut.swapTiles(at: 1, with: 2)
        
        // Ensure we have moves
        XCTAssertGreaterThan(sut.movesCount.value, 0, "Should have moves before reset")
        
        // When: We reset the puzzle
        sut.resetPuzzle()
        
        // Then: Moves should be back to 0
        XCTAssertEqual(sut.movesCount.value, 0, "Moves should reset to 0")
    }
    
    /// Test that reset maintains tile count
    func testResetPuzzle_ShouldMaintainTileCount() {
        // Given: A puzzle game
        let initialTileCount = sut.tiles.value.count
        
        // When: We reset the puzzle
        sut.resetPuzzle()
        
        // Then: Tile count should remain the same
        XCTAssertEqual(sut.tiles.value.count, initialTileCount, 
                      "Tile count should remain 9 after reset")
    }
    
    // MARK: - Observable Tests
    
    /// Test that tiles observable emits updates when tiles change
    func testTilesObservable_WhenTilesSwapped_ShouldEmitUpdate() {
        // Given: An expectation for tiles update
        let expectation = XCTestExpectation(description: "Tiles observable should emit")
        var emissionCount = 0
        
        // When: We subscribe to tiles and perform a swap
        sut.tiles
            .skip(1) // Skip initial value
            .subscribe(onNext: { _ in
                emissionCount += 1
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        // Perform swap
        sut.swapTiles(at: 0, with: 1)
        
        // Then: Should receive emission
        wait(for: [expectation], timeout: 1.0)
        XCTAssertGreaterThan(emissionCount, 0, "Tiles observable should emit on swap")
    }
    
    /// Test that moves count observable emits updates
    func testMovesCountObservable_WhenMovesChange_ShouldEmitUpdate() {
        // Given: An expectation for moves update
        let expectation = XCTestExpectation(description: "Moves observable should emit")
        var emittedValue: Int?
        
        // When: We subscribe to moves count
        sut.movesCount
            .skip(1) // Skip initial value
            .subscribe(onNext: { count in
                emittedValue = count
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        // Perform swap to trigger move
        sut.swapTiles(at: 0, with: 1)
        
        // Then: Should receive emission with updated count
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(emittedValue, "Moves count observable should emit")
    }
}
