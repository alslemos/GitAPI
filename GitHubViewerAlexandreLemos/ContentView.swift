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
    
    // a variable control navigation, started as false
    @State private var isNavigatingToDetailedInfo = false
    
    // creating a loading info
    @State private var isLoading = false
    
    // a new instance of the api caller
    @StateObject private var viewModel = GitHubViewModel()
    
    // controll alarm
    @State private var showingAlert = false
    
    var body: some View {
        
        NavigationView {
            
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
                    viewModel.resetState()
                    isLoading = true
                    
                    // Trigger the API call
                    Task {
                        // main call
                        await viewModel.fetchUserAndRepos(username: gitUserToSearch)
                        
                        // stop loading
                        isLoading = false
                        
                        // must navigate if everything was okk
                        // Navigate only if there's no error
                        if viewModel.errorMessage == nil {
                            isNavigatingToDetailedInfo = true
                        } else {
                            showingAlert = true
                        }
                    }
                    
                }
                .buttonStyle(.borderless)
                .controlSize(.large)
                .alert("Attention", isPresented: $showingAlert) {
                    Button("Ok", role: .cancel) {}
                } message: {
                    Text("User not found. Please enter another name")
                }
                
                // loading indicator
                if isLoading {
                    ProgressView()
                        .padding()
                }
                
                // error message
                if let errorMessage = viewModel.errorMessage {
                    
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                
                // main navigation
                NavigationLink(
                    destination: DetailedInfo(viewModel: viewModel),
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
}

#Preview {
    ContentView()
}
