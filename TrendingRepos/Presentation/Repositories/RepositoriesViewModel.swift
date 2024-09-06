//
//  RepositoriesViewModel.swift
//  TrendingRepos
//
//  Created by Ahd on 9/3/24.
//

import Foundation
import Combine

enum DateFilter: String, CaseIterable {
    case lastDay = "Last Day"
    case lastWeek = "Last Week"
    case lastMonth = "Last Month"
    
    var queryDateParameter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        let date: Date
        
        switch self {
        case .lastDay:
            date = calendar.date(byAdding: .day, value: -1, to: Date())!
        case .lastWeek:
            date = calendar.date(byAdding: .weekOfYear, value: -1, to: Date())!
        case .lastMonth:
            date = calendar.date(byAdding: .month, value: -1, to: Date())!
        }
        
        return (dateFormatter.string(from: date))
    }
}

class RepositoriesViewModel: ObservableObject {
    @Published var searchText: String = "" {
        didSet {
            resetAndFetchData()
        }
    }
    @Published var selectedDateFilter: DateFilter = .lastDay {
        didSet {
            resetAndFetchData()
        }
    }
    @Published var repositories: [Repository] = []
    @Published var isLoading: Bool = false
    @Published var isFetchingNextPage: Bool = false
    @Published var hasMoreData: Bool = true
    @Published var errorMessage: String? = nil
    
    private var page = 1
    private let perPage = 20
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        loadRepositories()
    }
    
    private func resetAndFetchData() {
        repositories.removeAll()
        page = 1
        hasMoreData = true
        loadRepositories()
    }
    
    func loadRepositories() {
        guard !isLoading, hasMoreData else { return }
        
        isLoading = true
        errorMessage = nil
        
        GitHubService.shared.fetchRepositories(searchText: searchText, dateFilter: selectedDateFilter, page: page, perPage: perPage) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let repositories):
                self.repositories.append(contentsOf: repositories)
                self.hasMoreData = repositories.count == self.perPage
                self.page += 1
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.hasMoreData = false
            }
        }
    }
    
    func fetchNextPage() {
        guard !isFetchingNextPage, hasMoreData else { return }
        
        isFetchingNextPage = true
        GitHubService.shared.fetchRepositories(searchText: searchText, dateFilter: selectedDateFilter, page: page, perPage: perPage) { [weak self] result in
            guard let self = self else { return }
            self.isFetchingNextPage = false
            
            switch result {
            case .success(let repositories):
                self.repositories.append(contentsOf: repositories)
                self.hasMoreData = repositories.count == self.perPage
                self.page += 1
            case .failure(let error):
                self.hasMoreData = true
            }
        }
    }
}
