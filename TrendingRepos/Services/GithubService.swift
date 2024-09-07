//
//  GithubService.swift
//  TrendingRepos
//
//  Created by Ahd on 9/3/24.
//

import Foundation


import Foundation

class GitHubService {
    static let shared = GitHubService()
    
    private init() {}
    
    func fetchRepositories(
        searchText: String? = nil,
        dateFilter: DateFilter,
        page: Int = 1,
        pageSize: Int = 30
    ) async throws -> RepositorySearchResponse {
        
        let endPoint = "/search/repositories"
        
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
            return try await NetworkManager.shared.request(endpoint: endPoint, parameters: parameters)
        } catch {
            throw error
        }
    }
}
