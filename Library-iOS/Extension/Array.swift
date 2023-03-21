//
//  Array.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/22.
//

import Foundation

extension Array {
    
    /// 亂數排序
    mutating func shuffle() {
        for i in stride(from: count - 1, to: 0, by: -1) {
            swapAt(i, Int(arc4random_uniform(UInt32(i + 1))))
        }
    }
}
