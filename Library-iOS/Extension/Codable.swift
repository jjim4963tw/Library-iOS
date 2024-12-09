//
//  Codable.swift
//  Library-iOS
//
//  Created by Jim Huang on 2024/12/9.
//

import Foundation

extension Encodable {
    /// Model to Json Dictionary
    /// - Returns: Dictionary
    var json2Dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    /// Model to Json String
    var model2JsonString: String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
