import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @EnvironmentObject private var playersInCommunitiesStorage: PlayersInCommunitiesStorage

    var body: some View {
        VStack {
            Text("Players in communities")
            List {
                ForEach(playersInCommunitiesStorage.items) { playerInCommunity in
                    Text("\(playerInCommunity.communityName) (\(playerInCommunity.playerName))")
                }
            }
        }
    }
}
