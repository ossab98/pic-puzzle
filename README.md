# 🧩 TileSwap - iOS Puzzle Game

<p align="center">
  <img src="https://img.shields.io/badge/iOS-15.6+-blue.svg" alt="iOS 15.6+">
  <img src="https://img.shields.io/badge/Swift-5.0-orange.svg" alt="Swift 5.0">
  <img src="https://img.shields.io/badge/Xcode-16.2-blue.svg" alt="Xcode 16.2">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License MIT">
</p>

A classic sliding tile puzzle game for iOS where players arrange scrambled image tiles to recreate the original picture. Built with Swift, UIKit, and RxSwift following MVVM architecture.

## 📱 Features

- **3x3 Puzzle Grid**: 9 tiles to arrange into the correct order
- **Image Preview**: Shows the complete image for 5 seconds before gameplay
- **Smart Tile Locking**: Tiles automatically lock when placed in correct positions
- **Adjacency Validation**: Only adjacent tiles can be swapped (horizontally or vertically)
- **Moves Counter**: Track your progress with a real-time moves counter
- **Drag & Drop**: Intuitive drag-and-drop gesture for swapping tiles
- **Adaptive Layout**: Responsive UI that works in portrait and landscape orientations
- **Random Image Selection**: 23 built-in images for variety
- **Completion Detection**: Celebration alert when puzzle is solved

## 🎮 How to Play

1. **Launch**: App starts by loading a random image
2. **Preview**: Memorize the complete image (shown for 5 seconds)
3. **Solve**: Drag tiles to swap adjacent pieces
4. **Win**: Arrange all tiles to recreate the original image
5. **New Puzzle**: Tap "New Puzzle" to start over with a new image

## 🏗️ Architecture

### MVVM Pattern

```
View (UIViewController)
    ↓
ViewModel (HomeViewModel)
    ↓
Model (PuzzleGame, Tile)
```

### Key Components

#### **Models**

- **`Tile`**: Represents a single puzzle piece with position tracking and lock state
- **`PuzzleGame`**: Core game logic managing tile swapping, validation, and completion

#### **Views**

- **`HomeViewController`**: Main game screen with grid, labels, and button
- **`PuzzleGridView`**: Custom 3x3 grid container for tile arrangement
- **`TileView`**: Individual tile UI with image and lock indicator

#### **ViewModels**

- **`HomeViewModel`**: Manages game state, observables, and business logic using RxSwift

#### **Utilities**

- **`ImageSlicer`**: Splits images into 9 equal tiles for the puzzle
- **`ImageLoader`**: Handles random image selection from assets

## 🛠️ Technologies

- **Language**: Swift 5.0
- **UI Framework**: UIKit (Auto Layout, programmatic UI)
- **Reactive Programming**: RxSwift 6.10.0
  - RxCocoa for UI bindings
  - RxRelay for state management
  - RxTest for unit testing
- **Architecture**: MVVM (Model-View-ViewModel)
- **Minimum iOS**: 15.6
- **Development**: Xcode 16.2

## 📦 Project Structure

```
pic-puzzle/
├── AppDelegate.swift                 # App lifecycle
├── SceneDelegate.swift               # Scene management
├── Home/
│   ├── View/
│   │   ├── HomeViewController.swift  # Main game screen
│   │   └── HomeViewController.xib    # Interface layout
│   ├── ViewModel/
│   │   └── HomeViewModel.swift       # Game logic & state
│   └── Model/
│       └── Tile.swift                # Tile data model
├── Manager/
│   └── PuzzleGame.swift              # Core game engine
├── Components/
│   ├── PuzzleGridView/
│   │   └── PuzzleGridView.swift     # 3x3 grid container
│   └── TileView/
│       └── TileView.swift            # Single tile UI
├── Utilities/
│   ├── ImageSlicer.swift             # Image slicing logic
│   ├── ImageLoader.swift             # Asset loading
│   └── Extension.swift               # Helper extensions
├── Assets.xcassets/                  # Images and colors
└── View/
    └── Base.lproj/
        ├── LaunchScreen.storyboard   # Splash screen
        └── Main.storyboard           # App storyboard

pic-puzzleTests/
├── PuzzleGameTests.swift             # Core game logic tests
├── TileTests.swift                   # Tile model tests
├── HomeViewModelTests.swift          # ViewModel tests
├── ImageSlicerTests.swift            # Utility tests
└── README.md                         # Test documentation
```

## 🚀 Getting Started

### Prerequisites

- macOS 14.0 or later
- Xcode 16.2 or later
- iOS 15.6+ device or simulator

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/ossab98/pic-puzzle.git
cd pic-puzzle
```

2. **Open in Xcode**

```bash
open pic-puzzle.xcodeproj
```

3. **Install dependencies**
   - Dependencies are managed via Swift Package Manager
   - Xcode will automatically resolve RxSwift packages on first build

4. **Build and run**
   - Select a simulator or device
   - Press `⌘ + R` to build and run

## 🧪 Testing

### Run Tests

```bash
# From Xcode: Press ⌘ + U

# From terminal:
xcodebuild test -project pic-puzzle.xcodeproj -scheme pic-puzzle \
  -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

### Test Coverage

- **PuzzleGameTests**: Core game logic (initialization, swapping, validation)
- **TileTests**: Tile model properties and states
- **HomeViewModelTests**: ViewModel with RxSwift observables
- **ImageSlicerTests**: Image slicing utility

See [`pic-puzzleTests/README.md`](pic-puzzleTests/README.md) for detailed test documentation.

## 🎯 Game Logic

### Tile Swapping Rules

1. **Adjacency**: Only horizontally or vertically adjacent tiles can swap
2. **Lock State**: Tiles in correct positions are locked and can't move
3. **Position Tracking**: Each tile knows its current and correct position
4. **Auto-Lock**: Tiles automatically lock when placed correctly

### Grid Layout (3x3)

```
┌───┬───┬───┐
│ 0 │ 1 │ 2 │
├───┼───┼───┤
│ 3 │ 4 │ 5 │
├───┼───┼───┤
│ 6 │ 7 │ 8 │
└───┴───┴───┘
```

### Adjacency Examples

- **Valid swaps**: 0↔1, 0↔3, 4↔5, 4↔7 (adjacent)
- **Invalid swaps**: 0↔8, 0↔5, 1↔6 (not adjacent)

## 📐 Responsive Design

The app uses **Auto Layout** with adaptive constraints:

- **Portrait & Landscape**: Layouts adjust automatically
- **All Device Sizes**: Works on iPhone and iPad
- **Safe Areas**: Respects notches and home indicators
- **Dynamic Sizing**: Grid scales based on screen size

## 🎨 UI/UX Features

- **Visual Feedback**
  - Green border on locked tiles
  - Smooth animations for tile movements
  - Loading spinner during image processing

- **State Management**
  - Default state (initial)
  - Loading state (fetching image)
  - Preview state (showing complete image)
  - Ready state (gameplay active)
  - Completed state (puzzle solved)
  - Error state (loading failed)

- **User Guidance**
  - Descriptive labels for each state
  - Completion celebration with alert
  - Move counter for tracking progress

## 🔧 Configuration

### Adding New Images

1. Add images to `Assets.xcassets/Images/`
2. Create new `.imageset` folder
3. Add `Contents.json` configuration
4. Update `ImageLoader.swift` with new image name

### Changing Grid Size

Modify `gridSize` constant in:

- `PuzzleGame.swift`
- `HomeViewModel.swift`
- Update UI constraints accordingly

## 📝 Code Quality

- **Swift Style Guide**: Follows Apple's Swift conventions
- **Documentation**: Comprehensive inline comments
- **MARK Comments**: Clear code organization
- **Type Safety**: Explicit types where beneficial
- **Memory Management**: Weak references to prevent retain cycles
- **Error Handling**: Graceful error states and recovery

## 🐛 Known Issues

- None currently reported

## 🚧 Future Enhancements

- [ ] Multiple difficulty levels (4x4, 5x5 grids)
- [ ] Timer and high score tracking
- [ ] Custom image selection from photo library
- [ ] Hint system
- [ ] Sound effects and haptic feedback
- [ ] Game Center integration for leaderboards
- [ ] Dark mode support
- [ ] Accessibility improvements (VoiceOver)

## 👨‍💻 Author

**Ossama Abdelwahab**

- 📧 Email: [ossab98@gmail.com](mailto:ossab98@gmail.com)
- 💼 LinkedIn: [linkedin.com/in/ossab98](https://www.linkedin.com/in/ossab98/)
- 🐙 GitHub: [@ossab98](https://github.com/ossab98)
- 📍 Location: Milan, Italy

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- RxSwift community for reactive programming support
- Apple for UIKit and development tools
- Inspiration from classic sliding puzzle games

---

**Built with ❤️ using Swift and UIKit**
