//
//  PokeAPICacheManager.swift
//  Pokedex
//
//  Created by Carson Gross on 9/9/23.
//

import UIKit

actor PokeAPICacheManager {
    static let shared = PokeAPICacheManager()
    
    private init() {
        setUpCache()
    }
    
    private var memoryCacheDictionary = [PokeEndpoint: NSCache<NSString, CacheEntry>]()
    private var storageCache = StorageCache.shared
    
    // MARK: Public
    
    public func cachedResponse(for endpoint: PokeEndpoint, url: URL?) async -> CacheEntryItem? {
        guard let url = url else { return nil }
        
        if let data = await storageCache.item(forKey: url.absoluteString) {
            return .ready(data)
        } else if let targetCache = memoryCacheDictionary[endpoint] {
            let key = url.absoluteString as NSString
            return targetCache.object(forKey: key)?.item
        } else {
            return nil
        }
    }
    
    public func setCache(for endpoint: PokeEndpoint, url: URL?, entry: CacheEntryItem) async {
        guard let url = url else { return }
        
        guard let targetCache = memoryCacheDictionary[endpoint] else {
            return
        }
        
        let key = url.absoluteString as NSString
        targetCache.setObject(CacheEntry(item: entry), forKey: key)
        
        switch entry {
        case .ready(let data):
            await storageCache.setItem(data, forKey: url.absoluteString)
        default:
            break
        }
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
        memoryCacheDictionary[endpoint] = NSCache<NSString, CacheEntry>()
    }
    
    private func removeAllObjectsFromMemory() {
        for (_, v) in memoryCacheDictionary {
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

enum CacheEntryItem {
    case inProgress(Task<Data, Error>)
    case ready(Data)
}

extension PokeAPICacheManager {
    final class CacheEntry {
        let item: CacheEntryItem
        
        init(item: CacheEntryItem) {
            self.item = item
        }
    }
}

