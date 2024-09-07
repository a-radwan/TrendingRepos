//
//  RepositoryRow.swift
//  TrendingRepos
//
//  Created by Ahd on 9/7/24.
//

import SwiftUI
import Kingfisher
struct RepositoryRow: View {
    let repository: Repository
    
    private let imageSize: CGFloat = 50
    
    var body: some View {
        HStack(alignment: .top) {
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
            
            VStack(alignment: .leading, spacing: 5) {
                Text("\(repository.owner.login) / \(repository.name)")
                    .font(.headline)
                
                Text(repository.description ?? "No description available.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3) // Limit to 3 lines
                    .truncationMode(.tail)
            }
            .padding(.leading, 8)
        }
        .padding(.vertical, 5)
    }
}


#Preview {
    RepositoryRow(repository:Repository.sample)
}

