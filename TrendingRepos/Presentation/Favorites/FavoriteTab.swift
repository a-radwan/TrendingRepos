//
//  FavoriteTab.swift
//  TrendingRepos
//
//  Created by Ahd on 9/3/24.
//

import SwiftUI

struct FavoriteTab: View {
    @State private var searchText = ""
    @State private var items: [String] = ["Item A", "Item B", "Item C"]
    
    var filteredItems: [String] {
        items.filter { item in
            searchText.isEmpty || item.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredItems, id: \.self) { item in
                    Text(item)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoriteTab()
}
