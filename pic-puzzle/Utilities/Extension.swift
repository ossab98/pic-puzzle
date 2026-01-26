//
//  Extension.swift
//  pic-puzzle
//
//  Created by Ossama Abdelwahab on 23/01/26.
//

import UIKit

// MARK: - Collection Extension

extension Collection {
    /// Safe array/collection subscript that returns nil instead of crashing on out-of-bounds access
    /// Prevents common index out of range crashes during array operations
    /// - Parameter index: The index to access safely
    /// - Returns: The element at the index if valid, nil otherwise
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - NSLayoutConstraint Extension

extension NSLayoutConstraint {
    /// Helper to set priority on constraint in a chainable way
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
