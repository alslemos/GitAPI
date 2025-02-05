//
//  Entities.swift
//  GitHubViewerAlexandreLemos
//
//  Created by Alexandre Lemos da Silva on 05/02/25.
//

import Foundation

struct GitHubUser: Codable {
    let login: String
    let avatarLink: String?
}

struct Repository: Codable, Identifiable {
    let id: Int
    let name: String
    let language: String?
}
