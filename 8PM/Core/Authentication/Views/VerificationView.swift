import SwiftUI

struct VerificationView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var showError = false
    @FocusState private var isCodeFieldFocused: Bool

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Title
            VStack(spacing: 12) {
                Text("Enter your verification code")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(viewModel.phoneNumberDisplay)
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 32)

            // Code input
            TextField("000000", text: $viewModel.verificationCode)
                .font(.system(size: 40, weight: .medium, design: .rounded))
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal, 32)
                .focused($isCodeFieldFocused)
                .onChange(of: viewModel.verificationCode) { oldValue, newValue in
                    // Only allow digits and limit to 6
                    let filtered = newValue.filter { $0.isNumber }
                    viewModel.verificationCode = String(filtered.prefix(6))
                }
                .disabled(viewModel.isLoading)

            Spacer()

            // Verify button
            Button {
                viewModel.verifyCode()
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text("Verify")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(viewModel.isCodeValid ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal, 32)
            .disabled(!viewModel.isCodeValid || viewModel.isLoading)

            // Resend code button
            Button {
                viewModel.sendVerificationCode()
            } label: {
                Text("Resend Code")
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
            }
            .disabled(viewModel.isLoading)

            Spacer()
                .frame(height: 50)
        }
        .navigationBarBackButtonHidden(viewModel.isLoading)
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "An error occurred")
        }
        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
            showError = newValue != nil
        }
        .onAppear {
            isCodeFieldFocused = true
        }
        .navigationDestination(isPresented: $viewModel.isVerified) {
            ProfileSetupView()
        }
    }
}

#Preview {
    let viewModel = AuthViewModel()
    NavigationStack {
        VerificationView(viewModel: viewModel)
    }
}
