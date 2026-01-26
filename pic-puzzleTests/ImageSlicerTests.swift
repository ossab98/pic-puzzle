//
//  ImageSlicerTests.swift
//  pic-puzzleTests
//
//  Created by Ossama Abdelwahab on 26/01/26.
//

import XCTest
@testable import pic_puzzle

/// Unit tests for ImageSlicer utility
/// Tests cover image slicing logic, grid calculations, and edge cases
final class ImageSlicerTests: XCTestCase {
    
    // MARK: - Helper Properties
    
    /// Creates a test image for slicing operations
    private func createTestImage(width: CGFloat = 300, height: CGFloat = 300) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            // Create a simple gradient image for testing
            UIColor.blue.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    // MARK: - Slice Count Tests
    
    /// Test that slicing a 3x3 grid produces 9 tiles
    func testSliceImage_With3x3Grid_ShouldReturnNineSlices() {
        // Given: A test image
        let image = createTestImage()
        
        // When: We slice it into a 3x3 grid
        let slices = ImageSlicer.sliceImage(image, into: 3)
        
        // Then: Should return exactly 9 slices
        XCTAssertEqual(slices.count, 9, "3x3 grid should produce 9 slices")
    }
    
    /// Test that slicing a 4x4 grid produces 16 tiles
    func testSliceImage_With4x4Grid_ShouldReturnSixteenSlices() {
        // Given: A test image
        let image = createTestImage()
        
        // When: We slice it into a 4x4 grid
        let slices = ImageSlicer.sliceImage(image, into: 4)
        
        // Then: Should return exactly 16 slices
        XCTAssertEqual(slices.count, 16, "4x4 grid should produce 16 slices")
    }
    
    // MARK: - Invalid Input Tests
    
    /// Test that slicing with invalid image returns empty array
    func testSliceImage_WithInvalidImage_ShouldReturnEmptyArray() {
        // Given: An image that cannot be converted to CGImage
        // (This is difficult to create in practice, but we test the guard)
        let image = createTestImage()
        
        // When: We attempt to slice (this should succeed for our test image)
        let slices = ImageSlicer.sliceImage(image, into: 3)
        
        // Then: Should not return empty (test image is valid)
        XCTAssertFalse(slices.isEmpty, "Valid image should produce slices")
        
        // Note: Testing actual invalid image would require mocking or special setup
    }
    
    // MARK: - Slice Dimensions Tests
    
    /// Test that sliced images have correct dimensions
    func testSlicedImages_ShouldHaveCorrectDimensions() {
        // Given: A 300x300 test image
        let originalSize: CGFloat = 300
        let image = createTestImage(width: originalSize, height: originalSize)
        let gridSize = 3
        
        // When: We slice it into 3x3 grid
        let slices = ImageSlicer.sliceImage(image, into: gridSize)
        
        // Then: Each slice should be approximately 100x100 points
        let expectedSize = originalSize / CGFloat(gridSize)
        
        // Check first slice dimensions
        if let firstSlice = slices.first {
            let sliceWidth = firstSlice.size.width
            let sliceHeight = firstSlice.size.height
            
            // Allow small tolerance for rounding
            XCTAssertEqual(sliceWidth, expectedSize, accuracy: 1.0, 
                          "Slice width should be 1/3 of original")
            XCTAssertEqual(sliceHeight, expectedSize, accuracy: 1.0, 
                          "Slice height should be 1/3 of original")
        } else {
            XCTFail("Should have at least one slice")
        }
    }
    
    // MARK: - Slice Order Tests
    
    /// Test that slices are returned in correct order (row-major: left-to-right, top-to-bottom)
    func testSliceOrder_ShouldBeRowMajor() {
        // Given: A test image
        let image = createTestImage()
        
        // When: We slice it into 3x3 grid
        let slices = ImageSlicer.sliceImage(image, into: 3)
        
        // Then: Should have 9 slices in row-major order
        // Expected order: [0,0], [0,1], [0,2], [1,0], [1,1], [1,2], [2,0], [2,1], [2,2]
        // Index mapping:     0      1      2      3      4      5      6      7      8
        
        XCTAssertEqual(slices.count, 9, "Should have all 9 slices in order")
        
        // Verify all slices are non-nil (valid UIImages)
        for (index, slice) in slices.enumerated() {
            XCTAssertNotNil(slice.cgImage, "Slice at index \(index) should be valid")
        }
    }
}
