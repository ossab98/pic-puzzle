//
//  Extension.swift
//  pic-puzzle
//
//  Created by Ossama Abdelwahab on 23/01/26.
//

import UIKit

extension UIStackView {
    public func addArrangedSubviews(_ views: [UIView?]) {
        views.forEach { if let view = $0 { addArrangedSubview(view) } }
    }
}

extension Collection {
    public var isNotEmpty: Bool { !isEmpty }
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
