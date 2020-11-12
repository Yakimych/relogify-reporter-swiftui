import SwiftUI

struct PlayerInCommunity: Identifiable, Codable {
    let communityName: String
    let playerName: String
    let id: UUID
}

class PlayersInCommunitiesStorage: ObservableObject {
    static private let storageKey = "PlayersInCommunities"

    @Published var items = [PlayerInCommunity]() {
        didSet {
            if let encoded = try? PropertyListEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: PlayersInCommunitiesStorage.storageKey)
            }
        }
    }

    init() {
        items = PlayersInCommunitiesStorage.getFromStorage()
    }

    private static func getFromStorage() -> [PlayerInCommunity] {
        if let data = UserDefaults.standard.data(forKey: PlayersInCommunitiesStorage.storageKey) {
            return (try? PropertyListDecoder().decode([PlayerInCommunity].self, from: data)) ?? []
        }
        return []
    }
}
