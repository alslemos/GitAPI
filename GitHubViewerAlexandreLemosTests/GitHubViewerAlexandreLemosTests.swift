import XCTest
@testable import GitHubViewerAlexandreLemos

class GitHubViewModelTests: XCTestCase {
    
    var viewModel: GitHubViewModel!
    var session: URLSession!
    
    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        
        viewModel = GitHubViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        session = nil
        MockURLProtocol.mockData = [:]
        MockURLProtocol.mockError = nil
        super.tearDown()
    }
    
    // MARK: - Helper Methods
    private func mockUserData() -> Data {
        let userJson = """
        {
            "login": "testuser",
            "avatar_url": "https://example.com/avatar.png"
        }
        """
        return userJson.data(using: .utf8)!
    }
    
    private func mockReposData() -> Data {
        let repoJson = """
        [
            { "id": 1, "name": "Repo1", "language": "Swift" }
        ]
        """
        return repoJson.data(using: .utf8)!
    }
    
    private func mockEmptyReposData() -> Data {
        return "[]".data(using: .utf8)!
    }
    
    // MARK: - Tests
    func testResetState() {
        // Given
        viewModel.user = GitHubUser(login: "testuser", avatar_url: nil)
        viewModel.repositories = [Repository(id: 1, name: "Repo1", language: "Swift")]
        viewModel.errorMessage = "Some error"
        
        // When
        viewModel.resetState()
        
        // Then
        XCTAssertNil(viewModel.user, "User should be nil after reset")
        XCTAssertTrue(viewModel.repositories.isEmpty, "Repositories should be empty after reset")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil after reset")
    }
    
    func testFetchUserSuccess() async {
        // Given
        let userUrl = URL(string: "https://api.github.com/users/testuser")!
        let reposUrl = URL(string: "https://api.github.com/users/testuser/repos")!
        
        MockURLProtocol.mockData = [
            userUrl: (mockUserData(), HTTPURLResponse(url: userUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!),
            reposUrl: (mockReposData(), HTTPURLResponse(url: reposUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        ]
        
        // When
        await viewModel.fetchUserAndRepos(username: "testuser")
        
        // Then
        XCTAssertEqual(viewModel.user?.login, "testuser", "User login should match")
        XCTAssertEqual(viewModel.repositories.count, 1, "There should be 1 repository")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil")
    }
    
    func testFetchUserWithEmptyRepos() async {
        // Given
        let userUrl = URL(string: "https://api.github.com/users/testuser")!
        let reposUrl = URL(string: "https://api.github.com/users/testuser/repos")!
        
        MockURLProtocol.mockData = [
            userUrl: (mockUserData(), HTTPURLResponse(url: userUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!),
            reposUrl: (mockEmptyReposData(), HTTPURLResponse(url: reposUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        ]
        
        // When
        await viewModel.fetchUserAndRepos(username: "testuser")
        
        // Then
        XCTAssertEqual(viewModel.user?.login, "testuser", "User login should match")
        XCTAssertTrue(viewModel.repositories.isEmpty, "Repositories should be empty")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil")
    }
    
    func testFetchUserNotFound() async {
        // Given
        let userUrl = URL(string: "https://api.github.com/users/testuser")!
        let response = HTTPURLResponse(url: userUrl, statusCode: 404, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.mockData = [userUrl: (Data(), response)]
        
        // When
        await viewModel.fetchUserAndRepos(username: "testuser")
        
        // Then
        XCTAssertNil(viewModel.user, "User should be nil when not found")
        XCTAssertTrue(viewModel.repositories.isEmpty, "Repositories should be empty when user not found")
        XCTAssertEqual(viewModel.errorMessage, "Failed to load data", "Error message should indicate failure")
    }
    
    func testFetchNetworkError() async {
        // Given
        MockURLProtocol.mockError = NSError(domain: "TestError", code: -1009, userInfo: nil)
        
        // When
        await viewModel.fetchUserAndRepos(username: "testuser")
        
        // Then
        XCTAssertNil(viewModel.user, "User should be nil on network error")
        XCTAssertTrue(viewModel.repositories.isEmpty, "Repositories should be empty on network error")
        XCTAssertEqual(viewModel.errorMessage, "Failed to load data", "Error message should indicate failure")
    }
    
    func testFetchInvalidJSON() async {
        // Given
        let userUrl = URL(string: "https://api.github.com/users/testuser")!
        let invalidJson = "{ invalid json }".data(using: .utf8)!
        MockURLProtocol.mockData = [userUrl: (invalidJson, HTTPURLResponse(url: userUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!)]
        
        // When
        await viewModel.fetchUserAndRepos(username: "testuser")
        
        // Then
        XCTAssertNil(viewModel.user, "User should be nil for invalid JSON")
        XCTAssertTrue(viewModel.repositories.isEmpty, "Repositories should be empty for invalid JSON")
        XCTAssertEqual(viewModel.errorMessage, "Failed to load data", "Error message should indicate failure")
    }
}

// MARK: - MockURLProtocol
class MockURLProtocol: URLProtocol {
    static var mockData: [URL: (Data, HTTPURLResponse)] = [:]
    static var mockError: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.mockError {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else if let url = request.url, let (data, response) = MockURLProtocol.mockData[url] {
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
        } else {
            let notFoundResponse = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            self.client?.urlProtocol(self, didReceive: notFoundResponse, cacheStoragePolicy: .notAllowed)
        }
        
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
