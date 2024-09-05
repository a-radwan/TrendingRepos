//
//  RepositoryDetailsView.swift
//  TrendingRepos
//
//  Created by Ahd on 9/3/24.
//

import SwiftUI

struct RepositoryDetailsView: View {
    var repository: Repository
    @ObservedObject var viewModel: RepositoryDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    if let avatarURL = repository.owner.avatarURL {
                        AsyncImage(url: URL(string: avatarURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } placeholder: {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .foregroundColor(.gray)
                        }
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .foregroundColor(.gray)
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
    
    RepositoryDetailsView(
        repository: Repository(
            id: 1,
            owner: Owner(login: "johnDoe", avatarURL: "https://via.placeholder.com/150"),
            name: "SampleRepo",
            description: "This is a sample repository.",
            stargazersCount: 123,
            forksCount: 10,
            language: "Swift",
            createdAt: Date(),
            htmlURL: "https://github.com/johnDoe/SampleRepo"
        ), viewModel: RepositoryDetailsViewModel(isFavorite: false)
    )
}
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()
