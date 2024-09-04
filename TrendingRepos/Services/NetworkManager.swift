//
//  NetworkManager.swift
//  TrendingRepos
//
//  Created by Ahd on 9/4/24.
//

import Foundation


import Foundation

enum NetworkError: Error {
    case invalidResponse
    case serverError(statusCode: Int, message: String)
    case decodingError(Error)
    
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private let session = URLSession.shared
    
    
    private init() {}
    
    func request<T: Decodable>(
        endpoint: String,
        parameters: [String: String]? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {

        var urlComponents = URLComponents(string: baseURL + endpoint)!
        if let parameters = parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("token \(AuthToken)", forHTTPHeaderField: "Authorization")
        
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1, message: error.localizedDescription)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                let errorMessage: String
                if let data = data,
                   let responseDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let message = responseDict["message"] as? String {
                    errorMessage = message
                } else {
                    errorMessage = "An unknown error occurred."
                }
                DispatchQueue.main.async {
                    completion(.failure(.serverError(statusCode: httpResponse.statusCode, message: errorMessage)))
                }
                return
            }
            
            do {
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(.invalidResponse))
                    }
                    return;
                }
                
                let decodedResponse = try JSONDecoder().decode(T.self, from: data )
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
        task.resume()
    }
}
