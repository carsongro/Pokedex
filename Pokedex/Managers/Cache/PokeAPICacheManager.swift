//
//  PokeAPICacheManager.swift
//  Pokedex
//
//  Created by Carson Gross on 9/9/23.
//

import UIKit

// TODO: Refactor this so that stores in progress requests in the cache to prevent duplicate requests being carried out
actor PokeAPICacheManager {
    // API URL: Data
    private var cacheDictionary = [PokeEndpoint: NSCache<NSString, NSData>]()
    private var storageCache = StorageCache()
    
    init() {
        setUpCache()
    }
    
    // MARK: Public
    
    public func cachedResponse(for endpoint: PokeEndpoint, url: URL?) async -> Data? {
        guard let url = url else { return nil }
        
        if let data = await storageCache.item(forKey: url.absoluteString) {
            return data
        } else if let targetCache = cacheDictionary[endpoint] {
            let key = url.absoluteString as NSString
            return targetCache.object(forKey: key) as? Data
        } else {
            return nil
        }
    }
    
    public func setCache(for endpoint: PokeEndpoint, url: URL?, data: Data) async {
        guard let url = url else { return }
        await storageCache.setItem(data, forKey: url.absoluteString)
        
        guard let targetCache = cacheDictionary[endpoint] else {
            return
        }
        
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }
    
    
    // MARK: Private
    
    nonisolated private func setUpCache() {
        PokeEndpoint.allCases.forEach { endpoint in
            Task {
                await setUpEntry(for: endpoint)
            }
        }
        
        Task { @MainActor in
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(cleanMemoryCache),
                name: UIApplication.didReceiveMemoryWarningNotification,
                object: nil
            )
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(cleanExpiredStorageCache),
                name: UIApplication.willTerminateNotification,
                object: nil
            )
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(cleanStorageCacheBackground),
                name: UIApplication.didEnterBackgroundNotification,
                object: nil
            )
        }
    }
    
    private func setUpEntry(for endpoint: PokeEndpoint) {
        cacheDictionary[endpoint] = NSCache<NSString, NSData>()
    }
    
    private func removeAllObjectsFromMemory() {
        for (_, v) in cacheDictionary {
            v.removeAllObjects()
        }
    }
    
    // MARK: Observer Methods
    
    @MainActor
    @objc private func cleanMemoryCache() {
        Task {
            await removeAllObjectsFromMemory()
        }
    }
    
    @MainActor
    @objc private func cleanExpiredStorageCache() {
        Task {
            await storageCache.removeExpiredItems()
            await storageCache.removeItemsOverSizeLimit()
        }
    }
    
    @MainActor
    @objc private func cleanStorageCacheBackground() {
        Task {
            let background = UIApplication.shared.beginBackgroundTask()
            cleanExpiredStorageCache()
            UIApplication.shared.endBackgroundTask(background)
        }
    }
}

