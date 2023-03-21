//
//  UIImage.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/23.
//

import Foundation
import UIKit

extension UIImage {
    

    public static func gradientImage(frame: CGRect, colors: CGColor...) -> UIImage? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = colors
        //由左而右漸層
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let gradientView = UIView(frame: frame)
        gradientView.layer.addSublayer(gradientLayer)
        
        return gradientView.asImage()
    }
}
