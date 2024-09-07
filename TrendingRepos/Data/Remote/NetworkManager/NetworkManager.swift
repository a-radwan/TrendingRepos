//
//  NetworkManager.swift
//  TrendingRepos
//
//  Created by Ahd on 9/4/24.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case serverError(statusCode: Int, message: String)
    case decodingError(Error)
}

protocol NetworkManagingProtocol {
    func request<T: Decodable>(
        endpoint: String,
        parameters: [String: String]?
    ) async throws -> T
}


class NetworkManager: NetworkManagingProtocol {
    static let shared = NetworkManager()
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(
        endpoint: String,
        parameters: [String: String]? = nil
    ) async throws -> T {
        
        var urlComponents = URLComponents(string: baseURL + endpoint)!
        if let parameters = parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("token \(AuthToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage: String
            if let responseDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let message = responseDict["message"] as? String {
                errorMessage = message
            } else {
                errorMessage = "An unknown error occurred."
            }
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: errorMessage)
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
