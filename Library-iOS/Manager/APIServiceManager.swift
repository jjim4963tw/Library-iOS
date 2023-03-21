//
//  APIServiceManager.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/22.
//

import Foundation
import AFNetworking
import Alamofire

struct HTTPType {
    static let GET = "GET"
    static let POST = "POST"
    static let PUT = "PUT"
    static let PATCH = "PATCH"
    static let DELETE = "DELETE"
}

struct ResponseType {
    static let XML = 0
    static let JSON = 1
    static let HTML = 2
}

class APIServiceManager: NSObject {
    private static var instance : APIServiceManager?
    
    static func shareInstance() -> APIServiceManager {
        if instance == nil {
            instance = APIServiceManager()
        }
        return instance!
    }
    
    
    //MARK: - Main Connection function
    func connectionUsingAFNetworking(url: URL, SSLPinning: Bool, httpType: String, queryParams: [String: Any]?, headers: [String: String]?, payload: Data?, responseType: Int, responseParser: Any?, completion: ((Any?, Any?) -> Void)? = nil) {
        if responseType == ResponseType.XML {
            self.connectionUsingAFNetworkingXML(url: url, SSLPinning: SSLPinning, httpType: httpType, queryParams: queryParams, headers: headers, payload: payload, responseType: responseType, responseParser: responseParser, completion: completion)
        } else if responseType == ResponseType.JSON {
            self.connectionUsingAFNetworkingJSON(url: url, SSLPinning: SSLPinning, httpType: httpType, queryParams: queryParams, headers: headers, payload: payload, responseType: responseType, responseParser: responseParser, completion: completion)
        }
    }
    
    func connectionUsingAFNetworkingXML(url: URL, SSLPinning: Bool, httpType: String, queryParams: [String: Any]?, headers: [String: String]?, payload: Data?, responseType: Int, responseParser: Any?, completion: ((Any?, Any?) -> Void)? = nil) {
        var urlString = url.absoluteString
        if queryParams != nil && queryParams!.count > 0 {
            urlString = self.mergeURLPathFunction(url: url, queryParams: queryParams!)
        }
        
        let manager = AFHTTPSessionManager(baseURL: URL(string: urlString))
        
        // 防止Content-Type會帶入兩次，導致錯誤
        if headers != nil && headers!["Content-Type"] != nil {
            manager.requestSerializer.setValue(headers!["Content-Type"] , forHTTPHeaderField: "Content-Type")
        }
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        // 實作憑證綁定
        if SSLPinning {
            self.setSSLPinningFunction(manager: manager, completion: completion)
        }
        
        var dataString: String? = nil
        if payload != nil {
            dataString = String(data: payload!, encoding: .utf8) ?? ""
            manager.requestSerializer.setQueryStringSerializationWith { request, _, error in
                return dataString
            }
        }
        
        if httpType == HTTPType.GET {
            manager.get(urlString, parameters: dataString, headers: headers, progress: nil) { task, responseObject in
                
            } failure: { task, error in
                if completion != nil {
                    completion!(nil, error)
                }
            }
        } else if httpType == HTTPType.POST {
            manager.post(urlString, parameters: dataString, headers: headers, progress: nil) { task, responseObject in
                
            } failure: { task, error in
                
            }
        }
    }
    
    func connectionUsingAFNetworkingJSON(url: URL, SSLPinning: Bool, httpType: String, queryParams: [String: Any]?, headers: [String: String]?, payload: Data?, responseType: Int, responseParser: Any?, completion: ((Any?, Any?) -> Void)? = nil) {
        var urlString = url.absoluteString
        if queryParams != nil && queryParams!.count > 0 {
            urlString = self.mergeURLPathFunction(url: url, queryParams: queryParams!)
        }
        
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        
        // 實作憑證綁定
        if SSLPinning {
            self.setSSLPinningFunction(manager: manager, completion: completion)
        }
        
        do {
            let request = try AFJSONRequestSerializer().request(withMethod: httpType, urlString: urlString, parameters: nil)
            request.timeoutInterval = 25
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // 將Header照字母排序，並塞入request中
            if headers != nil && headers!.count > 0 {
                let orderedKeys = headers!.keys.sorted(by: <)
                for key in orderedKeys {
                    request.setValue(headers![key], forHTTPHeaderField: key)
                }
            }
            
            if payload != nil {
                request.httpBody = payload!
            }
            
            manager.dataTask(with: request as URLRequest, uploadProgress: nil, downloadProgress: nil) { response, responseObject, error in
                if error != nil {
                    if completion != nil {
                        completion!(nil, error)
                    }
                } else {
                    if (responseObject != nil && responseObject is NSDictionary) {
                        if completion != nil {
                            completion!(responseObject as! NSMutableDictionary, error);
                        }
                    } else {
                        if completion != nil {
                            completion!(nil, nil)
                        }
                    }
                }
            }
        } catch {
            if completion != nil {
                completion!(nil, nil)
            }
        }
    }
    
    func connectionUsingAlamofire(url: URL, httpType: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, payload: Data?, responseType: Int, responseParser: Any?, completion: ((Any?, Any?) -> Void)? = nil) {
        if responseType == ResponseType.XML || responseType == ResponseType.JSON {
            AF.request(url, method: httpType, parameters: parameters, headers: headers).responseData { responseData in
                switch responseData.result {
                case .success(let result):
                    switch responseType {
                    case ResponseType.XML:
                        guard let stringResponse: String = String(data: result, encoding: String.Encoding.utf8) else { return }
                        if completion != nil {
                            completion!(stringResponse, nil)
                        }
                        break
                    case ResponseType.JSON:
                        do {
                            if let jsonObject = try? JSONSerialization.jsonObject(with: result, options: []),
                               let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
                               let prettyJSONString = String(data: jsonData, encoding: .utf8) {
                                completion!(prettyJSONString, nil)
                            }
                        }
                        break
                    default:
                        break
                    }
                case.failure(let error):
                    if completion != nil {
                        completion!(nil, error)
                    }
                    break
                }
            }
        } else {
            AF.request(url, method: httpType, parameters: parameters, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):
                    if completion != nil {
                        completion!(value, nil)
                    }
                case .failure(let error):
                    if completion != nil {
                        completion!(nil, error)
                    }
                }
            }
        }
    }
    
    
    //MARK: - tool function
    func mergeURLPathFunction(url: URL, queryParams: [String: Any]) -> String {
        var urlString = url.absoluteString
        
        for (key, value) in queryParams {
            if value is [String] {
                for subValue in (value as! [String]) {
                    urlString = "\(urlString)\(key)=\(subValue)"
                }
            } else {
                urlString = "\(urlString)\(key)=\(value)"
            }
        }
        
        return urlString
    }
    
    func setSSLPinningFunction(manager: AFHTTPSessionManager, completion: ((Any?, Any?) -> Void)? = nil) {
        let securityPolicy = AFSecurityPolicy(pinningMode: .certificate)
        securityPolicy.allowInvalidCertificates = true
        
        if let certificatePath = Bundle.main.path(forResource: "Cer", ofType: "der") {
            let certificateURL = URL(fileURLWithPath: certificatePath)
            do {
                let certificateData = try Data(contentsOf: certificateURL)
                securityPolicy.pinnedCertificates = Set([certificateData])
                manager.securityPolicy = securityPolicy
            } catch {
                if completion != nil {
                    completion!(nil, nil)
                }
            }
        }
    }
}
