import SwiftUI

@main
struct reporterApp: App {
    @StateObject var communitiesWithPlayers =
        CommunitiesWithPlayers(
            communitiesWithPlayers: [
                // TODO: Read from local storage. If empty - we're in the "FirstRun" state
                CommunityWithPlayer(communityName: "TestCommunity1", playerName: "TestPlayer1", id: UUID()),
                CommunityWithPlayer(communityName: "TestCommunity2", playerName: "TestPlayer2", id: UUID())
            ])
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(communitiesWithPlayers)
        }
    }
}
