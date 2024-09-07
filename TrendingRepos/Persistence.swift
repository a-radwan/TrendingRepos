//
//  Persistence.swift
//  TrendingRepos
//
//  Created by Ahd on 9/2/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TrendingRepos")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveFavoriteRepositories(repositories: [Repository], completion: @escaping (Result<Void, Error>) -> Void) {
        let context = container.viewContext
        context.perform {
            for repo in repositories {
                let fetchRequest: NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", repo.id)
                
                do {
                    let results = try context.fetch(fetchRequest)
                    guard results.first == nil else {
                        completion(.success(()))
                        return;
                    }
                    let newRepo = RepositoryEntity(context: context)
                    newRepo.id = repo.id
                    newRepo.name = repo.name
                    newRepo.repoDescription = repo.description
                    newRepo.stargazersCount = Int32(repo.stargazersCount)
                    newRepo.forksCount = Int32(repo.forksCount)
                    newRepo.language = repo.language
                    newRepo.createdAt = repo.createdAt
                    newRepo.htmlURL = repo.htmlURL
                    newRepo.ownerLogin = repo.owner.login
                    newRepo.ownerAvatarURL = repo.owner.avatarURL
                    try context.save()
                    
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // Remove repositories from favorites
    func removeFavoriteRepositories(repositories: [Repository], completion: @escaping (Result<Void, Error>) -> Void) {
        let context = container.viewContext
        context.perform {
            for repo in repositories {
                let fetchRequest: NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", repo.id)
                
                do {
                    let results = try context.fetch(fetchRequest)
                    if let existingRepo = results.first {
                        context.delete(existingRepo)
                    }
                    try context.save()
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // Fetch favorite repositories
    func fetchFavoriteRepositories(completion: @escaping (Result<[Repository], Error>) -> Void) {
        let context = container.viewContext
        context.perform {
            let fetchRequest: NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
            
            do {
                let results = try context.fetch(fetchRequest)
                let repositories = results.map { self.mapToRepository(entity: $0) }
                completion(.success(repositories))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func mapToRepository(entity: RepositoryEntity) -> Repository {
        let owner = Owner(login: entity.ownerLogin ?? "", avatarURL: entity.ownerAvatarURL ?? "")
        
        return Repository(
            id: entity.id,
            owner: owner,
            name: entity.name ?? "",
            description: entity.repoDescription,
            stargazersCount: Int(entity.stargazersCount),
            forksCount: Int(entity.forksCount),
            language: entity.language,
            createdAt: entity.createdAt ?? Date(),
            htmlURL: entity.htmlURL ?? ""
        )
    }
    
}
