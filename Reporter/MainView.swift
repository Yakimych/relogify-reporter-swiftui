import SwiftUI

struct MainView: View {
    @EnvironmentObject private var playersInCommunitiesStorage: PlayersInCommunitiesStorage

    @State private var isAddingFirstCommunity: Bool = false

    var body: some View {
        if playersInCommunitiesStorage.items.isEmpty {
            NavigationView {
                ZStack {
                    RelogifyColors.relogifyLight
                    ChooseCommunity(isAddingPlayerInCommunity: $isAddingFirstCommunity)
                }
            }
        }
        else {
            ZStack {
                RelogifyColors.relogifyLight

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
                    About()
                        .tag(2)
                        .tabItem {
                            Image(systemName: "info.circle")
                            Text("About")
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
