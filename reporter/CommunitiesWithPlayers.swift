import SwiftUI

struct CommunityWithPlayer: Identifiable {
    let communityName: String
    let playerName: String
    let id: UUID
}

// TODO: Do we need this wrapper? Is it possible to use the array itself as an ObservableObject?
class CommunitiesWithPlayers: ObservableObject {
    @Published var communitiesWithPlayers: [CommunityWithPlayer]
    
    init(communitiesWithPlayers: [CommunityWithPlayer]) {
        self.communitiesWithPlayers = communitiesWithPlayers
    }
}
