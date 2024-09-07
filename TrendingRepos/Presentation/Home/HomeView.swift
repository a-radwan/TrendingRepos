//
//  HomeView.swift
//  TrendingRepos
//
//  Created by Ahd on 9/2/24.
//

import SwiftUI

struct HomeView: View {
    let iconSize = 24.0
    
    var body: some View {
        TabView {
            RepositoriesTab()
                .tabItem {
                    Image(uiImage: UIImage(named: "github-mark")?.resized(toWidth: iconSize) ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: iconSize, height: iconSize)
                    Text("Trending")
                }
            
            FavoritesTab()
                .tabItem {
                    Image(systemName: "heart")
                        .frame(width: iconSize, height: iconSize)
                    Text("Favorites")
                }
        }
    }
}


#Preview {
    HomeView()
}




