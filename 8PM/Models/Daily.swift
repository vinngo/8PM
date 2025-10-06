import Foundation

struct DailyThing: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let thing: String
    let date: Date
    var proofLocked: Bool
    var proofTimestamp: Date?
    var proofHash: String?
    var frontPhotoUrl: String?
    var backPhotoUrl: String?
    var postedAt: Date?
    var completed: Bool
    var latePost: Bool
    var didntCompleteReason: String?
    let createdAt: Date
    
    // For feed display
    var user: User?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case thing
        case date
        case proofLocked = "proof_locked"
        case proofTimestamp = "proof_timestamp"
        case proofHash = "proof_hash"
        case frontPhotoUrl = "front_photo_url"
        case backPhotoUrl = "back_photo_url"
        case postedAt = "posted_at"
        case completed
        case latePost = "late_post"
        case didntCompleteReason = "didnt_complete_reason"
        case createdAt = "created_at"
    }
}
