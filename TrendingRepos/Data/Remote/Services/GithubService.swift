//
//  GithubService.swift
//  TrendingRepos
//
//  Created by Ahd on 9/3/24.
//

import Foundation


import Foundation

protocol GitHubServiceProtocol {
    func fetchRepositories(
        searchText: String?,
        dateFilter: DateFilter,
        page: Int,
        pageSize: Int
    ) async throws -> RepositorySearchResponse
}

class GitHubService: GitHubServiceProtocol {
    
    static let shared = GitHubService()
        
    private let networkManager: NetworkManagingProtocol
    
    init(networkManager: NetworkManagingProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    
    func fetchRepositories(
        searchText: String? = nil,
        dateFilter: DateFilter,
        page: Int = 1,
        pageSize: Int = 30
    ) async throws -> RepositorySearchResponse {
        
        let endPoint = repositoriesEndPoint
        
        var queryParameter = "created:>\(dateFilter.queryDateParameter)"
        if let searchText = searchText, !searchText.isEmpty {
            queryParameter = "\(searchText)+\(queryParameter)"
        }
        
        let parameters = [
            "q": queryParameter,
            "sort": "stars",
            "order": "desc",
            "page": String(page),
            "per_page": String(pageSize)
        ]
        
        do {
            return try await networkManager.request(endpoint: endPoint, parameters: parameters)
        } catch {
            throw error
        }
    }
}
