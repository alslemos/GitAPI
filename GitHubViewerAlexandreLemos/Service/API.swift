//
//  API.swift
//  GitHubViewerAlexandreLemos
//
//  Created by Alexandre Lemos da Silva on 05/02/25.
//

import Foundation

class GitHubViewModel: ObservableObject, Sendable {
    @Published var user: GitHubUser?
    @Published var repositories: [Repository] = []
    @Published var errorMessage: String?
    
    func resetState() {
            user = nil
            repositories = []
            errorMessage = nil
    }
    
    func fetchUserAndRepos(username: String) async {
        guard let userUrl = URL(string: "https://api.github.com/users/\(username)"),
              let reposUrl = URL(string: "https://api.github.com/users/\(username)/repos") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
            }
            return
        }
        
        async let (userData, _) = URLSession.shared.data(from: userUrl)
        async let (reposData, _) = URLSession.shared.data(from: reposUrl)
        
        do {
            let user = try JSONDecoder().decode(GitHubUser.self, from: try await userData)
            let repos = try JSONDecoder().decode([Repository].self, from: try await reposData)
            DispatchQueue.main.async {
                self.user = user
                self.repositories = repos
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to load data"
            }
        }
    }
}
