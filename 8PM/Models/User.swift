import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    let phone: String
    let displayName: String
    let avatarUrl: String?
    let bio: String?
    let isPublic: Bool
    let tutorialCompleted: Bool
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case phone
        case displayName = "display_name"
        case avatarUrl = "avatar_url"
        case bio
        case isPublic = "is_public"
        case tutorialCompleted = "tutorial_completed"
        case createdAt = "created_at"
    }
}
