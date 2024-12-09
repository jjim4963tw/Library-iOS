//
//  Date.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/23.
//

import Foundation

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    /// 取得現在月份第一天的 Date
    /// - Parameter identifier: [Calendar.Identifier] 日曆型態
    /// - Returns: [Date]
    func startOfMonth(identifier: Calendar.Identifier? = nil) -> Date? {
        if let _identifier = identifier {
            let component = Calendar(identifier: _identifier).dateComponents([.month, .year], from: self)
            return Calendar.current.date(from: component)
        } else {
            let component = Calendar.current.dateComponents([.month, .year], from: self)
            return Calendar.current.date(from: component)
        }
    }
    
    /// 取得現在月份最後一天的 Date
    /// - Parameter identifier: [Calendar.Identifier] 日曆型態
    /// - Returns: [Date]
    func endOfMonth(identifier: Calendar.Identifier? = nil) -> Date? {
        if let startMonth = self.startOfMonth(identifier: identifier) {
            let components = DateComponents(month: 1, second: -1)
            
            if let _identifier = identifier {
                return Calendar(identifier: _identifier).date(byAdding: components, to: startMonth)
            } else {
                return Calendar.current.date(byAdding: components, to: startMonth)
            }
        }
        
        return nil
    }
}
