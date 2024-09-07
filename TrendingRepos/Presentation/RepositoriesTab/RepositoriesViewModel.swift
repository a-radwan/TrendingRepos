//
//  RepositoriesViewModel.swift
//  TrendingRepos
//
//  Created by Ahd on 9/3/24.
//

import Foundation
import Combine

@MainActor
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
    
    //Paging
    private var currentPage = 1
    private let pageSize = 30
    private var totalCount: Int = 0
    
    private var didLoadInitialData = false
    private var cancellables: Set<AnyCancellable> = []
    
    private let gitHubService: GitHubServiceProtocol
    
    init(gitHubService: GitHubServiceProtocol = GitHubService.shared) {
        self.gitHubService = gitHubService
        Task {
            await loadRepositories()
            didLoadInitialData = true
        }
        setupSearchDebounce()
        
    }
    
    // Set up search text debouncing
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newSearchText in
                guard let self = self else { return }
                if didLoadInitialData {
                    self.resetAndFetchData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func resetAndFetchData() {
        repositories.removeAll()
        currentPage = 1
        hasMoreData = true
        totalCount = 0
        Task {
            await loadRepositories()
        }
    }
    
    func loadRepositories() async {
        
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await gitHubService.fetchRepositories(
                searchText: searchText,
                dateFilter: selectedDateFilter,
                page: currentPage,
                pageSize: pageSize
            )
            repositories.append(contentsOf: response.items)
            hasMoreData = repositories.count < response.totalCount
            totalCount = response.totalCount
            currentPage += 1
        } catch {
            errorMessage = error.localizedDescription
            hasMoreData = false
        }
        
        isLoading = false
    }
    
    func fetchNextPage() async {
        guard !isFetchingNextPage, hasMoreData else { return }
        
        isFetchingNextPage = true
        do {
            let response = try await gitHubService.fetchRepositories(
                searchText: searchText,
                dateFilter: selectedDateFilter,
                page: currentPage,
                pageSize: pageSize
            )
            repositories.append(contentsOf: response.items)
            totalCount = response.totalCount
            hasMoreData = repositories.count < totalCount
            currentPage += 1
        } catch {
            //Todo: handle faild to load the next page
            print("Error fetching next page: \(error)")
        }
        
        isFetchingNextPage = false
    }
}
