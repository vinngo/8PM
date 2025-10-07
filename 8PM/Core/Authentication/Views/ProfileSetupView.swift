import SwiftUI

struct ProfileSetupView: View {
    @StateObject private var viewModel = ProfileSetupViewModel()
    @State private var showError = false
    @FocusState private var isDisplayNameFocused: Bool

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Title
            Text("Create Your Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            // Display name input
            VStack(spacing: 16) {
                TextField("Display Name", text: $viewModel.displayName)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .focused($isDisplayNameFocused)
                    .onChange(of: viewModel.displayName) { oldValue, newValue in
                        // Limit to 30 characters
                        if newValue.count > 30 {
                            viewModel.displayName = String(newValue.prefix(30))
                        }
                    }
                    .disabled(viewModel.isLoading)

                Text("2-30 characters")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 32)

            Spacer()

            // Get Started button
            Button {
                viewModel.saveProfile()
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text("Get Started")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(viewModel.isDisplayNameValid ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal, 32)
            .disabled(!viewModel.isDisplayNameValid || viewModel.isLoading)

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
            isDisplayNameFocused = true
        }
    }
}

#Preview {
    NavigationStack {
        ProfileSetupView()
    }
}
