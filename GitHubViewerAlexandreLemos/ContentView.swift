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
            
            TextField(
                "Username",
                text: $gitUserToSearch, prompt: Text("Username")
            )
            .disableAutocorrection(true)
            .textFieldStyle(.roundedBorder)
            .padding()
            
            Button("Search") {
                
                // Must trigger and validate gitUserToSearch
                
            }
            .buttonStyle(.borderless)
            .controlSize(.large)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
