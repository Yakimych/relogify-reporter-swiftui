import SwiftUI

extension String: Identifiable {
    public var id: String { self }
}

struct OpponentList: View {
    @EnvironmentObject var communitiesWithPlayers: CommunitiesWithPlayersStorage
    @ObservedObject private var playerListData: PlayerListData = PlayerListData()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, content: {
                HStack {
                    ForEach(communitiesWithPlayers.items) {
                        communityWithPlayer in
                        Button(communityWithPlayer.communityName, action: {})
                    }
                }
                
                switch playerListData.playerLoadingState {
                case .loading:
                    Text("Loading...")
                case .loaded(let playerNames):
                    let players = playerNames.map({ Player(name: $0) })

                    List(players) {player in PlayerRow(player: player)}
                case .error(_):
                    Text("Error")
                }
            })
            .navigationBarTitle("Opponent list", displayMode: .inline)
        }
    }
}

struct OpponentList_Previews: PreviewProvider {
    static var previews: some View {
        OpponentList()
    }
}

enum PlayerLoadingState {
    case loading
    case loaded([String]) // TODO: Return "Player"-objects instead
    case error(String)
}

class PlayerListData: ObservableObject {
    @Published var playerLoadingState: PlayerLoadingState
    
    init() {
        self.playerLoadingState = .loading
        loadData()
    }
    
    func loadData() {
        Network.shared.apollo.fetch(query: GetPlayersQuery(communityName: "test")) { result in
            var loadedPlayers: [String] = []
            switch result {
            case .success(let graphQLResult):
                for player in graphQLResult.data!.players {
                    loadedPlayers.append(player.name)
                }
                
                self.playerLoadingState = .loaded(loadedPlayers)
                print("Success! Result: \(String(describing: loadedPlayers))")
            case .failure(let error):
                print("Failure! Error: \(error)")
            }
        }
    }
}
