//
//  DetailedView.swift
//  GitHubViewerAlexandreLemos
//
//  Created by Alexandre Lemos da Silva on 05/02/25.
//

import Foundation
import SwiftUI

struct DetailedView: View {
    @ObservedObject var viewModel: GitHubViewModel
    
    var body: some View {
        VStack {
            if let user = viewModel.user {
                VStack {
                    
                    if let avatarUrl = user.avatarLink, let url = URL(string: avatarUrl) {
                        
                        // async image
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    }
                    Text(user.login)
                        .font(.title)
                }
                .padding()
            }
            
            List(viewModel.repositories) { repo in
                VStack(alignment: .leading) {
                    Text(repo.name)
                        .font(.headline)
                    Text(repo.language ?? "Unknown Language")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
    }
    
}
