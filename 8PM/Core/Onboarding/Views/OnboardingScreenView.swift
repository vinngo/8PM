import SwiftUI

struct OnboardingScreenView: View {
    let iconName: String
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Icon
            Image(systemName: iconName)
                .font(.system(size: 80))
                .foregroundColor(.blue)

            // Title
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            // Description
            Text(description)
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
        }
    }
}

#Preview {
    OnboardingScreenView(
        iconName: "clock.fill",
        title: "What's 8PM?",
        description: "Every day, commit to ONE thing you'll do. Take a proof photo when you complete it. At 8 PM, everyone's posts go live together."
    )
}
