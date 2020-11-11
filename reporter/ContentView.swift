import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var playersInCommunitiesStorage: PlayersInCommunitiesStorage

    @State private var isAddingFirstCommunity: Bool = false

    var body: some View {
        if playersInCommunitiesStorage.items.isEmpty {
            NavigationView {
                VStack {
                    ChooseCommunity(isAddingPlayerInCommunity: $isAddingFirstCommunity)
                }
            }
        }
        else {
            TabView {
                OpponentList(playersInCommunitiesStorage: playersInCommunitiesStorage)
                    .tag(0)
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Opponents")
                    }
                SettingsView()
                    .tag(1)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                Text("About")
                    .tag(2)
                    .tabItem {
                        Image(systemName: "info.circle")
                        Text("About")
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
