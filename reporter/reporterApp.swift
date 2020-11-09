import SwiftUI

@main
struct reporterApp: App {
    @StateObject var communitiesWithPlayers = CommunitiesWithPlayersStorage()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(communitiesWithPlayers)
        }
    }
}
