//
//  UIView.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/23.
//

import Foundation
import UIKit

extension UIView {
    
    /// 將 View 蓋上圓角
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func asImage() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            var gradientImage: UIImage?
            UIGraphicsBeginImageContext(self.frame.size)
            
            if let context = UIGraphicsGetCurrentContext() {
                self.layer.render(in: context)
                gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
            }
            UIGraphicsEndImageContext()
            return gradientImage
        }
    }
}
