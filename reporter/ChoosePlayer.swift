import SwiftUI

struct ChoosePlayer: View {
    @EnvironmentObject private var communitiesWithPlayers: CommunitiesWithPlayersStorage
    @ObservedObject private var playerListData = PlayerListData()

    let communityName: String
    @State var maybeSelectedPlayer: Player?
    @Binding var isOpen: Bool

    private func getColor(player: Player) -> Color {
        if player.name == maybeSelectedPlayer?.name {
            return Color.red
        }
        return Color.white
    }

    private func addPlayerToLocalStorage() {
        if let selectedPlayer = maybeSelectedPlayer {
            communitiesWithPlayers.items.append(
                CommunityWithPlayer(
                    communityName: self.communityName,
                    playerName: selectedPlayer.name,
                    id: UUID()))
        }
    }

    var body: some View {
        VStack {
            switch playerListData.loadingState2 {
            case .loading:
                Text("Loading...")
            case .loaded(let playerNames):
                // TODO: Remove
                let players = playerNames.map({ Player(name: $0) })
                
                Text("Choose player in \(communityName)!")
                List(players) {player in
                    Button("Player '\(player.name)'", action: { maybeSelectedPlayer = player })
                        .background(getColor(player: player))
                }
                Button("Done", action: {
                    addPlayerToLocalStorage()
                    isOpen = false
                })
                .disabled(maybeSelectedPlayer == nil)
            case .error(_):
                Text("Error")
            }
        }
        .onAppear {
            playerListData.loadData(communityName: communityName)
        }
    }
}

struct ChoosePlayer_Previews: PreviewProvider {
    static var previews: some View {
        ChoosePlayer(communityName: "TestCommunity", maybeSelectedPlayer: Player(name: "player1"), isOpen: .constant(true))
    }
}

// TODO: Make generic
enum LoadingState2 {
    case loading
    case loaded([String]) // TODO: Return "Player"-objects instead
    case error(String)
}

class PlayerListData: ObservableObject {
    @Published var loadingState2: LoadingState2
    
    init() {
        self.loadingState2 = .loading
    }
    
    func loadData(communityName: String) {
        Network.shared.apollo.fetch(query: GetPlayersQuery(communityName: communityName)) { result in
            var loadedPlayers: [String] = []
            switch result {
            case .success(let graphQLResult):
                for player in graphQLResult.data!.players {
                    loadedPlayers.append(player.name)
                }
                
                self.loadingState2 = .loaded(loadedPlayers)
                print("Success! Result: \(String(describing: loadedPlayers))")
            case .failure(let error):
                print("Failure! Error: \(error)")
            }
        }
    }
}

