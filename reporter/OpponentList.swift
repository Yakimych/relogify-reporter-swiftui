import SwiftUI

extension String: Identifiable {
    public var id: String { self }
}

struct OpponentList: View {
    @EnvironmentObject private var communitiesWithPlayers: CommunitiesWithPlayersStorage
    @ObservedObject private var communitiesWithPlayersListData: CommunitiesWithPlayersListData = CommunitiesWithPlayersListData()

    @State private var selectedCommunityName: String = ""

    private func getCommunityTabColor(communityName: String) -> Color {
        if communityName == selectedCommunityName {
            return Color.red
        }
        return Color.white
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, content: {
                HStack {
                    ForEach(communitiesWithPlayers.items) {
                        communityWithPlayer in
                        Button(communityWithPlayer.communityName, action: { selectedCommunityName = communityWithPlayer.communityName })
                            .background(getCommunityTabColor(communityName: communityWithPlayer.communityName))
                    }
                }

                switch communitiesWithPlayersListData.loadingState1 {
                case .loading:
                    Text("Loading...")
                case .loaded(let communitiesWithPlayers):
                    let selectedCommunityWithPlayers = communitiesWithPlayers[selectedCommunityName] ?? []
                    let players = selectedCommunityWithPlayers.map({ Player(name: $0.playerName) })

                    List(players) {player in PlayerRow(player: player)}
                case .error(_):
                    Text("Error")
                }
            })
            .navigationBarTitle("Opponent list", displayMode: .inline)
        }
        .onAppear {
            // TODO: Make sure we never end up here with empty communitiesWithPlayers.items
            if (!communitiesWithPlayers.items.isEmpty) {
                selectedCommunityName = communitiesWithPlayers.items[0].communityName
                
                communitiesWithPlayersListData.loadData(communityNames: self.communitiesWithPlayers.items.map({ $0.communityName }))
            }
        }
    }
}

struct OpponentList_Previews: PreviewProvider {
    static var previews: some View {
        OpponentList()
    }
}

struct CommunityWithPlayers {
    public var communityName: String
    public var playerNames: [String]
}

// TODO: Make generic
enum LoadingState1 {
    case loading
    case loaded(Dictionary<String, [CommunityWithPlayer]>)
    case error(String)
}

class CommunitiesWithPlayersListData: ObservableObject {
    @Published var loadingState1: LoadingState1

    init() {
        self.loadingState1 = .loading
    }

    func loadData(communityNames: [String]) {
        Network.shared.apollo.fetch(query: GetPlayersForCommunitiesQuery(communityNames: communityNames)) { result in
            var loadedCommunitiesWithPlayers: [CommunityWithPlayer] = []
            switch result {
            case .success(let graphQLResult):
                for player in graphQLResult.data!.players {
                    loadedCommunitiesWithPlayers.append(CommunityWithPlayer(communityName: player.community.name, playerName: player.name, id: UUID()))
                }

                let groupedCommunitiesWithPlayers = Dictionary(grouping: loadedCommunitiesWithPlayers, by: { $0.communityName })

                self.loadingState1 = .loaded(groupedCommunitiesWithPlayers)
                print("Success! Result: \(String(describing: groupedCommunitiesWithPlayers))")
            case .failure(let error):
                print("Failure! Error: \(error)")
            }
        }
    }
}
