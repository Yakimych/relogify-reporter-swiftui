import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @EnvironmentObject private var playersInCommunitiesStorage: PlayersInCommunitiesStorage

    @State private var communitiesWithPlayersRemoteData: RemoteData<Dictionary<String, [PlayerInCommunity]>> = .loading

    private func loadData(communityNames: [String]) {
        Network.shared.apollo.fetch(query: GetPlayersForCommunitiesQuery(communityNames: communityNames)) { result in
            var loadedCommunitiesWithPlayers: [PlayerInCommunity] = []
            switch result {
                case .success(let graphQLResult):
                    for player in graphQLResult.data!.players {
                        loadedCommunitiesWithPlayers.append(PlayerInCommunity(communityName: player.community.name, playerName: player.name, id: UUID()))
                    }

                    let groupedCommunitiesWithPlayers = Dictionary(grouping: loadedCommunitiesWithPlayers, by: { $0.communityName })

                    self.communitiesWithPlayersRemoteData = .loaded(groupedCommunitiesWithPlayers)
                case .failure:
                    self.communitiesWithPlayersRemoteData = .error
            }
        }
    }

    var body: some View {
        VStack {
            switch communitiesWithPlayersRemoteData {
                case .loading:
                    ProgressView()

                case .loaded(let communitiesWithOpponents):
                    Text("Players in communities")
                    List {
                        ForEach(playersInCommunitiesStorage.items) { playerInCommunity in
                            let opponentsInCommunity = communitiesWithOpponents[playerInCommunity.communityName] ?? []
                            let opponentNames = opponentsInCommunity.map({ $0.playerName }).filter({ $0 != playerInCommunity.playerName })

                            NavigationLink(destination: OpponentsInCommunity(communityName: playerInCommunity.communityName, playerName: playerInCommunity.playerName, opponentList: opponentNames)) {
                                Text("\(playerInCommunity.communityName) (\(playerInCommunity.playerName))")
                            }
                        }
                    }
                case .error:
                    Text("Failed to fetch opponent list, please check your internet connection and try again")
            }
        }
        .onAppear {
            if !playersInCommunitiesStorage.items.isEmpty {
                loadData(communityNames: playersInCommunitiesStorage.items.map({ $0.communityName }))
            }
        }
    }
}
