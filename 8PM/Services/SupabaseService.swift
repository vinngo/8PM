import Foundation
import Supabase

@MainActor
class SupabaseService{
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: SupabaseConfig.url)!,
            supabaseKey: SupabaseConfig.key
        )
    }
    
    var currentUserId: UUID? {
        guard let user = client.auth.currentUser else {return nil}
        return user.id
    }
}
