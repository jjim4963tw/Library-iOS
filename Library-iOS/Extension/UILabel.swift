//
//  UILabel.swift
//  Library-iOS
//
//  Created by Jim Huang on 2024/12/9.
//

import UIKit

extension UILabel {
    /// 計算 UILabel 中文字的行數
    /// - Returns: [Int]
    func countLabelLines() -> Int {
        // Call self.layoutIfNeeded() if your view is uses auto layout
        self.layoutIfNeeded()
        
        guard let myText = self.text as? NSString else {
            return 0
        }
        
        let attributes = [NSAttributedString.Key.font : self.font]
        let labelSize = myText.boundingRect(with: CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude),
                                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                            attributes: attributes as [NSAttributedString.Key : Any],
                                            context: nil)
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
    
    /// 計算是否超出（顯示…)
    /// - Returns: [Bool]
    func isTruncated() -> Bool {
        guard numberOfLines > 0 else { return false }
        return self.countLabelLines() > numberOfLines
    }
}
