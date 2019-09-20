//
//  Cache.swift
//  EventFinder
//
//  Created by Chesley Stephens on 6/24/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation

class Cache<T: Codable & Hashable> {
    
    private let queue = DispatchQueue(label: "CacheQueue")
    let memoryCache: MemoryCache<T>
    let diskCache: DiskCache<T>
    
    init(cacheName: String) {
        memoryCache = MemoryCache(cacheName: cacheName)
        diskCache = DiskCache(cacheName: cacheName)
    }
    
    func setObject(object: Set<T>, key: String) {
        memoryCache.setObject(object: object, key: key)
        diskCache.setObject(object: object, key: key)
    }
    
    func object(key: String) -> Set<T>? {
        var object: Set<T>?
        if let memoryObject = memoryCache.object(key: key) {
            object = memoryObject
        } else if let diskObject = diskCache.object(key: key) {
            object = diskObject
            memoryCache.setObject(object: diskObject, key: key)
        }
        return object
    }
    
    func removeCache() {
        memoryCache.removeCache()
        diskCache.removeCache()
    }
}
