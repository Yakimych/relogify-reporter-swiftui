import SwiftUI

struct OpponentList: View {
    @EnvironmentObject private var playersInCommunitiesStorage: PlayersInCommunitiesStorage
    @ObservedObject private var communitiesWithPlayersListData: CommunitiesWithPlayersListData = CommunitiesWithPlayersListData()

    @State private var maybeSelectedPlayerInCommunity: PlayerInCommunity? = nil

    private func getCommunityTabColor(communityName: String) -> Color {
        if communityName == maybeSelectedPlayerInCommunity?.communityName {
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
                        Button(communityWithPlayer.communityName, action: { maybeSelectedPlayerInCommunity = communityWithPlayer })
                            .background(getCommunityTabColor(communityName: communityWithPlayer.communityName))
                    }
                }

                switch communitiesWithPlayersListData.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded(let communitiesWithOpponents):
                        let selectedCommunityWithPlayers = communitiesWithOpponents[maybeSelectedPlayerInCommunity?.communityName ?? "TODO: Remove"] ?? []

                        List(selectedCommunityWithPlayers.map({ $0.playerName })) {opponentName in
                            NavigationLink(
                                destination: AddResult(communityName: maybeSelectedPlayerInCommunity?.communityName ?? "TODO: Remove", ownName: maybeSelectedPlayerInCommunity?.playerName ?? "TODO: Remove", opponentName: opponentName),
                                label: { Text("\(opponentName)") })
                        }
                    case .error(_):
                        Text("Error")
                }
            })
            .navigationBarTitle("Opponent list", displayMode: .inline)
        }
        .onAppear {
            // TODO: Make sure we never end up here with empty playersInCommunitiesStorage.items
            if (!playersInCommunitiesStorage.items.isEmpty) {
                maybeSelectedPlayerInCommunity = playersInCommunitiesStorage.items[0]

                communitiesWithPlayersListData.loadData(communityNames: playersInCommunitiesStorage.items.map({ $0.communityName }))
            }
        }
    }
}

struct OpponentList_Previews: PreviewProvider {
    static var previews: some View {
        OpponentList()
    }
}

class CommunitiesWithPlayersListData: ObservableObject {
    @Published var loadingState: LoadingState<Dictionary<String, [PlayerInCommunity]>>

    init() {
        self.loadingState = .loading
    }

    func loadData(communityNames: [String]) {
        Network.shared.apollo.fetch(query: GetPlayersForCommunitiesQuery(communityNames: communityNames)) { result in
            var loadedCommunitiesWithPlayers: [PlayerInCommunity] = []
            switch result {
                case .success(let graphQLResult):
                    for player in graphQLResult.data!.players {
                        loadedCommunitiesWithPlayers.append(PlayerInCommunity(communityName: player.community.name, playerName: player.name, id: UUID()))
                    }

                    let groupedCommunitiesWithPlayers = Dictionary(grouping: loadedCommunitiesWithPlayers, by: { $0.communityName })

                    self.loadingState = .loaded(groupedCommunitiesWithPlayers)
                    print("Success! Result: \(String(describing: groupedCommunitiesWithPlayers))")
                case .failure(let error):
                    print("Failure! Error: \(error)")
            }
        }
    }
}
