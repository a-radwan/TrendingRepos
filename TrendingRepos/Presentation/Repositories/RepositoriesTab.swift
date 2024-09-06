//
//  RepositoriesTab.swift
//  TrendingRepos
//
//  Created by Ahd on 9/3/24.
//

import SwiftUI



struct RepositoriesTab: View {
    @StateObject private var viewModel = RepositoriesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Date Filter", selection: $viewModel.selectedDateFilter) {
                    ForEach(DateFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.cyan)
                        .padding()
                    Spacer()
                } else if let errorMessage = viewModel.errorMessage {
                    // Show error view
                    Spacer()
                    
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        Text("Failed to load data.")
                            .font(.headline)
                            .padding()
                        Text(errorMessage)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                        Button(action: {
                            viewModel.loadRepositories()
                        }) {
                            Text("Retry")
                                .foregroundColor(.blue)
                        }
                        .padding()
                    }
                    .padding()
                    Spacer()
                } else if viewModel.repositories.isEmpty {
                    // Show empty data view
                    Spacer()
                    
                    VStack {
                        Image(systemName: "folder.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No repositories found.")
                            .font(.headline)
                            .padding()
                        Text("Try adjusting the filters or search text.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.repositories.indices, id: \.self) { index in
                            let repository = viewModel.repositories[index]
                            let detailsViewModel = RepositoryDetailsViewModel()
                            
                            NavigationLink(destination: RepositoryDetailsView(repository: repository, viewModel: detailsViewModel)) {
                                RepositoryRow(repository: repository)
                            }
                            .onAppear {
                                // Load next page when the last item appears
                                if index == viewModel.repositories.count - 1 {
                                    viewModel.fetchNextPage()
                                }
                            }
                        }
                        if viewModel.isFetchingNextPage {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .id(UUID())
                                Spacer()
                            }
                            .listRowSeparator(.hidden)
                        } else if !viewModel.hasMoreData {
                            HStack {
                                Spacer()
                                Text("No more repositories")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .padding()
                                Spacer()
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Trending")
        }
    }
}



struct RepositoryRow: View {
    let repository: Repository
    
    var body: some View {
        HStack(alignment: .top) {
            if let avatarURL = repository.owner.avatarURL {
                AsyncImage(url: URL(string: avatarURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } placeholder: {
                    PlaceholderImage()
                }
            } else {
                PlaceholderImage()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("\(repository.owner.login) / \(repository.name)")
                    .font(.headline)
                
                Text(repository.description ?? "No description available.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(repository.stargazersCount)")
                        .font(.subheadline)
                }
            }
            .padding(.leading, 8)
        }
        .padding(.vertical, 5)
    }
}


struct PlaceholderImage: View {
    var body: some View {
        
        Image(systemName: "person.crop.circle")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .foregroundColor(.gray)
    }
}

#Preview {
    RepositoriesTab()
}
