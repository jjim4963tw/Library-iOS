//
//  FileManager.swift
//  Library-iOS
//
//  Created by Jim Huang on 2023/3/23.
//

import Foundation

extension FileManager {
    public static func getFileSize(at url: URL) -> Int64? {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            return attributes[.size] as? Int64
        } catch {
            print("Error getting file size: \(error.localizedDescription)")
            return nil
        }
    }
}
