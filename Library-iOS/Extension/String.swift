//
//  String.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/22.
//

import Foundation

extension String {
    
    /// 根據 Key 取得對應多語文案
    /// - Parameter key: 多語 Key
    /// - Returns: 對應文案
    public static func localized(key: String) -> String {
        return Foundation.NSLocalizedString(key, tableName: "InfoPlist", bundle: Bundle.main, value: "", comment: "")
    }
    
    /// 根據 Key 取得對應多語文案，並加上參數(Format)
    /// - Parameters:
    ///   - key: 多語 Key
    ///   - arguments: 內容參數
    /// - Returns: 組合好的對應文案
    public static func localizedWithFromat(key: String, arguments: String...) -> String {
        return String.init(format: localized(key: key), arguments: arguments)
    }

    
    /// 刪除字串中多餘的空白
    /// - Returns: 刪除多餘空白的文案
    func removeExtraSpaces() -> String {
        return self.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil).replacingOccurrences(of: " ", with: "")
    }

    
    
    
    /// 解析回傳回來的 URL Parameter
    ///
    /// ex.
    /// &aaa=xxx&bbb=ccc...
    ///
    /// - Returns: 回傳 Dictionary ，其中包含 key-value
    func parseURLSchemeQueryString() -> [String: Any] {
        var dict = [String: String]()
        let pairs = self.components(separatedBy: "&")
        
        for pair in pairs {
            let element = pair.components(separatedBy: "=")
            let key = element[0].removingPercentEncoding
            let value = element[1].removingPercentEncoding

            dict.updateValue(value!, forKey: key!)
        }
        
        return dict
    }
    
}
