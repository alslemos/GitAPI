import SwiftUI

struct DetailedInfo: View {
    @ObservedObject var viewModel: GitHubViewModel
    
    var body: some View {
        ZStack {
            // Blue background
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            
            // Vertical stack
            VStack(alignment: .center) {
                
                // User info section
                if let user = viewModel.user {
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
                        
                        Text(user.login.capitalizedSentence)
                            .font(.title3)
                            .padding()
                    }
                    .padding(.top, 80) // Add padding to the top
                }
                
                
                // List of repositories
                VStack(alignment: .leading) {
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
                    .scrollContentBackground(.hidden)
                }
                .ignoresSafeArea()
            }
            .ignoresSafeArea(.all)
        }
    }
}
