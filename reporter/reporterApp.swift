import SwiftUI

@main
struct reporterApp: App {
    @StateObject var communitiesWithPlayers = CommunitiesWithPlayers()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(communitiesWithPlayers)
        }
    }
}
