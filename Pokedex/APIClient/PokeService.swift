//
//  PokeService.swift
//  Pokedex
//
//  Created by Carson Gross on 9/9/23.
//

import Foundation

/// Primary API Service object to get Pokémon data
final class PokeService {
    /// Shared singleton instance
    static let shared = PokeService()
    
    private let cacheManager = PokeAPICacheManager.shared
    
    /// Privatized constructor
    private init() {}
    
    enum PokeServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    // MARK: Public
    
    public func execute<T: Codable>(_ request: PokeRequest) async throws -> T {
        if let item = await cacheManager.cachedResponse(
            for: request.endpoint,
            url: request.url
        ) {
            let data = switch item {
            case .inProgress(let task):
                try await task.value
            case .ready(let data):
                data
            }
            
            return try JSONDecoder().decode(T.self, from: data)
        }
        
        let task = Task {
            return try await loadData(from: request)
        }
        
        await cacheManager.setCache(for: request.endpoint, url: request.url, entry: .inProgress(task))
        
        do {
            let data = try await task.value
            let result = try JSONDecoder().decode(T.self, from: data)
            await cacheManager.setCache(for: request.endpoint, url: request.url, entry: .ready(data))
            return result
        } catch {
            throw error
        }
    }
    
    // MARK: Private Utilities
    
    private func request(from pokeRequest: PokeRequest) -> URLRequest? {
        guard let url = pokeRequest.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = pokeRequest.httpMethod
        return request
    }
    
    private func loadData(from pokeRequest: PokeRequest) async throws -> Data {
        guard let urlRequest = self.request(from: pokeRequest) else {
            throw PokeServiceError.failedToCreateRequest
        }
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        return data
    }
}
