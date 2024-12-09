//
//  UICollectionView.swift
//  Library-iOS
//
//  Created by Jim Huang on 2024/12/9.
//

import UIKit

extension UICollectionView {
    /// scrollToItem to not work when paging is enabled for iOS 14
    /// Source: https://developer.apple.com/forums/thread/663156
    /// - Parameters:
    ///   - indexPath: IndexPath
    ///   - scrollPosition: UICollectionView.ScrollPosition
    ///   - animated: Bool
    func scrollToItemFix(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        self.isPagingEnabled = false
        self.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        self.isPagingEnabled = true
    }
}
