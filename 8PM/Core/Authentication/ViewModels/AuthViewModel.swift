import Foundation
import Auth


@MainActor
class AuthViewModel: ObservableObject {
    @Published var phoneNumberDisplay: String = ""
    @Published var verificationCode: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var codeSent: Bool = false

    private var phoneNumberRaw: String = ""

    var isPhoneValid: Bool {
        phoneNumberRaw.count == 10
    }

    var isCodeValid: Bool {
        verificationCode.count == 6
    }

    func updatePhoneNumber(_ input: String) {
        let digits = input.filter { $0.isNumber }
        phoneNumberRaw = String(digits.prefix(10))
        phoneNumberDisplay = formatPhoneNumber(phoneNumberRaw)
    }

    private func formatPhoneNumber(_ digits: String) -> String {
        var formatted = ""
        for (index, digit) in digits.enumerated() {
            if index == 0 { formatted += "(" }
            if index == 3 { formatted += ") " }
            if index == 6 { formatted += "-" }
            formatted.append(digit)
        }
        return formatted
    }
    
    func sendVerificationCode(){
        Task{
            isLoading = true
            defer {isLoading = false}

            do {
                let formattedPhone = "+1\(phoneNumberRaw)"
                try await SupabaseService.shared.client.auth.signInWithOTP(phone: formattedPhone)
                errorMessage = nil
                codeSent = true
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
                let formattedPhone = "+1\(phoneNumberRaw)"
                try await SupabaseService.shared.client.auth.verifyOTP(phone: formattedPhone, token: verificationCode, type: .sms)
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
