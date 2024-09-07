//
//  RepositoryDetailsViewModel.swift
//  TrendingRepos
//
//  Created by Ahd on 9/5/24.
//

import Foundation

class RepositoryDetailsViewModel: ObservableObject {
    @Published var isFavorite: Bool
    
    private let repositoriesManager = RepositoriesManager.shared
    
    init(isFavorite: Bool = false) {
        self.isFavorite = isFavorite
    }
    
    func checkIfFavorite(repository: Repository) {
        isFavorite = repositoriesManager.isFavorite(repository: repository);
    }
    
    func toggleFavorite(repository: Repository, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        
        if isFavorite {
            self.isFavorite = false
            
            repositoriesManager.removeFromFavorites(repository: repository) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        completion(.success(false))
                    case .failure(let error):
                        self?.isFavorite.toggle()
                        completion(.failure(error))
                    }
                }
            }
        } else {
            self.isFavorite = true
            
            repositoriesManager.addToFavorites(repository: repository) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        completion(.success(true))
                    case .failure(let error):
                        self?.isFavorite.toggle()
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
