//
//  Request.swift
//  DDRequest
//
//  Created by senyuhao on 2018/7/11.
//  Copyright © 2018年 dd01. All rights reserved.
//

import Alamofire
import Foundation
import PromiseKit

public protocol HTTPParam { }
extension String: HTTPParam { }
extension Int: HTTPParam { }
extension Float: HTTPParam { }
extension Double: HTTPParam { }
extension Bool: HTTPParam { }
extension Array: HTTPParam { }
extension Dictionary: HTTPParam { }

public class DDRequest {
    
    public static let shared = DDRequest()
    // 配置URL信息
    public var api: String = ""
    // 配置出错ErrorDomain
    public var errorDomain: String = ""
    // 配置Header
    public var header: HTTPHeaders?
    
    // 配置需处理code情况
    // eg: [4_003: (EBTool, NSStringFromSelector(#selector(needLogin)))]
    public var variableCode: [Int: (target: NSObject, action: String)]?

    public class func decode<T: Decodable>(data: Data?, error: Error?) -> (T?, Error?) {
        if let data = data {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let resp = try decoder.decode(T.self, from: data)
                return (resp, nil)
            } catch {
                let err = DDRequest.shared.errorLocal(info: error)
                return (nil, err)
            }
        } else {
            let error = DDRequest.shared.errorLocal(info: error)
            return (nil, error)
        }
    }

    private func errorLocal(info: Error?) -> Error? {
        if let error = info as NSError? {
            if let variableCode = DDRequest.shared.variableCode,
                let performValue = variableCode[error.code] {
                performValue.target.perform(NSSelectorFromString(performValue.action), with: nil)
            }
            let err = NSError(domain: DDRequest.shared.errorDomain,
                              code: error.code,
                              userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
            return err
        }
        return nil
    }
}

// MARK: 泛型解析 直接回调结果
extension DDRequest {
    public class func get<T>(path: String,
                             params: [String: HTTPParam],
                             cache: Bool? = nil,
                             handler: ((DataRequest) -> Void)? = nil,
                             result: @escaping (T?, Error?) -> Void) where T: Decodable {
        DDRequest.shared.get(path: path,
                             params: params,
                             cache: cache,
                             handler: handler) { data, error in
                                let value: (T?, Error?) = decode(data: data, error: error)
                                result(value.0, value.1)
        }
    }

    public class func post<T>(path: String,
                              params: [String: HTTPParam],
                              cache: Bool? = nil,
                              handler: ((DataRequest) -> Void)? = nil,
                              result: @escaping(T?, Error?) -> Void) where T: Decodable {
        DDRequest.shared.post(path: path,
                              params: params,
                              cache: cache,
                              handler: handler) { data, error in
                                let value: (T?, Error?) = decode(data: data, error: error)
                                result(value.0, value.1)
        }
    }

    /// 图片上传
    public class func post<T: Decodable>(path: String,
                                         params: [String: HTTPParam],
                                         image: UIImage,
                                         name: String,
                                         handler: ((DataRequest) -> Void)? = nil,
                                         step: @escaping (Double) -> Void,
                                         result: @escaping ((T?, Error?) -> Void)) {
        DDRequest.shared.send(path: path,
                              method: .post,
                              image: image,
                              name: name,
                              params: params,
                              handler: handler,
                              step: step) { data, error in
                                let value: (T?, Error?) = decode(data: data, error: error)
                                result(value.0, value.1)
        }
    }

    private func get(path: String,
                     params: [String: HTTPParam],
                     cache: Bool? = nil,
                     handler: ((DataRequest) -> Void)? = nil,
                     result: @escaping(Data?, Error?) -> Void) {
        send(path: path,
             method: .get,
             cache: cache,
             params: params,
             handler: handler,
             result: result)
    }

    private func post(path: String,
                      params: [String: HTTPParam],
                      cache: Bool? = nil,
                      handler: ((DataRequest) -> Void)? = nil,
                      result: @escaping(Data?, Error?) -> Void) {
        send(path: path,
             method: .post,
             cache: cache,
             params: params,
             handler: handler,
             result: result)
    }

    private func send(path: String,
                      method: HTTPMethod,
                      cache: Bool? = nil,
                      params: [String: HTTPParam],
                      handler: ((DataRequest) -> Void)? = nil,
                      result: @escaping(Data?, Error?) -> Void) {
        let status = cacheStatus(method: method, cache: cache)
        let url = "\(DDRequest.shared.api)/\(path)"
        let req = request(url,
                          method: method,
                          parameters: params.flat(nil),
                          encoding: URLEncoding.default,
                          headers: DDRequest.shared.header)
        
        if status, let value = CacheManager.share.objecSync(forKey: cacheKey(url, params)) {
            result(value as Data, nil)
        }
        handler?(req)
        req.responseData { response in
            if status, let value = response.value {
                CacheManager.share.setObject(value, forKey: cacheKey(url, params))
            }
            self.printData(value: response.value)
            result(response.value, response.error)
        }
    }

    private func cacheStatus(method: HTTPMethod, cache: Bool? = nil) -> Bool {
        if let cache = cache {
            return cache
        } else if method == .get {
            return true
        } else if method == .post {
            return false
        } else {
            return false
        }
    }

    /// 图片上传
    private func post(path: String,
                      params: [String: HTTPParam],
                      image: UIImage,
                      name: String,
                      handler: ((DataRequest) -> Void)? = nil,
                      step: @escaping (Double) -> Void,
                      result: @escaping ((Data?, Error?) -> Void)) {
        send(path: path,
             method: .post,
             image: image,
             name: name,
             params: params,
             handler: handler,
             step: step,
             result: result)
    }

    private func send(path: String,
                      method: HTTPMethod,
                      image: UIImage,
                      name: String,
                      params: [String: HTTPParam],
                      handler: ((DataRequest) -> Void)? = nil,
                      step: @escaping (Double) -> Void,
                      result: @escaping (Data?, Error?) -> Void) {
        let url = "\(DDRequest.shared.api)/\(path)"
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            upload(multipartFormData: { formData in
                formData.append(imageData,
                                withName: name,
                                fileName: Date().timeIntervalSince1970.description + ".jpeg",
                                mimeType: "image/jpeg")
                for(key, value) in params {
                    if let data = "\(value)".data(using: .utf8) {
                        formData.append(data, withName: key)
                    }
                }
            },
                   usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
                   to: url,
                   method: .post,
                   headers: DDRequest.shared.header,
                   encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseData { response in
                            self.printData(value: response.data)
                            result(response.data, response.error)
                        }
                        upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                            step(progress.fractionCompleted)
                        }
                    case .failure(let encodingError):
                        result(nil, encodingError)
                    }

            })
        }
    }
}

// MARK: - 泛型解析 + block回调上次请求结果 + promise
extension DDRequest {
    public class func get<T>(path: String,
                             params: [String: HTTPParam],
                             cache: Bool? = nil,
                             handler: ((DataRequest) -> Void)? = nil) -> Promise<T> where T: Decodable {
        return DDRequest.shared.get(path: path,
                                    params: params,
                                    cache: cache,
                                    handler: handler)
    }

    public class func post<T>(path: String,
                              params: [String: HTTPParam],
                              cache: Bool? = nil,
                              handler: ((DataRequest) -> Void)? = nil,
                              previous: ((T) -> Void)? = nil) -> Promise<T> where T: Decodable {
        return DDRequest.shared.post(path: path,
                                     params: params,
                                     cache: cache,
                                     handler: handler,
                                     previous: previous)
    }

    public class func post<T>(path: String,
                              params: [String: HTTPParam],
                              image: UIImage,
                              name: String,
                              handler: ((DataRequest) -> Void)? = nil,
                              step: @escaping(Double) -> Void) -> Promise<T> where T: Decodable {
        return DDRequest.shared.post(path: path,
                                     params: params,
                                     image: image,
                                     name: name,
                                     handler: handler,
                                     step: step)
    }

    /// Get
    private func get<T>(path: String,
                        params: [String: HTTPParam],
                        cache: Bool? = nil,
                        handler: ((DataRequest) -> Void)? = nil,
                        previous: ((T) -> Void)? = nil) -> Promise<T> where T: Decodable {
        return send(path: path,
                    method: .get,
                    cache: cache,
                    params: params,
                    handler: handler,
                    previous: previous)
    }

    /// Post
    private func post<T>(path: String,
                         params: [String: HTTPParam],
                         cache: Bool? = nil,
                         handler: ((DataRequest) -> Void)? = nil,
                         previous: ((T) -> Void)? = nil) -> Promise<T> where T: Decodable {
        return send(path: path,
                    method: .post,
                    cache: cache,
                    params: params,
                    handler: handler,
                    previous: previous)
    }

    /// 图片上传
    public func post<T>(path: String,
                        params: [String: HTTPParam],
                        image: UIImage,
                        name: String,
                        handler: ((DataRequest) -> Void)? = nil,
                        step: @escaping(Double) -> Void) -> Promise<T> where T: Decodable {
        return send(path: path,
                    method: .post,
                    image: image,
                    name: name,
                    params: params,
                    handler: handler,
                    step: step)
    }

    private func send<T>(path: String,
                         method: HTTPMethod,
                         cache: Bool? = nil,
                         params: [String: HTTPParam],
                         handler: ((DataRequest) -> Void)? = nil,
                         previous: ((T) -> Void)? = nil) -> Promise<T> where T: Decodable {
        let url = "\(DDRequest.shared.api)/\(path)"
        let status = cacheStatus(method: method, cache: cache)

        if status, let value = CacheManager.share.objecSync(forKey: cacheKey(url, params)) {
            let result: (T?, Error?) = DDRequest.decode(data: value as Data, error: nil)
            if let model = result.0 {
                debugPrint("previous model:\(model)")
                previous?(model)
            }
        }
        return Promise { seal in
            let req = request(url,
                              method: method,
                              parameters: params.flat(nil),
                              encoding: URLEncoding.default,
                              headers: DDRequest.shared.header)

            handler?(req)
            req.responseData(completionHandler: { response in
                if status, let value = response.value {
                    CacheManager.share.setObject(value, forKey: cacheKey(url, params))
                }
                self.printData(value: response.data)
                self.decodeResponse(response: response, seal: seal)
            })
        }
    }

    // 处理图片上传
    private func send<T>(path: String,
                         method: HTTPMethod,
                         image: UIImage,
                         name: String,
                         params: [String: HTTPParam],
                         handler: ((DataRequest) -> Void)? = nil,
                         step: @escaping(Double) -> Void) -> Promise<T> where T: Decodable {
        let url = "\(DDRequest.shared.api)/\(path)"
        return Promise { seal in
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                upload(multipartFormData: { formData in
                    formData.append(imageData,
                                    withName: name,
                                    fileName: Date().timeIntervalSince1970.description + ".jpeg",
                                    mimeType: "image/jpeg")
                    for(key, value) in params {
                        if let data = "\(value)".data(using: .utf8) {
                            formData.append(data, withName: key)
                        }
                    }
                },
                       usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
                       to: url,
                       method: .post,
                       headers: DDRequest.shared.header,
                       encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseData { response in
                                debugPrint("✅" + upload.debugDescription)
                                self.decodeResponse(response: response, seal: seal)
                            }
                            upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                                debugPrint("图片上传进度: \(progress.fractionCompleted)")
                                step(progress.fractionCompleted)
                            }
                        case .failure(let encodingError):
                            debugPrint(encodingError)
                        }

                })
            }
        }
    }

    private func decodeResponse<T: Decodable>(response: DataResponse<Data>, seal: Resolver<T>) {
        if let value = response.value {
            decodeData(data: value, seal: seal)
        } else {
            let err = DDRequest.shared.errorLocal(info: response.error)
            seal.resolve(err, nil)
        }
    }

    private func decodeData<T: Decodable>(data: Data, seal: Resolver<T>) {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let resp = try decoder.decode(T.self, from: data)
            seal.resolve(nil, resp)
        } catch {
            let err = DDRequest.shared.errorLocal(info: error)
            seal.resolve(err, nil)
        }
    }

    // 数据打印
    private func printData(value: Data?) {
        if let value = value,
            let json = try? JSONSerialization.jsonObject(with: value,
                                                         options: .allowFragments) as? [String: Any],
            let jsonString = json?.description {
            debugPrint("======数据请求完成======")
            print("\(jsonString)")
        } else {
            debugPrint("======数据请求失败======")
        }
    }
}

extension Array {
    func mapDictionary<T>(_ transform: (Int, Element) -> T) -> [T: Element] {
        var dic = [T: Element]()
        for (index, item) in enumerated() {
            dic[transform(index, item)] = item
        }
        return dic
    }
}

extension Dictionary {
    func mapKeys<T>(_ transform: (Dictionary.Key) -> T) -> [T: Dictionary.Value] {
        var dic = [T: Dictionary.Value]()
        for (key, value) in self {
            dic[transform(key)] = value
        }
        return dic
    }
}

extension Dictionary where Key == String {
    func flat(_ rootKey: Key?) -> [Key: Value] {
        var dic = [Key: Value]()
        var newDic = self
        if let rootKey = rootKey {
            newDic = mapKeys { "\(rootKey)[\($0)]" }
        }
        for (key, value) in newDic {
            var dicValue = value as? [Key: Value]
            if let arrayValue = value as? [Value] {
                dicValue = arrayValue.mapDictionary { index, _ in "\(index)" }
            }
            if let dicValue = dicValue {
                dic.merge(dicValue.flat(key)) { value, _ in value }
            } else {
                dic[key] = value
            }
        }
        return dic
    }
}
