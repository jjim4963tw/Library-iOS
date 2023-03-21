//
//  Bundle.swift
//  Library-iOS
//
//  Created by jim on 2021/10/1.
//

import Foundation
import UIKit

extension Bundle {
    public var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
           let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
           let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
    
    public func getPlist(name: String) -> [String: AnyObject]? {
        guard let path = self.path(forResource: name, ofType: "plist") else { return nil }
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url, options: .mappedIfSafe)
        
        guard let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String: AnyObject] else { return nil }

        return plist
    }
}
