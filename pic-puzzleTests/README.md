# pic-puzzle Unit Tests

This directory contains comprehensive unit tests for the pic-puzzle iOS application.

## Test Files

### 1. **PuzzleGameTests.swift**

Tests the core game logic (`PuzzleGame` singleton class):

- ✅ Singleton pattern with shared instance
- ✅ Dynamic grid initialization based on `GameConfiguration`
- ✅ Tile shuffling on startup and reset
- ✅ Tile access with valid/invalid indices
- ✅ Swap operations and position updates
- ✅ Lock state management
- ✅ Game reset without creating new instances

**Key Tests:**

- `testPuzzleGame_WhenInitialized_ShouldHaveCorrectNumberOfTiles()` - Verifies dynamic grid size
- `testSwapTiles_WhenExecuted_ShouldSwapTilePositions()` - Confirms swap logic
- Uses `PuzzleGame.shared` with `resetGame()` for clean test state

### 2. **TileTests.swift**

Tests the `Tile` model:

- ✅ Property initialization
- ✅ `isInCorrectPosition` computed property
- ✅ Lock state management
- ✅ Equality comparisons
- ✅ Mutable properties (currentPosition, isLocked)

**Key Tests:**

- `testTile_WhenInCorrectPosition_IsInCorrectPositionShouldBeTrue()` - Position validation
- `testTile_WhenLockStateChanged_ShouldUpdateCorrectly()` - State mutation

### 3. **HomeViewModelTests.swift**

Tests the view model layer (`HomeViewModel` with RxSwift):

- ✅ Initialization state
- ✅ Tile management with singleton PuzzleGame
- ✅ Swap operations and moves counter
- ✅ Reset functionality using `resetGame()`
- ✅ RxSwift observables (tiles, movesCount)
- ✅ Integration with PuzzleGame singleton

**Key Tests:**

- `testSwapTiles_WithAdjacentTiles_ShouldIncrementMovesCount()` - Move tracking
- `testTilesObservable_WhenTilesSwapped_ShouldEmitUpdate()` - Reactive behavior
- `testResetPuzzle_ShouldResetMovesAndCreateNewPuzzle()` - State reset with singleton

### 4. **GameConfigurationTests.swift**

Tests the dynamic grid configuration system:

- ✅ Grid size validation (positive integer)
- ✅ Total tiles calculation (gridSize²)
- ✅ PuzzleGame integration with configuration
- ✅ Valid tile position ranges
- ✅ Different grid sizes (3x3→9, 4x4→16, 5x5→25, 6x6→36)
- ✅ Edge cases (minimum 2x2, reasonable bounds)

**Key Tests:**

- `testGameConfiguration_TotalTiles_ShouldEqualGridSizeSquared()` - Calculation verification
- `testPuzzleGame_AllTiles_ShouldHaveValidPositions()` - Integration test
- `testGameConfiguration_DifferentGridSizes_ShouldProduceCorrectTotalTiles()` - Multiple grid sizes

### 5. **ImageSlicerTests.swift**

Tests the image slicing utility (`ImageSlicer`):

- ✅ Correct slice count for different grid sizes
- ✅ Slice dimensions match expected sizes
- ✅ Row-major ordering (left-to-right, top-to-bottom)
- ✅ Invalid input handling

**Key Tests:**

- `testSliceImage_With3x3Grid_ShouldReturnNineSlices()` - Grid validation
- `testSlicedImages_ShouldHaveCorrectDimensions()` - Size accuracy

## Running Tests

### From Xcode

1. Open `pic-puzzle.xcodeproj`
2. Press `⌘ + U` to run all tests
3. View results in Test Navigator (⌘ + 6)

### From Command Line

```bash
# Run all tests
xcodebuild test -project pic-puzzle.xcodeproj -scheme pic-puzzle \
  -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16 Pro'

# Run specific test class
xcodebuild test -project pic-puzzle.xcodeproj -scheme pic-puzzle \
  -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  -only-testing:pic-puzzleTests/PuzzleGameTests
```

## Test Coverage

Current test coverage includes:

- **Models**: `Tile` struct (100%)
- **Game Logic**: `PuzzleGame` singleton class (90%+)
- **Configuration**: `GameConfiguration` enum (100%)
- **View Models**: `HomeViewModel` (key functionality with singleton integration)
- **Utilities**: `ImageSlicer` (core slicing logic with dynamic grid support)

## Test Patterns Used

### Given-When-Then

All tests follow the **Given-When-Then** pattern for clarity:

```swift
func testExample() {
    // Given: Setup preconditions with singleton
    let sut = PuzzleGame.shared
    sut.resetGame() // Ensure clean state

    // When: Perform action
    let result = sut.canSwapTiles(at: 0, with: 1)

    // Then: Verify outcome
    XCTAssertTrue(result)
}
```

### Clear Test Names

Test names follow `test_Condition_ShouldExpectedBehavior` convention:

- `testPuzzleGame_WhenInitialized_ShouldHaveCorrectNumberOfTiles`
- `testGameConfiguration_TotalTiles_ShouldEqualGridSizeSquared`
- `testSwapTiles_WithAdjacentTiles_ShouldIncrementMovesCount`

### Descriptive Comments

Each test includes comments explaining:

- What is being tested (Given)
- What action is performed (When)
- What the expected result is (Then)

## Dependencies

- **XCTest**: Apple's testing framework
- **RxSwift**: For testing reactive components
- **RxTest**: TestScheduler for testing observables

## Notes

- Tests use `PuzzleGame.shared` singleton with `resetGame()` for clean state
- Grid size is configurable via `GameConfiguration.gridSize`
- Tests are grid-size agnostic and adapt to configuration changes
- Some tests account for randomization (tile shuffling)
- Observable tests use expectations for async behavior
- All tests are isolated and can run in any order
