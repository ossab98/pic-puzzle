//
//  TileView.swift
//  pic-puzzle
//
//  Created by Ossama Abdelwahab on 23/01/26.
//

import UIKit

// MARK: - TileView

/// Custom UIView representing a single puzzle tile with image, border, and lock state indicator
/// Displays puzzle piece image and provides visual feedback for locked state (green border/overlay)
class TileView: UIView {
    
    // MARK: - UI Components
    
    /// Image view displaying the puzzle piece image
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    /// Semi-transparent green overlay shown when tile is locked in correct position
    private let lockedIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
        view.isHidden = true
        return view
    }()
    
    // MARK: - Public Properties
    
    /// The tile model containing position and state data
    var tile: Tile?
    
    /// Current index position in the grid (0-8 for 3x3 grid)
    var index: Int = 0
    
    /// Lock state indicating whether tile is in correct position and cannot be moved
    /// When locked, displays green border and semi-transparent overlay
    var isLocked: Bool = false {
        didSet {
            lockedIndicator.isHidden = !isLocked
            if isLocked {
                layer.borderColor = UIColor.systemGreen.cgColor
                layer.borderWidth = 3
            } else {
                layer.borderColor = UIColor.systemGray4.cgColor
                layer.borderWidth = 1
            }
        }
    }
    
    // MARK: - Initialization
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup
    
    /// Configures the tile view appearance and sets up subviews with auto layout constraints
    /// Sets up border, corner radius, background color, and positions image and lock indicator
    private func setupViews() {
        backgroundColor = .systemGray6
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addSubview(imageView)
        addSubview(lockedIndicator)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        lockedIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Image view fills entire tile
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Lock indicator overlays entire tile
            lockedIndicator.topAnchor.constraint(equalTo: topAnchor),
            lockedIndicator.leadingAnchor.constraint(equalTo: leadingAnchor),
            lockedIndicator.trailingAnchor.constraint(equalTo: trailingAnchor),
            lockedIndicator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Public Methods
    
    /// Updates the tile with new image, tile data, and position index
    /// - Parameters:
    ///   - image: The puzzle piece image to display (optional)
    ///   - tile: The tile model containing position and state data
    ///   - index: The current grid position index
    func configure(with image: UIImage?, tile: Tile, index: Int) {
        self.imageView.image = image
        self.tile = tile
        self.index = index
        self.isLocked = tile.isLocked
    }
    
    /// Provides visual feedback during drag-and-drop interaction
    /// Applies opacity and scale transform to indicate tile is being dragged
    /// - Parameter highlighted: True to show highlighted state, false to return to normal
    func setHighlighted(_ highlighted: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.alpha = highlighted ? 0.6 : 1.0
            self.transform = highlighted ? CGAffineTransform(scaleX: 1.05, y: 1.05) : .identity
        }
    }
}
