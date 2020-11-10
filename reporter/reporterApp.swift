import SwiftUI

@main
struct reporterApp: App {
    @StateObject private var communitiesWithPlayers = CommunitiesWithPlayersStorage()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(communitiesWithPlayers)
        }
    }
}
