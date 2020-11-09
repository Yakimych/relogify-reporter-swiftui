import SwiftUI

struct CommunityWithPlayer: Identifiable, Codable {
    let communityName: String
    let playerName: String
    let id: UUID
}

class CommunitiesWithPlayersStorage: ObservableObject {
    static private let storageKey = "CommunitiesWithPlayers"
    
    @Published var items = [CommunityWithPlayer]() {
        didSet {
            if let encoded = try? PropertyListEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: CommunitiesWithPlayersStorage.storageKey)
            }
        }
    }
    
    init() {
        items = CommunitiesWithPlayersStorage.getFromStorage()
    }
    
    private static func getFromStorage() -> [CommunityWithPlayer] {
        if let data = UserDefaults.standard.data(forKey: CommunitiesWithPlayersStorage.storageKey) {
            return (try? PropertyListDecoder().decode([CommunityWithPlayer].self, from: data)) ?? []
        }
        return []
    }
}
