//
//  File.swift
//  
//
//  Created by Jim Huang on 2023/3/21.
//

import Foundation
import Alamofire

typealias Completion = (_ response:ResponseType.Result) -> Void

class APIManager: NSObject {
    /// 呼叫 Api
    /// - Parameters:
    ///   - url: 網址(包含 query string)
    ///   - method: Http 方法
    ///   - body: body
    ///   - headers: HTTP Header
    ///   - dataType: 回傳的資料型態(預設Json)
    func getResponse(url: URL, method: HTTPMethod = .get, headers: HTTPHeaders? = nil, body: String? = nil, dataType: ResponseType.DataType = .Json, completion:@escaping Completion) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let _header = headers {
            request.headers = _header
        }
        
        if let _body = body {
            request.httpBody = _body.data(using: .utf8, allowLossyConversion: false)!
        }
        
        AF.request(request).responseData { response in
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
    ///   - fileData: 檔案路徑
    ///   - headers: HTTP Header
    ///   - dataType: 回傳的資料型態(預設Json)
    func uploadFile(url: String, method: HTTPMethod = .post, headers: HTTPHeaders? = nil, fileData: Data, dataType: ResponseType.DataType = .Json, completion:@escaping Completion) {
        AF.upload(fileData, to: url, method: method, headers: headers)
            .uploadProgress { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            }
            .responseData { response in
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
}
