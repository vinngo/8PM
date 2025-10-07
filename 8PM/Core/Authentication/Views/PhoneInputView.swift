import SwiftUI

struct PhoneInputView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var showError = false

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Title
            Text("What's your phone number?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            // Phone input
            VStack(spacing: 16) {
                TextField("(555) 555-5555", text: $viewModel.phoneNumberDisplay)
                    .font(.title2)
                    .keyboardType(.phonePad)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .onChange(of: viewModel.phoneNumberDisplay) { oldValue, newValue in
                        viewModel.updatePhoneNumber(newValue)
                    }
                    .disabled(viewModel.isLoading)

                Text("We'll send you a verification code")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 32)

            Spacer()

            // Continue button
            Button {
                viewModel.sendVerificationCode()
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text("Continue")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(viewModel.isPhoneValid ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal, 32)
            .disabled(!viewModel.isPhoneValid || viewModel.isLoading)

            Spacer()
                .frame(height: 50)
        }
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
        .navigationDestination(isPresented: $viewModel.codeSent) {
            VerificationView(viewModel: viewModel)
        }
    }
}

#Preview {
    NavigationStack {
        PhoneInputView()
    }
}
