//
//  ContentView.swift
//  GitHubViewerAlexandreLemos
//
//  Created by Alexandre Lemos da Silva on 05/02/25.
//

import SwiftUI

struct ContentView: View {
    
    // main variable to call API
    @State private var gitUserToSearch: String = ""
    
    // a varable control navigation, started as false
    @State private var isNavigatingToDetailedInfo = false
    
    // creating a loading info
    @State private var isLoading = false
    
    // must create a new instance of the api caller
    // TODO: over here
    
    var body: some View {
        VStack {
            
            // main component as requested
            TextField(
                "Username",
                text: $gitUserToSearch, prompt: Text("Username")
            )
            .disableAutocorrection(true)
            .textFieldStyle(.roundedBorder)
            .padding()
            
            Button("Search") {
                
                // Reset error message and start loading
                isLoading = true
                
                // Trigger the API call
                Task {
                    
                    // main call
                    // TODO: create func
                    // something like fetchUserAndRepos(username: gitUserToSearch)
                    
                    // stop loading
                    isLoading = false
                    
                    // must navigate if everything was okk
                    // TODO: create if
                    // something lke
                    // if viewModel.errorMessage == nil {
                    // isNavigatingToDetailedInfo = true
                    // }
                }
                
            }
            .buttonStyle(.borderless)
            .controlSize(.large)
            
            // main navigation
            NavigationLink(
                //TODO: destination: DetailedInfo(viewModel: viewModel),
                isActive: $isNavigatingToDetailedInfo
            ) {
                EmptyView() // Invisible view
            }
        }
        .padding()
        .navigationTitle("GitHub Viewer")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
