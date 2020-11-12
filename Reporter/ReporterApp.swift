import SwiftUI

@main
struct ReporterApp: App {
    @StateObject private var playersInCommunitiesStorage = PlayersInCommunitiesStorage()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(playersInCommunitiesStorage)
        }
    }
}
