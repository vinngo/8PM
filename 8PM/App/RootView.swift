import SwiftUI

struct RootView: View {
    @State private var isAuthenticated = false
    
    var body: some View {
        Group {
            if isAuthenticated {
                Text("Authenticated! (We'll build the real app here)")
                    .font(.title)
            } else {
                Text("Not authenticated (We'll build auth here)")
                    .font(.title)
            }
        }
        .onAppear {
            checkAuthStatus()
        }
    }
    
    private func checkAuthStatus() {
        // Check if user is logged in
        let client = SupabaseService.shared.client
        isAuthenticated = client.auth.currentSession != nil
    }
}

#Preview {
    RootView()
}
