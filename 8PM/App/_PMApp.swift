import SwiftUI

@main
struct EightPMApp: App {
    
    init() {
        // Test Supabase connection
        print("✅ Supabase connected to: \(SupabaseConfig.url)")
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
