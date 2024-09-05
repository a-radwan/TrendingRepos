//
//  FavoritesViewModel.swift
//  TrendingRepos
//
//  Created by Ahd on 9/5/24.
//

import Foundation
import Combine

class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Repository] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""

    private let repositoriesManager = RepositoriesManager.shared
    private var cancellables = Set<AnyCancellable>()

    
    var filteredFavorites: [Repository] {
        if searchText.isEmpty {
            return favorites
        } else {
            return favorites.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.owner.login.localizedCaseInsensitiveContains(searchText) }
        }
    }

    init() {
        repositoriesManager.$favorites
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedFavorites in
                self?.favorites = updatedFavorites
            }
            .store(in: &cancellables)
    }

    func loadFavorites() {
        favorites = repositoriesManager.favorites
    }
}
