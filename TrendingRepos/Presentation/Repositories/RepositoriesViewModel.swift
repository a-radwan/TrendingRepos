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
    @Published var searchText: String = ""
    @Published var selectedDateFilter: DateFilter = .lastWeek {
        didSet {
            resetAndFetchData()
        }
    }
    @Published var repositories: [Repository] = []
    @Published var isLoading: Bool = false
    @Published var isFetchingNextPage: Bool = false
    @Published var hasMoreData: Bool = true
    @Published var errorMessage: String? = nil
    
    private var currentPage = 1
    private let pageSize = 30
    private var totalCount: Int = 0
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        setupSearchDebounce()
    }
    
    // Set up search text debouncing
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newSearchText in
                guard let self = self else { return }
                self.resetAndFetchData()
            }
            .store(in: &cancellables)
    }
    
    private func resetAndFetchData() {
        repositories.removeAll()
        currentPage = 1
        hasMoreData = true
        totalCount = 0
        loadRepositories()
        
    }
    
    func loadRepositories() {

        guard !isLoading, hasMoreData else { return }
        
        isLoading = true
        errorMessage = nil
        
        GitHubService.shared.fetchRepositories(searchText: searchText, dateFilter: selectedDateFilter, page: currentPage, pageSize: pageSize) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let response):
                self.repositories.append(contentsOf: response.items)
                self.hasMoreData = repositories.count == self.pageSize
                self.totalCount = response.totalCount
                self.currentPage += 1
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.hasMoreData = false
            }
        }
    }
    
    func fetchNextPage() {
        guard !isFetchingNextPage, hasMoreData else { return }
        
        isFetchingNextPage = true
        GitHubService.shared.fetchRepositories(searchText: searchText, dateFilter: selectedDateFilter, page: currentPage, pageSize: pageSize) { [weak self] result in
            guard let self = self else { return }
            self.isFetchingNextPage = false
            
            switch result {
            case .success(let response):
                self.repositories.append(contentsOf: response.items)
                self.totalCount = response.totalCount
                self.hasMoreData = self.repositories.count < self.totalCount
                self.currentPage += 1
            case .failure(let error):
                //Todo: handle faild to load the next page/
                print("Error fetching next page: \(error)")
                break;
            }
        }
    }
}
