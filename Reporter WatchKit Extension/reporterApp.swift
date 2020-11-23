import SwiftUI

@main
struct ReporterApp: App {
    @StateObject private var playersInCommunitiesStorage = PlayersInCommunitiesStorage()

    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(storage: playersInCommunitiesStorage)
                    .environmentObject(playersInCommunitiesStorage)
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
