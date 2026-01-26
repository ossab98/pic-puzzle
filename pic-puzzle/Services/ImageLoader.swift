//
//  ImageLoader.swift
//  pic-puzzle
//
//  Created by Ossama Abdelwahab on 23/01/26.
//

import UIKit

// MARK: - ImageLoader

/// Service class for loading puzzle images from network or local assets
/// Implements fallback strategy: attempts network load first, then falls back to local assets
/// Singleton pattern ensures consistent image loading behavior across the app
class ImageLoader {
    
    // MARK: - Singleton
    
    /// Shared singleton instance for app-wide image loading
    static let shared = ImageLoader()
    
    /// Private initializer to enforce singleton pattern
    private init() {}
    
    // MARK: - Properties
    
    /// Remote URL for fetching random puzzle images from Picsum service
    private let imageURL = "https://picsum.photos/1024"
    
    /// Array of local asset names to use as fallback when network fails
    /// Contains 23 pre-bundled images for offline puzzle gameplay
    private let fallbackImageNames = [
        "pic1", "pic2", "pic3", "pic4", "pic5", "pic6", "pic7", "pic8",
        "pic9", "pic10", "pic11", "pic12", "pic13", "pic14", "pic15",
        "pic16", "pic17", "pic18", "pic19", "pic20"
    ]
    
    // MARK: - Public Methods
    
    /// Loads a puzzle image with automatic fallback strategy
    /// First attempts to fetch from network, then falls back to random local asset if network fails
    /// - Parameter completion: Callback with loaded image (always returns an image, never nil in practice)
    func loadPuzzleImage(completion: @escaping (UIImage?) -> Void) {
        // Attempt network load first for variety
        loadFromNetwork { [weak self] image in
            if let image = image {
                completion(image)
            } else {
                // Fallback to local asset if network unavailable
                completion(self?.loadLocalImage())
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Fetches an image from the remote URL using URLSession
    /// Handles network errors and data conversion gracefully
    /// - Parameter completion: Callback with fetched image, or nil if fetch fails
    private func loadFromNetwork(completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imageURL) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Validate data and convert to UIImage
            guard let data = data,
                  error == nil,
                  let image = UIImage(data: data) else {
                // Network failed: return nil to trigger fallback
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Success: return loaded image on main thread
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        task.resume()
    }
    
    /// Loads a random image from local asset catalog as fallback
    /// Ensures offline gameplay is always possible
    /// - Returns: A randomly selected local image, or nil if asset not found (rare)
    private func loadLocalImage() -> UIImage? {
        // Pick a random fallback image from bundled assets
        let randomImageName = fallbackImageNames.randomElement() ?? fallbackImageNames[0]
        return UIImage(named: randomImageName)
    }
}
