//
//  DetailedView.swift
//  GitHubViewerAlexandreLemos
//
//  Created by Alexandre Lemos da Silva on 05/02/25.
//

import SwiftUI
import Foundation

struct DetailedInfo: View {
    @ObservedObject var viewModel: GitHubViewModel
    
    var body: some View {
        VStack {
            if let user = viewModel.user {
                
                ZStack {
                    
                    Color.blue
                
                    VStack {
                        if let avatarUrl = user.avatar_url, let url = URL(string: avatarUrl) {
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
                }.ignoresSafeArea()
               
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
            .listStyle(PlainListStyle())
            .listSectionSeparator(.hidden)
            .scrollContentBackground(.hidden)
        }
        .padding()
    }
}
