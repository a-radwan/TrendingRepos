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
            fetchData()
        }
    }
    @Published var selectedDateFilter: DateFilter = .lastDay {
        didSet {
            fetchData()
        }
    }
    @Published var repositories: [Repository] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    var error: Error? = nil {
        didSet {
            self.errorMessage = error?.localizedDescription
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        fetchData()
    }
    
    func loadRepositories() {
        fetchData()
    }
    
    private func fetchData() {
        isLoading = true
        error = nil
        
        GitHubService.shared.fetchRepositories(searchText: searchText, dateFilter: selectedDateFilter) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success(let repositories):
                self.repositories = repositories
            case .failure(let error):
                self.error = error
                print("Error fetching repositories: \(error)")
            }
        }
    }
}
