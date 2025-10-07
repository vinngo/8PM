import Foundation

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var tutorialCompleted: Bool = false

    func completeTutorial() {
        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                guard let userId = SupabaseService.shared.currentUserId else {
                    errorMessage = "No authenticated user found"
                    return
                }

                // Update tutorial_completed to true in Supabase
                try await SupabaseService.shared.client
                    .from("users")
                    .update(["tutorial_completed": true])
                    .eq("id", value: userId.uuidString)
                    .execute()

                errorMessage = nil
                tutorialCompleted = true
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
