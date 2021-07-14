//
//  HttpService.swift
//  Tags
//
//  Created by MG on 14.07.2021.
//

import Foundation
import Alamofire

typealias IdResponseBlock = (Result<Data, CustomError>) -> Void

enum QueueQos {
    case background
    case defaultQos
}

protocol CustomErrorProtocol: Error {
    var localizedDescription: String { get }
    var code: Int { get }
}

struct CustomError: CustomErrorProtocol {
    var localizedDescription: String
    var code: Int
    
    init(localizedDescription: String, code: Int) {
        self.localizedDescription = localizedDescription
        self.code = code
    }
}

class HttpService {
    
    private let apiSettings = ApiSettings()
    private static let queueQos: DispatchQueue = DispatchQueue(label: "com.lampa-queueDefault", qos: .default, attributes: [.concurrent])
    
    func checkInternetConnect() -> Bool {
        return InternetService.shared.checkInternetConnect()
    }
    
    func internetConnectErr() -> CustomError {
        return CustomError(localizedDescription: NSLocalizedString("No internet connection", comment: ""), code: 404)
    }
}

extension HttpService {
    
    func cancellAllRequests() {
        Alamofire.Session.default.cancelAllRequests()
    }
    
    func queryBy(_ url: URLConvertible,
                 method: HTTPMethod = .get,
                 parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 queue: QueueQos,
                 headers: HTTPHeaders? = nil,
                 resp: @escaping IdResponseBlock) {
        
        var headersForQuery: HTTPHeaders = HTTPHeaders()
        
        if let token = headers?[Keys.token] {
            headersForQuery[Keys.token] = token
        } else {
            let token = apiSettings.token ?? ""
            headersForQuery[Keys.token] = token
        }
        
        return query(url,
                     method: method,
                     parameters: parameters,
                     encoding: encoding,
                     headers: headersForQuery,
                     queue: queue,
                     resp: resp)
    }
    
    func queryWithoutTokenBy(_ url: URLConvertible,
                             method: HTTPMethod = .get,
                             parameters: Parameters? = nil,
                             encoding: ParameterEncoding = URLEncoding.default,
                             headers: HTTPHeaders? = nil,
                             queue: QueueQos,
                             resp:@escaping IdResponseBlock) {
        
        query(url,
              method: method,
              parameters: parameters,
              encoding: encoding,
              headers: headers,
              queue: queue,
              resp: resp)
        
    }
    
    func query(_ url: URLConvertible,
               method: HTTPMethod = .get,
               parameters: Parameters? = nil,
               encoding: ParameterEncoding = URLEncoding.default,
               headers: HTTPHeaders? = nil,
               queue: QueueQos,
               resp: @escaping IdResponseBlock) {
        
        if !checkInternetConnect() {
            NotificationCenter.default.post(name: NSNotification.Name(Keys.kLostInternetConnection), object: nil, userInfo: nil)
        }
        
        AF.request(url,
                   method: method,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers
        ).validate().responseData(queue: HttpService.queueQos) { [weak self] (response) in
            self?.parseResponse(response, respCompletion: resp)
        }
    }
    
    func queryMultipart(_ url: URLConvertible,
                        method: HTTPMethod = .post,
                        parameters: Parameters? = nil,
                        data: Data? = nil,
                        fileName: String? = nil,
                        image: [UIImage]? = nil,
                        keyForFile: String = "file",
                        headers: HTTPHeaders? = nil,
                        encoding: ParameterEncoding = URLEncoding.default,
                        resp: @escaping IdResponseBlock) {
        
        if !checkInternetConnect() {
            NotificationCenter.default.post(name: NSNotification.Name(Keys.kLostInternetConnection), object: nil, userInfo: nil)
        }
        
        let token = apiSettings.token ?? ""
        
        var headersForQuery: HTTPHeaders = headers ?? [Keys.token: token]
        headersForQuery[Keys.token] = token
        
        NetworkActivityIndicatorManager.shared.start()
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            if let params = parameters {
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
            
            if let data = data {
                guard let fName = fileName else { return }
                
                multipartFormData.append(data, withName: fName, fileName: keyForFile, mimeType: "application")
            }
            
            if let data = image {
                for item in data {
                    if let imageData1 = item.jpegData(compressionQuality: 0.5) {
                        multipartFormData.append(imageData1, withName: keyForFile, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                    }
                }
            }
            
        }, to: url, method: method, headers: headersForQuery).validate().responseData { [weak self] (response) in
            self?.parseResponse(response, respCompletion: resp)
        }
    }
    
    private func parseResponse(_ response: AFDataResponse<Data>, respCompletion: @escaping IdResponseBlock) {
        
        let statusCode = response.response?.statusCode ?? 0
        print(statusCode)
        
        switch response.result {
        case .success(let value):
            return respCompletion(.success(value))
        case .failure(let error):
            let customError = CustomError(localizedDescription: error.localizedDescription, code: statusCode)
            respCompletion(.failure(customError))
        }
    }
}
