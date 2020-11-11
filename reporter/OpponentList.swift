import SwiftUI

struct OpponentList: View {
    let playersInCommunitiesStorage: PlayersInCommunitiesStorage

    @State private var selectedPlayerInCommunity: PlayerInCommunity
    @State private var communitiesWithPlayersRemoteData: RemoteData<Dictionary<String, [PlayerInCommunity]>> = .loading

    init(playersInCommunitiesStorage: PlayersInCommunitiesStorage) {
        self.playersInCommunitiesStorage = playersInCommunitiesStorage
        _selectedPlayerInCommunity = State(initialValue: playersInCommunitiesStorage.items[0])
    }

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
                    print("Success! Timestamp: \(Date()) Result: \(String(describing: groupedCommunitiesWithPlayers))")
                case .failure(let error):
                    print("Failure! Error: \(error)")
            }
        }
    }

    private func getCommunityTabColor(communityName: String) -> Color {
        if communityName == selectedPlayerInCommunity.communityName {
            return Color.red
        }
        return Color.white
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, content: {
                HStack {
                    ForEach(playersInCommunitiesStorage.items) {
                        communityWithPlayer in
                        Button(communityWithPlayer.communityName, action: { selectedPlayerInCommunity = communityWithPlayer })
                            .background(getCommunityTabColor(communityName: communityWithPlayer.communityName))
                    }
                }

                switch communitiesWithPlayersRemoteData {
                    case .loading:
                        Text("Loading...")
                    case .loaded(let communitiesWithOpponents):
                        let selectedCommunityWithPlayers = communitiesWithOpponents[selectedPlayerInCommunity.communityName] ?? []

                        List(selectedCommunityWithPlayers
                                .filter({ $0.playerName != selectedPlayerInCommunity.playerName })
                                .map({ $0.playerName })) {opponentName in
                            NavigationLink(
                                destination: AddResult(communityName: selectedPlayerInCommunity.communityName, ownName: selectedPlayerInCommunity.playerName, opponentName: opponentName),
                                label: { Text("\(opponentName)") })
                        }
                    case .error(_):
                        Text("Error")
                }
            })
            .navigationBarTitle("Opponent list", displayMode: .inline)
        }
        .onAppear {
            if !playersInCommunitiesStorage.items.isEmpty {
                selectedPlayerInCommunity = playersInCommunitiesStorage.items[0]
                loadData(communityNames: playersInCommunitiesStorage.items.map({ $0.communityName }))
            }
        }
    }
}

struct OpponentList_Previews: PreviewProvider {
    static var previews: some View {
        OpponentList(playersInCommunitiesStorage: PlayersInCommunitiesStorage())
    }
}
