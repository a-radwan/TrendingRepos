//
//  GitHubServiceTests.swift
//  TrendingReposTests
//
//  Created by Ahd on 9/8/24.
//

import Foundation
import XCTest

@testable import TrendingRepos

class GitHubServiceTests: XCTestCase {
    var gitHubService: GitHubService!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        gitHubService = GitHubService(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        gitHubService = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func testFetchRepositoriesSuccess() async throws {
        // mock  response
        let mockOwner = Owner(login: "testuser", avatarURL: nil)
        let mockRepository = Repository(
            id: 10,
            owner: mockOwner,
            name: "Test Repo",
            description: "This is a description",
            stargazersCount: 42,
            forksCount: 12,
            language: "Swift",
            createdAt: Date(),
            htmlURL: "https://github.com/testuser/testrepo"
        )
        
        let mockResponse = RepositorySearchResponse(
            items: [mockRepository],
            totalCount: 1,
            incompleteResults: false
        )
        
        mockNetworkManager.mockResponse = mockResponse
        
        let result = try await gitHubService.fetchRepositories(dateFilter: .lastWeek)
        
        // Assertions
        XCTAssertEqual(result.totalCount, 1, "Total count should be 1")
        XCTAssertEqual(result.incompleteResults, false, "Incomplete results should be false")
        XCTAssertEqual(result.items.count, 1, "There should be exactly 1 repository")
        
        let repository = result.items.first
        XCTAssertNotNil(repository, "Repository should not be nil")
        XCTAssertEqual(repository?.id, 10, "Repository ID should be 10")
        XCTAssertEqual(repository?.name, "Test Repo", "Repository name should be 'Test Repo'")
        XCTAssertEqual(repository?.owner.login, "testuser", "Owner login should be 'testuser'")
        XCTAssertNil(repository?.owner.avatarURL, "Avatar URL should be nil")
    }
    
    func testFetchRepositoriesFailure() async {
        mockNetworkManager.mockError = NetworkError.serverError(statusCode: 500, message: "Internal Server Error")
        
        do {
            _ = try await gitHubService.fetchRepositories(dateFilter: .lastWeek)
            XCTFail("Expected to fail with serverError, but succeeded.")
        } catch let error as NetworkError {
            switch error {
            case .serverError(let statusCode, let message):
                XCTAssertEqual(statusCode, 500)
                XCTAssertEqual(message, "Internal Server Error")
            default:
                XCTFail("Expected serverError, but got \(error).")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
