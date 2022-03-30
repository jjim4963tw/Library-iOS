//
//  UINavigationBar.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/23.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    func setNavigationBarTheme() {
        if #available(iOS 15.0, *) {
            let appearence = UINavigationBarAppearance()
            appearence.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearence.configureWithOpaqueBackground()
            
            if let image = UIImage.gradientImage(frame: self.bounds, colors: UIColor.red.cgColor, UIColor.blue.cgColor) {
                appearence.backgroundImage = image
            } else {
                appearence.backgroundColor = .blue
            }

            self.standardAppearance = appearence
            self.scrollEdgeAppearance = appearence
        } else {
            self.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            
            if let image = UIImage.gradientImage(frame: self.bounds, colors: UIColor.red.cgColor, UIColor.blue.cgColor) {
                setBackgroundImage(image, for: .default)
            } else {
                self.barTintColor = .blue
            }
        }
    }
}
