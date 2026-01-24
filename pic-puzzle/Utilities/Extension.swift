//
//  Extension.swift
//  pic-puzzle
//
//  Created by Ossama Abdelwahab on 23/01/26.
//

import UIKit

// MARK: - UIStackView Extension

extension UIStackView {
    /// Adds multiple arranged subviews to the stack view in a single call
    /// Filters out nil views for convenience when conditionally adding views
    /// - Parameter views: Array of optional UIView instances to add to the stack
    public func addArrangedSubviews(_ views: [UIView?]) {
        views.forEach { if let view = $0 { addArrangedSubview(view) } }
    }
}

// MARK: - Collection Extension

extension Collection {
    /// Returns true if the collection contains at least one element
    /// More readable alternative to !isEmpty in conditional logic
    public var isNotEmpty: Bool { !isEmpty }
    
    /// Safe array/collection subscript that returns nil instead of crashing on out-of-bounds access
    /// Prevents common index out of range crashes during array operations
    /// - Parameter index: The index to access safely
    /// - Returns: The element at the index if valid, nil otherwise
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
