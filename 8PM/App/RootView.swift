import SwiftUI

struct RootView: View {
    @State private var isAuthenticated = false
    @State private var userProfile: User? = nil
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView()
                } else if !isAuthenticated {
                    PhoneInputView()
                } else if let user = userProfile {
                    if user.tutorialCompleted {
                        Text("Main App (Coming Soon)")
                            .font(.title)
                    } else {
                        OnboardingView()
                    }
                } else {
                    // Authenticated but no profile yet (should be handled by auth flow)
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
        Task {
            isLoading = true
            defer { isLoading = false }

            let client = SupabaseService.shared.client
            isAuthenticated = client.auth.currentSession != nil

            if isAuthenticated, let userId = SupabaseService.shared.currentUserId {
                // Fetch user profile from Supabase
                do {
                    let response: User = try await client
                        .from("users")
                        .select()
                        .eq("id", value: userId.uuidString)
                        .single()
                        .execute()
                        .value

                    userProfile = response
                } catch {
                    // Profile doesn't exist yet, will be created in auth flow
                    userProfile = nil
                }
            } else {
                userProfile = nil
            }
        }
    }
}

#Preview {
    RootView()
}
