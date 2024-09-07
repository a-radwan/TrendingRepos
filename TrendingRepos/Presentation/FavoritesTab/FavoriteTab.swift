//
//  FavoriteTab.swift
//  TrendingRepos
//
//  Created by Ahd on 9/3/24.
//

import SwiftUI
struct FavoritesTab: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.cyan)
                        .padding()
                    Spacer()
                } else if viewModel.filteredFavorites.isEmpty {
                    Spacer()
                    VStack {
                        Image(uiImage: UIImage(named: "github-mark")?.resized(toWidth: 50) ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                        
                        if viewModel.searchText.isEmpty {
                            Text("No favorites found.")
                                .font(.headline)
                                .padding()
                            Text("You haven't added any repositories to favorites.")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                        } else {
                            Text("No matching repositories.")
                                .font(.headline)
                                .padding()
                            Text("Try another search term.")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding()
                    Spacer()
                } else {
                    List(viewModel.filteredFavorites) { repository in
                        let detailsViewModel = RepositoryDetailsViewModel(isFavorite: true)
                        
                        NavigationLink(destination: RepositoryDetailsView(repository: repository, viewModel: detailsViewModel)) {
                            RepositoryRow(repository: repository)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search favorites")
            .navigationTitle("Favorites")
            .onAppear {
                viewModel.loadFavorites()
            }
        }
    }
}



#Preview {
    FavoritesTab()
}
