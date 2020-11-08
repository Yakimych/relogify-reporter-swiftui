import SwiftUI

struct CommunityWithPlayer: Identifiable, Codable {
    let communityName: String
    let playerName: String
    let id: UUID
}

// TODO: Do we need this wrapper? Is it possible to use the array itself as an ObservableObject?
class CommunitiesWithPlayers: ObservableObject {
    @Published var communitiesWithPlayers: [CommunityWithPlayer]
    
    init() {
        communitiesWithPlayers = CommunitiesWithPlayers.getFromStorage()
    }
    
    private func saveToStorage() {
        if let encoded = try? JSONEncoder().encode(communitiesWithPlayers) {
            UserDefaults.standard.set(encoded, forKey: "CommunitiesWithPlayers")
        }
    }
    
    private static func getFromStorage() -> [CommunityWithPlayer] {
        if let communitiesWithPlayersData = UserDefaults.standard.data(forKey: "CommunitiesWithPlayers") {
            return (try? JSONDecoder().decode([CommunityWithPlayer].self, from: communitiesWithPlayersData)) ?? []
        }
        return []
    }
    
    func add(communityWithPlayer: CommunityWithPlayer) {
        communitiesWithPlayers.append(communityWithPlayer)
        saveToStorage()
    }
    
    // TODO: Remove
}
