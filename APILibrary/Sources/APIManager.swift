//
//  File.swift
//  
//
//  Created by Jim Huang on 2023/3/21.
//

import Foundation
import Alamofire

typealias Completion = (_ response:ResponseType.Result) -> Void

open class APIManager: NSObject {
    /// 呼叫 Api
    /// - Parameters:
    ///   - url: 網址(包含 query string)
    ///   - method: Http 方法
    ///   - headers: HTTP Header
    ///   - body: body
    ///   - dataType: 回傳的資料型態(預設Json)
    ///   - timeout：設定逾時時間
    public static func getResponse(url: URL, method: HTTPMethod = .get, headers: HTTPHeaders? = nil, body: String? = nil, dataType: ResponseType.DataType = .Json, timeout: Int, completion:@escaping (_ response:ResponseType.Result) -> Void) {
        print("Start: \(Date())")
        AF.request(url, method: method, headers: headers) { request in
            request.timeoutInterval = 5
            
            if let _body = body {
                request.httpBody = _body.data(using: .utf8, allowLossyConversion: false)!
            }
        }.responseData { response in
            print("end: \(Date())")
            
            switch response.result {
            case .success(let res):
                switch dataType {
                case .XML:
                    if let res = XMLParserUtility(fromData: res).getJson() {
                        completion(.Success(res))
                    } else {
                        completion(.Error(response.response?.statusCode, "回傳值有問題"))
                    }
                    break
                case .Json:
                    do {
                        if let jsonObject = try? JSONSerialization.jsonObject(with: res, options: []),
                           let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
                           let prettyJSONString = String(data: jsonData, encoding: .utf8) {
                            completion(.Success(prettyJSONString))
                        } else {
                            completion(.Error(response.response?.statusCode, "轉換String有問題"))
                        }
                    }
                    break
                }
            case .failure(_):
                completion(.Error(response.response?.statusCode, "網路錯誤"))
            }
        }
    }
    
    /// 上傳檔案
    /// - Parameters:
    ///   - url: 網址(包含 query string)
    ///   - method: Http 方法
    ///   - headers: HTTP Header
    ///   - fileData: 檔案 Stream
    ///   - fileURL: 檔案路徑
    ///   - fileSize: 檔案實際大小
    ///   - dataType: 回傳的資料型態(預設Json)
    ///   - timeout：設定逾時時間
    public static func uploadFile(url: String, method: HTTPMethod = .post, headers: HTTPHeaders? = nil, fileData: Data? = nil, fileURL: URL? = nil, fileSize: Int64, dataType: ResponseType.DataType = .Json, timeout: Int, completion:@escaping (_ response:ResponseType.Result) -> Void) {
        print("Start: \(Date())")
        AF.upload(multipartFormData: { multipartFormData in
            if let data = fileData {
                multipartFormData.append(data, withName: "file", fileName: "file")
            } else if let url = fileURL, let inputStream = InputStream(url: url) {
                multipartFormData.append(inputStream, withLength: UInt64(fileSize), name: "file", fileName: "file", mimeType: "")
            }
        }, to: url, method: method, headers: headers)
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        .responseData { response in
            print("end: \(Date())")
            
            switch response.result {
            case .success(let res):
                switch dataType {
                case .XML:
                    if let res = XMLParserUtility(fromData: res).getJson() {
                        completion(.Success(res))
                    } else {
                        completion(.Error(response.response?.statusCode, "回傳值有問題"))
                    }
                    break
                case .Json:
                    do {
                        if let jsonObject = try? JSONSerialization.jsonObject(with: res, options: []),
                           let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
                           let prettyJSONString = String(data: jsonData, encoding: .utf8) {
                            completion(.Success(prettyJSONString))
                        } else {
                            completion(.Error(response.response?.statusCode, "轉換String有問題"))
                        }
                    }
                    break
                }
            case .failure(_):
                completion(.Error(response.response?.statusCode, "網路錯誤"))
            }
        }
    }
    
    /// 下載檔案
    /// - Parameters:
    ///   - url: 網址(包含 query string)
    ///   - method: Http 方法
    ///   - headers: HTTP Header
    ///   - fileURL: 檔案路徑
    ///   - dataType: 回傳的資料型態(預設Json)
    ///   - timeout：設定逾時時間
    public static func downloadFile(url: URL, method: HTTPMethod = .get, headers: HTTPHeaders? = nil, resumeData: Data? = nil, fileURL: URL, timeout: Int, completion:@escaping (_ response:ResponseType.Result) -> Void) {
        let destination: DownloadRequest.Destination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        if let data = resumeData {
            // 斷點續傳
            AF.download(resumingWith: data, to: destination).downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
            }.response { response in
                if response.error == nil, let filePath = response.fileURL?.path {
                    completion(.Success(filePath))
                } else {
                    completion(.Error(response.response?.statusCode, "下載失敗"))
                }
            }
        } else {
            // 一般下載
            AF.download(url, method: method, headers: headers, to: destination).downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
            }.response { response in
                if response.error == nil, let filePath = response.fileURL?.path {
                    completion(.Success(filePath))
                } else {
                    completion(.Error(response.response?.statusCode, "下載失敗"))
                }
            }
        }
    }
}
