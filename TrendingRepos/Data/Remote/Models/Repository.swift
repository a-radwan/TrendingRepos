//
//  Repository.swift
//  TrendingRepos
//
//  Created by Ahd on 9/3/24.
//

import Foundation

struct RepositorySearchResponse: Codable {
    let items: [Repository]
    let totalCount: Int
    let incompleteResults: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
    }
}

struct Owner: Codable {
    let login: String
    let avatarURL: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}

struct Repository: Codable, Identifiable {
    let id: Int32
    let owner: Owner
    let name: String
    let description: String?
    let stargazersCount: Int
    let forksCount: Int
    let language: String?
    let createdAt: Date
    let htmlURL: String

    enum CodingKeys: String, CodingKey {
        case id, owner, name, description, language
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case createdAt = "created_at"
        case htmlURL = "html_url"
    }
    
    static let sample = Repository(
        id: 1,
        owner: Owner(login: "Julia", avatarURL: nil),
        name: "SampleRepo",
        description: "This is a sample repository.",
        stargazersCount: 123,
        forksCount: 10,
        language: "Swift",
        createdAt: Date(),
        htmlURL: "https://github.com/"
    )

}

extension Repository {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int32.self, forKey: .id)
        owner = try container.decode(Owner.self, forKey: .owner)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        stargazersCount = try container.decode(Int.self, forKey: .stargazersCount)
        forksCount = try container.decode(Int.self, forKey: .forksCount)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        htmlURL = try container.decode(String.self, forKey: .htmlURL)
        
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: createdAtString) {
            createdAt = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .createdAt,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}
