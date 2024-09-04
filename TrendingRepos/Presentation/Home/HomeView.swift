//
//  HomeView.swift
//  TrendingRepos
//
//  Created by Ahd on 9/2/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            RepositoriesTab()
                .tabItem {
                    Image(systemName: "folder")
                    Text("Trending")
                }
            
            FavoriteTab()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
        }
    }
}
#Preview {
    HomeView()
}




