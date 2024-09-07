//
//  RepositoryDetailsView.swift
//  TrendingRepos
//
//  Created by Ahd on 9/3/24.
//

import SwiftUI
import Kingfisher

struct RepositoryDetailsView: View {
    var repository: Repository
    @ObservedObject var viewModel: RepositoryDetailsViewModel
    
    private let imageSize: CGFloat = 100
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    if let avatarURL = repository.owner.avatarURL, let url = URL(string: avatarURL) {
                        KFImage(url)
                            .placeholder {
                                CircularPlaceholderImage(diameter: imageSize)
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageSize, height: imageSize)
                            .clipShape(Circle())
                    } else {
                        CircularPlaceholderImage(diameter: imageSize)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(repository.owner.login) / \(repository.name)")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("Stars: \(repository.stargazersCount)")
                    
                    Spacer()
                    
                    Image(systemName: "tuningfork")
                    Text("Forks: \(repository.forksCount)")
                }
                .font(.headline)
                
                if let language = repository.language {
                    HStack {
                        Image(systemName: "chevron.left.slash.chevron.right")
                        Text("Language: \(language)")
                    }
                    .font(.headline)
                }
                
                HStack {
                    Image(systemName: "calendar")
                    Text("Created on: \(repository.createdAt, formatter: dateFormatter)")
                }
                .font(.headline)
                
                Link(destination: URL(string: repository.htmlURL) ?? URL(string: "https://github.com/")!) {
                    HStack {
                        Image(systemName: "link")
                        Text("View on GitHub")
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                }
                
                Text(repository.description ?? "No description available.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle(repository.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleFavorite(repository: repository) { result in
                        switch result {
                        case .success(let isFavorite):
                            break
                        case .failure(let error):
                            print("Error toggling favorite: \(error)")
                        }
                    }
                }) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite ? .red : .gray)
                }
            }
        }
        .onAppear {
            viewModel.checkIfFavorite(repository: repository)
        }
    }
}

#Preview {
        
    RepositoryDetailsView(repository:Repository.sample , viewModel: RepositoryDetailsViewModel(isFavorite: false))
}
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()
