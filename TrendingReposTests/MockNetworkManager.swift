//
//  MockNetworkManager.swift
//  TrendingReposTests
//
//  Created by Ahd on 9/8/24.
//

import Foundation
@testable import TrendingRepos

class MockNetworkManager: NetworkManagingProtocol {
    var mockResponse: Any?
    var mockError: Error?

    func request<T: Decodable>(
        endpoint: String,
        parameters: [String : String]?
    ) async throws -> T {
        if let error = mockError {
            throw error
        }
        return mockResponse as! T
    }
}
