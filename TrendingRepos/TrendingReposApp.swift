//
//  TrendingReposApp.swift
//  TrendingRepos
//
//  Created by Ahd on 9/2/24.
//

import SwiftUI

@main
struct TrendingReposApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
