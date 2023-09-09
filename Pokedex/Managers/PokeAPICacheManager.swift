//
//  PokeAPICacheManager.swift
//  Pokedex
//
//  Created by Carson Gross on 9/9/23.
//

import Foundation

final class PokeAPICacheManager {
    // API URL: Data
    private var cacheDictionary = [PokeEndpoint: NSCache<NSString, NSData>]()
    
    init() {
        setUpCache()
    }
    
    // MARK: Public
    
    public func cachedResponse(for endpoint: PokeEndpoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint],
              let url = url else {
            return nil
        }
        
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    public func setCache(for endpoint: PokeEndpoint, url: URL?, data: Data) {
        guard let targetCahce = cacheDictionary[endpoint],
              let url = url else {
            return
        }
        
        let key = url.absoluteString as NSString
        targetCahce.setObject(data as NSData, forKey: key)
    }
    
    
    // MARK: Private
    
    private func setUpCache() {
        PokeEndpoint.allCases.forEach { endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        }
    }
}
