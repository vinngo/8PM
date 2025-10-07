import Foundation
import Auth


@MainActor
class AuthViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var verificationCode: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func sendVerificationCode(){
        Task{
            isLoading = true
            defer {isLoading = false}
            
            do {
                try await SupabaseService.shared.client.auth.signInWithOTP(phone: phoneNumber)
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func verifyCode(){
        Task {
            isLoading = true
            defer {isLoading = false}
            
            do {
                try await SupabaseService.shared.client.auth.verifyOTP(phone: phoneNumber, token: verificationCode, type: .sms)
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
