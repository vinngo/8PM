import SwiftUI

struct RootView: View {
    @State private var isAuthenticated = false

    var body: some View {
        NavigationStack {
            Group {
                if isAuthenticated {
                    Text("Authenticated! (We'll build the real app here)")
                        .font(.title)
                } else {
                    PhoneInputView()
                }
            }
        }
        .onAppear {
            checkAuthStatus()
        }
        .onChange(of: SupabaseService.shared.client.auth.currentSession) { oldValue, newValue in
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
