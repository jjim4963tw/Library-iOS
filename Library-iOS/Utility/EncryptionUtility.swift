//
//  EncryptionUtility.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/22.
//

import Foundation
import CommonCrypto


class EncryptionUtility: NSObject {
    
    /// 取得 PKCE 的 CodeVerifier
    /// - Returns: CodeVerifier
    func getPKCECodeVerifier() -> String {
        var buffer = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        let verifier = Data(buffer).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        return verifier
    }
    
    /// 取的 PKCE 的 CodeChallenge
    /// - Parameter codeVerifier: getPKCECodeVerifier() return value
    /// - Returns: CodeChallenge
    func getPKCECodeChallenge(codeVerifier: String) -> String {
        // Dependency: Apple Common Crypto library
        // http://opensource.apple.com//source/CommonCrypto
        guard let data = codeVerifier.data(using: .utf8) else { return "" }
        var buffer = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))

        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &buffer)
        }
        
        let hash = Data(buffer)
        let challenge = hash.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        return challenge
    }
}
