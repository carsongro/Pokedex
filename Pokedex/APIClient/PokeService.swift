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
        if let cachedData = cacheManager.cachedResponse(
            for: request.endpoint,
            url: request.url
        ) {
            // Decode response
            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                return result
            } catch {
                throw error
            }
        }
        
        guard let urlRequest = self.request(from: request) else {
            throw PokeServiceError.failedToCreateRequest
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw PokeError.invalidServerResponse
        }
        
        // Decode response
        do {
            let result = try JSONDecoder().decode(type.self, from: data)
            cacheManager.setCache(
                for: request.endpoint,
                url: request.url,
                data: data
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
}
