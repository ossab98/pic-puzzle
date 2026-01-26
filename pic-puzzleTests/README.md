# pic-puzzle Unit Tests

This directory contains comprehensive unit tests for the pic-puzzle iOS application.

## Test Files

### 1. **PuzzleGameTests.swift**

Tests the core game logic (`PuzzleGame` class):

- ✅ Initialization with 9 tiles
- ✅ Tile shuffling on startup
- ✅ Tile access with valid/invalid indices
- ✅ Swap validation (adjacent vs non-adjacent tiles)
- ✅ Swap operations and position updates
- ✅ Lock state management

**Key Tests:**

- `testPuzzleGame_WhenInitialized_ShouldHaveNineTiles()` - Verifies 3x3 grid
- `testCanSwapTiles_WithNonAdjacentTiles_ShouldReturnFalse()` - Validates adjacency rules
- `testSwapTiles_WhenExecuted_ShouldSwapTilePositions()` - Confirms swap logic

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
- ✅ Tile management
- ✅ Swap operations and moves counter
- ✅ Reset functionality
- ✅ RxSwift observables (tiles, movesCount)

**Key Tests:**

- `testSwapTiles_WithAdjacentTiles_ShouldIncrementMovesCount()` - Move tracking
- `testTilesObservable_WhenTilesSwapped_ShouldEmitUpdate()` - Reactive behavior
- `testResetPuzzle_ShouldResetMovesAndCreateNewPuzzle()` - State reset

### 4. **ImageSlicerTests.swift**

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
- **Game Logic**: `PuzzleGame` class (90%+)
- **View Models**: `HomeViewModel` (key functionality)
- **Utilities**: `ImageSlicer` (core slicing logic)

## Test Patterns Used

### Given-When-Then

All tests follow the **Given-When-Then** pattern for clarity:

```swift
func testExample() {
    // Given: Setup preconditions
    let sut = PuzzleGame()

    // When: Perform action
    let result = sut.canSwapTiles(at: 0, with: 1)

    // Then: Verify outcome
    XCTAssertTrue(result)
}
```

### Clear Test Names

Test names follow `test_Condition_ShouldExpectedBehavior` convention:

- `testPuzzleGame_WhenInitialized_ShouldHaveNineTiles`
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

- Tests use mock/test data where appropriate
- Some tests account for randomization (tile shuffling)
- Observable tests use expectations for async behavior
- All tests are isolated and can run in any order
