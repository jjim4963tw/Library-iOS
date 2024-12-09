//
//  UINavigationBar.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/23.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    /// 設定 NavigationBar 的 Style
    /// - Parameters:
    ///   - barStyle: UIBarStyle
    ///   - isAlpha: [Bool] 是否為透明背景
    ///   - removeShadow: [Bool] 是否需移除陰影
    ///   - backgroundColor: [UIColor] 背景色
    ///   - backgroundImage: [UIImage] 背景圖片
    ///   - tintColor: NavigationBar 的文字顏色
    ///   - textFont: [UIFont] 文字類型與大小
    ///   - textColor: [UIColor] 文字顏色
    func setBarStyle(barStyle: UIBarStyle = .default,
                     isAlpha: Bool = false,
                     removeShadow: Bool = false,
                     backgroundColor: UIColor? = nil,
                     backgroundImage: UIImage? = nil,
                     tintColor: UIColor = .black,
                     textColor: UIColor = .black,
                     textFont: UIFont = UIFont.boldSystemFont(ofSize: 16.0)) {
        self.isTranslucent = isAlpha
        self.barStyle = barStyle
        self.tintColor = tintColor
        
        if #available(iOS 13.0, *) {
            let appearance = self.standardAppearance.copy()
            
            // 是否為透明背景
            if (isAlpha) {
                appearance.configureWithTransparentBackground()
            } else {
                appearance.configureWithOpaqueBackground()
            }
            
            if (removeShadow) {
                appearance.shadowImage = nil
                appearance.shadowColor = nil
            }
            
            appearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: textColor,
                NSAttributedString.Key.font: textFont
            ]
            
            // 漸層：UIImage.gradientImage(frame: self.bounds, colors: UIColor.red.cgColor, UIColor.blue.cgColor)
            if let bgImage = backgroundImage {
                appearance.backgroundImage = bgImage
            } else if let bgColor = backgroundColor {
                appearance.backgroundColor = backgroundColor
            } else {
                appearance.backgroundColor = .white
            }
            
            self.standardAppearance = appearance;
            self.scrollEdgeAppearance = appearance;
        } else {
            // 是否為透明背景
            if (isAlpha) {
                let alphaImage = UIImage()
                self.setBackgroundImage(alphaImage, for: .default)
                self.shadowImage = alphaImage
                self.barTintColor = .white
            } else {
                // 漸層：UIImage.gradientImage(frame: self.bounds, colors: UIColor.red.cgColor, UIColor.blue.cgColor)
                if let bgImage = backgroundImage {
                    self.setBackgroundImage(bgImage, for: .default)
                } else if let bgColor = backgroundColor {
                    self.setBackgroundImage(nil, for: .default)
                    self.barTintColor = backgroundColor
                } else {
                    self.setBackgroundImage(nil, for: .default)
                    self.barTintColor = .white
                }
                
                if (removeShadow) {
                    self.shadowImage = nil
                }
            }
            
            self.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: textColor,
                NSAttributedString.Key.font: textFont
            ]
        }
    }
}
