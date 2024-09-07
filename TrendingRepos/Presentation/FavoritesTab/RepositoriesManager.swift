//
//  RepositoryManager.swift
//  TrendingRepos
//
//  Created by Ahd on 9/4/24.
//
import Foundation

class RepositoriesManager: ObservableObject {
    
    static let shared = RepositoriesManager()
    
    @Published var repositories: [Repository] = []
    @Published var favorites: [Repository] = []
    
    private let coreDataManager = PersistenceController.shared
    private let gitHubService = GitHubService.shared
        
    init() {
        fetchFavorites()
    }
    
    // Fetch favorites from Core Data
    func fetchFavorites() {
        coreDataManager.fetchFavoriteRepositories { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.favorites = repositories
            case .failure(let error):
                print("Error fetching favorites: \(error)")
            }
        }
    }
    
    func isFavorite(repository: Repository) -> Bool {
        return self.favorites.contains { $0.id == repository.id}
    }
    
    // Add a repository to favorites
    func addToFavorites(repository: Repository, completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataManager.saveFavoriteRepositories(repositories: [repository]) { [weak self] result in
            switch result {
            case .success:
                self?.favorites.append(repository)

            case .failure(let error):
                print("Error adding to favorites: \(error)")
            }
        }
    }
    
    //     Remove a repository from favorites
    func removeFromFavorites(repository: Repository, completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataManager.removeFavoriteRepositories(repositories: [repository]) { [weak self] result in
            switch result {
            case .success:
                self?.favorites.removeAll { $0.id == repository.id }
                
            case .failure(let error):
                print("Error removing from favorites: \(error)")
            }
        }
    }
}

