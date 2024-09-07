//
//  GithubService.swift
//  TrendingRepos
//
//  Created by Ahd on 9/3/24.
//

import Foundation


class GitHubService {
    static let shared = GitHubService()
    
    private init() {}
    
    func fetchRepositories(searchText: String? = nil,
                           dateFilter: DateFilter,
                           page: Int = 1,
                           pageSize: Int = 30,
                           completion: @escaping (Result<RepositorySearchResponse, NetworkError>) -> Void) {

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
        
        NetworkManager.shared.request(endpoint: endPoint,
                                      parameters: parameters) { (result: Result<RepositorySearchResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


