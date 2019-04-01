//
//  CacheManager.swift
//  DDRequest
//
//  Created by jp on 2018/9/20.
//  Copyright © 2018年 dd01. All rights reserved.
//

import Cache
import Foundation

public class CacheManager: NSObject {
    public static let share = CacheManager()
    private var storage: Storage<Data>?
    
    public override init() {
        super.init()
        cacheConfig()
    }
    
    private func cacheConfig() {
        let diskConfig = DiskConfig(name: "RequestCache")
        let memoryConfig = MemoryConfig(expiry: .never)
        storage = try? Storage(diskConfig: diskConfig,
                               memoryConfig: memoryConfig,
                               transformer: TransformerFactory.forCodable(ofType: Data.self))
    }
    
    // MARK: 清除全部缓存
    public func removeAllCache(completion: @escaping (_ isSuccess: Bool) -> Void) {
        storage?.async.removeAll(completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .value: completion(true)
                case .error: completion(false)
                }
            }
        })
    }
    
    // MARK: 根据key读取缓存
    func objecSync(forKey key: String) -> Data? {
        do {
            return (try storage?.object(forKey: key))
        } catch {
            return nil
        }
    }
    
    // MARK: 异步缓存
    func setObject(_ object: Data, forKey key: String) {
        storage?.async.setObject(object, forKey: key, expiry: nil, completion: { result in
            switch result {
            case .value:
                print("缓存成功")
            case .error(let error):
                print("缓存失败:\(error)")
            }
        })
    }
    
    // MARK: 根据key删除缓存
    func removeObjectCache(_ cacheKey: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        storage?.async.removeObject(forKey: cacheKey, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .value: completion(true)
                case .error: completion(false)
                }
            }
        })
    }
    
}
