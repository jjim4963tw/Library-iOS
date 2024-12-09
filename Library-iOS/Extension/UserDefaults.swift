//
//  UserDefaults.swift
//  Library-iOS
//
//  Created by Jim Huang on 2024/12/9.
//

import Foundation

extension UserDefaults {
    public static func setUserDefaults(_ data: Any?, key: String) {
        self.standard.set(data, forKey: key)
        self.standard.synchronize()
    }
    
    public static func getUserDefaults(key: String) -> Any? {
        return self.standard.object(forKey: key)
    }
    
    public static func getUserDefaultsAllData() -> [String : Any]? {
        return self.standard.dictionaryRepresentation()
    }
    
    public static func removeUserDefaults(key: String) {
        self.standard.removeObject(forKey: key)
        self.standard.synchronize()
    }
}
