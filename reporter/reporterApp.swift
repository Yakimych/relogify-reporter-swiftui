import SwiftUI

@main
struct reporterApp: App {
    @StateObject private var playersInCommunitiesStorage = PlayersInCommunitiesStorage()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(playersInCommunitiesStorage)
        }
    }
}
