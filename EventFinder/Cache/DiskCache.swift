//
//  DiskCache.swift
//  EventFinder
//
//  Created by Chesley Stephens on 6/24/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import UIKit

class DiskCache<T: Codable & Hashable> {
    
    private let queue = DispatchQueue(label: "DiskCacheQueue", attributes: .concurrent)
    private var backgroundTask = UIBackgroundTaskIdentifier.invalid
    private let cacheName: String
    
    init(cacheName: String) {
        self.cacheName = cacheName
    }
    
    private func cachePath() -> URL? {
        var cachePath: URL?
        if let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            cachePath = cachesURL.appendingPathComponent("EventFinderCache/\(cacheName)")
        }
        return cachePath
    }
    
    func setObject(object: Set<T>, key: String) {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            if let backgroundTask = self?.backgroundTask {
                UIApplication.shared.endBackgroundTask(backgroundTask)
                self?.backgroundTask = UIBackgroundTaskIdentifier.invalid
            }
        }
        queue.async(flags: .barrier) { [weak self] in
            do {
                let encodedObject = try JSONEncoder().encode(object)
                if let cachePath = self?.cachePath() {
                    if !FileManager.default.fileExists(atPath: cachePath.path) {
                        try FileManager.default.createDirectory(atPath: cachePath.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil)
                    }
                    try encodedObject.write(to: cachePath, options: .atomic)
                }
            } catch {
                print("Disk cache write error: \(error.localizedDescription)")
            }
            if let backgroundTask = self?.backgroundTask {
                UIApplication.shared.endBackgroundTask(backgroundTask)
                self?.backgroundTask = UIBackgroundTaskIdentifier.invalid
            }
        }
    }
    
    func object(key: String) -> Set<T>? {
        var object: Set<T>?
        queue.sync { [weak self] in
            do {
                if let cachePath = self?.cachePath(), FileManager.default.fileExists(atPath: cachePath.path) {
                    let objectData = try Data(contentsOf: cachePath)
                    object = try JSONDecoder().decode(Set<T>.self, from: objectData)
                }
            } catch {
                print("Disk cache read error: \(error.localizedDescription)")
            }
        }
        return object
    }
    
    func removeCache() {
        queue.sync { [weak self] in
            do {
                if let cachePath = self?.cachePath(), FileManager.default.fileExists(atPath: cachePath.path) {
                    try FileManager.default.removeItem(at: cachePath)
                }
            } catch {
                print("Disk cache write error: \(error.localizedDescription)")
            }
        }
    }
}
