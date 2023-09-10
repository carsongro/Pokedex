//
//  PokeImageLoader.swift
//  Pokedex
//
//  Created by Carson Gross on 9/9/23.
//

import SwiftUI

final class PokeImageLoader {
    static let shared = PokeImageLoader()
    
    enum PokeImageLoaderError: Error {
        case invalidServerResponse
        case unsupportedImage
    }
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private init() {}
    
    /// Get image content with URL
    /// - Parameters:
    ///   - url: Source url
    public func fetchImage(_ url: URL) async throws -> UIImage {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key),
           let image = UIImage(data: data as Data) {
            return image // Return the image if it was previously cached
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw PokeImageLoaderError.invalidServerResponse
        }
        
        guard let image = UIImage(data: data as Data) else {
            throw PokeImageLoaderError.unsupportedImage
        }
        
        let value = data as NSData
        self.imageDataCache.setObject(value, forKey: key) // Cache the image
        
        return image
    }
}
