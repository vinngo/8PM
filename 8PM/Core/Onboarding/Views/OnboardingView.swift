import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var currentPage = 0
    @State private var showError = false

    private let screens: [(icon: String, title: String, description: String)] = [
        (
            icon: "clock.fill",
            title: "What's 8PM?",
            description: "Every day, commit to ONE thing you'll do. Prove to us that you can do what you say. At 8 PM, everyone's posts go live together."
        ),
        (
            icon: "target",
            title: "Set Your Thing",
            description: "Between 9-10 AM each day, choose your ONE daily commitment. It can be anything—working out, reading, coding, or calling a friend."
        ),
        (
            icon: "camera.fill",
            title: "Take Proof",
            description: "When you complete your thing, take a dual camera photo as proof. Front and back cameras capture both you and what you did."
        ),
        (
            icon: "bolt.fill",
            title: "The Drop",
            description: "At 8 PM sharp, everyone's posts unlock at once. See what your friends accomplished today and celebrate together. Don't miss the deadline; there are no exceptions."
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Tab View for swipeable screens
            TabView(selection: $currentPage) {
                ForEach(0..<screens.count, id: \.self) { index in
                    OnboardingScreenView(
                        iconName: screens[index].icon,
                        title: screens[index].title,
                        description: screens[index].description
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            // Bottom button
            Button {
                if currentPage < screens.count - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    viewModel.completeTutorial()
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text(currentPage < screens.count - 1 ? "Next" : "Get Started")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal, 32)
            .padding(.bottom, 50)
            .disabled(viewModel.isLoading)
        }
        .navigationBarBackButtonHidden(true)
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
        .navigationDestination(isPresented: $viewModel.tutorialCompleted) {
            Text("Main App (Coming Soon)")
                .font(.title)
                .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingView()
    }
}
