//
//  ImageSlicer.swift
//  pic-puzzle
//
//  Created by Ossama Abdelwahab on 23/01/26.
//

import UIKit

// MARK: - ImageSlicer

/// Utility class for slicing images into grid-based puzzle pieces
/// Divides a source image into equal-sized rectangular tiles for puzzle game
class ImageSlicer {
    
    // MARK: - Public Methods
    
    /// Slices an image into a grid of equal-sized tiles
    /// Returns tiles in row-major order (left-to-right, top-to-bottom)
    /// - Parameters:
    ///   - image: The source image to slice into puzzle pieces
    ///   - gridSize: Number of tiles per row/column (default 3 for 3x3 grid = 9 tiles)
    /// - Returns: Array of sliced images in grid order, empty array if image cannot be processed
    static func sliceImage(_ image: UIImage, into gridSize: Int = 3) -> [UIImage] {
        guard let cgImage = image.cgImage else { return [] }
        
        // Calculate dimensions for each tile piece
        let width = CGFloat(cgImage.width) / CGFloat(gridSize)
        let height = CGFloat(cgImage.height) / CGFloat(gridSize)
        
        var slices: [UIImage] = []
        
        // Crop image into tiles row by row, left to right
        // Result order: [0,0], [0,1], [0,2], [1,0], [1,1], [1,2], [2,0], [2,1], [2,2]
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                // Calculate crop rectangle for this tile
                let x = CGFloat(col) * width
                let y = CGFloat(row) * height
                
                let rect = CGRect(x: x, y: y, width: width, height: height)
                
                // Crop the CGImage and create UIImage while preserving scale and orientation
                if let croppedCGImage = cgImage.cropping(to: rect) {
                    let slice = UIImage(cgImage: croppedCGImage, scale: image.scale, orientation: image.imageOrientation)
                    slices.append(slice)
                }
            }
        }
        
        return slices
    }
}
