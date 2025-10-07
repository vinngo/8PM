import Foundation

@MainActor
class ProfileSetupViewModel: ObservableObject {
    @Published var displayName: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var profileCreated: Bool = false

    var isDisplayNameValid: Bool {
        displayName.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2 &&
        displayName.count <= 30
    }

    func saveProfile() {
        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                guard let userId = SupabaseService.shared.currentUserId else {
                    errorMessage = "No authenticated user found"
                    return
                }

                guard let phone = SupabaseService.shared.client.auth.currentUser?.phone else {
                    errorMessage = "Phone number not found"
                    return
                }

                let trimmedDisplayName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)

                // Create user profile in Supabase users table
                let userProfile = CreateUser(id: userId, phone: phone, displayName: trimmedDisplayName)

                try await SupabaseService.shared.client
                    .from("users")
                    .insert(userProfile)
                    .execute()

                errorMessage = nil
                profileCreated = true
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
