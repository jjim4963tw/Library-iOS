//
//  EncryptionUtility.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/22.
//

import Foundation
import CommonCrypto


class EncryptionManager: NSObject {
    static let sharedInstance = EncryptionManager()
    
    //MARK: - AES
    /// AES 128 EBC 加密
    /// - Parameters:
    ///   - secretKey: [String] AES 加密密鑰
    ///   - content: [String] 欲加密的內容
    /// - Returns: [String] 加密後的文字
    func AES128EBCEncrypt(secretKey: String, content: String) -> String? {
        guard let textData = content.data(using: .utf8), let keyData = secretKey.data(using: .utf8) else {
            return nil
        }
        
        let keyLength = keyData.count
        let dataLength = textData.count
        let bufferSize = dataLength + kCCBlockSizeAES128
        var buffer = Data(count: bufferSize)
        
        var numBytesProcessed: size_t = 0
        let status = buffer.withUnsafeMutableBytes { bufferBytes in
            textData.withUnsafeBytes { inputBytes in
                keyData.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(kCCEncrypt),              // kCCEncrypt or kCCDecrypt
                        CCAlgorithm(kCCAlgorithmAES), // Algorithm
                        CCOptions(kCCOptionECBMode | kCCOptionPKCS7Padding), // Options
                        keyBytes.baseAddress,   // Key pointer
                        keyLength,              // Key length
                        nil,                    // No IV for ECB mode
                        inputBytes.baseAddress, // Input data
                        dataLength,             // Input data length
                        bufferBytes.baseAddress, // Output buffer
                        bufferSize,             // Output buffer size
                        &numBytesProcessed      // Output data size
                    )
                }
            }
        }
        
        guard status == kCCSuccess else { return nil }
        return buffer.prefix(numBytesProcessed).base64EncodedString()
    }
    
    /// AES 256 EBC 加密
    /// - Parameters:
    ///   - secretKey: [String] AES 加密密鑰
    ///   - content: [String] 欲加密的內容
    /// - Returns: [String] 加密後的文字
    func AES256EBCEncrypt(secretKey: String, content: String) -> String? {
        guard let textData = content.data(using: .utf8), let keyData = secretKey.data(using: .utf8) else { return nil }
        
        let cryptLength = size_t(textData.count / kCCBlockSizeAES128 + 1) * kCCBlockSizeAES128
        var cryptData = Data(count: cryptLength)
        var numBytesEncrypted: size_t = 0
        
        let options = CCOptions(kCCOptionECBMode) | CCOptions(kCCOptionPKCS7Padding)
        let keyLength = size_t(kCCKeySizeAES256)
        
        let cryptStatus = keyData.withUnsafeBytes { keyUnsafeRawBufferPointer -> CCCryptorStatus in
            textData.withUnsafeBytes { dataUnsafeRawBufferPointer -> CCCryptorStatus in
                cryptData.withUnsafeMutableBytes { cryptDataUnsafeMutableRawBufferPointer -> CCCryptorStatus in
                    CCCrypt(
                        CCOperation(kCCEncrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        options,
                        keyUnsafeRawBufferPointer.baseAddress,
                        keyLength,
                        nil,
                        dataUnsafeRawBufferPointer.baseAddress,
                        textData.count,
                        cryptDataUnsafeMutableRawBufferPointer.baseAddress,
                        cryptLength,
                        &numBytesEncrypted
                    )
                }
            }
        }
        
        guard cryptStatus == kCCSuccess else { return nil }
        cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
        
        return cryptData.base64EncodedString()
    }
    
    /// AES256 CBC 加密
    /// - Parameters:
    ///   - key: (String) 加密的 Key
    ///   - iv: (String) 加密的偏移
    /// - Returns: String
    func AES256CBCEncrypt(secretKey: String, iv: String, content: String) -> String? {
        guard let textData = content.data(using: .utf8), let keyData = secretKey.data(using: .utf8), let ivData = iv.data(using: .utf8) else { return nil }
        
        let cryptLength = size_t(textData.count + kCCBlockSizeAES128)
        var cryptData = Data(count: cryptLength)
        var numBytesEncrypted: size_t = 0
        
        let options = CCOptions(kCCOptionPKCS7Padding)
        let keyLength = size_t(kCCKeySizeAES256)
        let ivLength = size_t(kCCBlockSizeAES128)
        
        let cryptStatus = keyData.withUnsafeBytes { keyUnsafeRawBufferPointer -> CCCryptorStatus in
            ivData.withUnsafeBytes { ivUnsafeRawBufferPointer -> CCCryptorStatus in
                textData.withUnsafeBytes { dataUnsafeRawBufferPointer -> CCCryptorStatus in
                    cryptData.withUnsafeMutableBytes { cryptDataUnsafeMutableRawBufferPointer -> CCCryptorStatus in
                        CCCrypt(
                            CCOperation(kCCEncrypt),
                            CCAlgorithm(kCCAlgorithmAES),
                            options,
                            keyUnsafeRawBufferPointer.baseAddress,
                            keyLength,
                            ivUnsafeRawBufferPointer.baseAddress,
                            dataUnsafeRawBufferPointer.baseAddress,
                            textData.count,
                            cryptDataUnsafeMutableRawBufferPointer.baseAddress,
                            cryptLength,
                            &numBytesEncrypted
                        )
                    }
                }
            }
        }
        
        guard cryptStatus == kCCSuccess else { return nil }
        cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
        
        return cryptData.base64EncodedString()
    }
    
    
    //MARK: - Hash
    /// SHA 256 - Hmac (Base64)
    /// - Parameters:
    ///   - secretKey: [String] 加密密鑰
    ///   - content: [String] 欲加密的內容
    /// - Returns: 加密字串
    func sha256Hmac(secretKey: String, content: String) -> String? {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        let mac = UnsafeMutablePointer<CChar>.allocate(capacity: digestLength)
        
        let cSecretKey: [CChar]? = secretKey.cString(using: .utf8)
        let cSecretKeyLength = secretKey.lengthOfBytes(using: .utf8)
        
        let cMessage: [CChar]? = content.cString(using: .utf8)
        let cMessageLength = content.lengthOfBytes(using: .utf8)
        
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), cSecretKey, cSecretKeyLength, cMessage, cMessageLength, mac)
        
        let macData = Data(bytes: mac, count: digestLength)
        
        return macData.base64EncodedString()
    }
    
    /// MD5
    /// - Parameter content: [String] 欲加密的內容
    /// - Returns: 加密字串
    func MD5(content: String) -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = content.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined().uppercased()
    }
    
    
    //MARK: - Other Function
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
