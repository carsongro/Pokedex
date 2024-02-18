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
    
    private let cacheManager = PokeAPICacheManager()
    
    /// Privatized constructor
    private init() {}
    
    enum PokeServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    // MARK: Public
    
    public func execute<T: Codable>(
        _ request: PokeRequest,
        expecting type: T.Type
    ) async throws -> T {
        if let item = await cacheManager.cachedResponse(
            for: request.endpoint,
            url: request.url
        ) {
            switch item {
            case .inProgress(let task):
                let data = try await task.value
                return try JSONDecoder().decode(T.self, from: data)
            case .ready(let data):
                return try JSONDecoder().decode(type.self, from: data)
            }
        }
        
        let task = Task {
            return try await loadData(from: request)
        }
        
        await cacheManager.setCache(for: request.endpoint, url: request.url, entry: .inProgress(task))
        
        do {
            let data = try await task.value
            let result = try JSONDecoder().decode(type.self, from: data)
            await cacheManager.setCache(
                for: request.endpoint,
                url: request.url,
                entry: .ready(data)
            )
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
