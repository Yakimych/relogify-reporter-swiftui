import SwiftUI

struct ChoosePlayer: View {
    @EnvironmentObject private var playersInCommunitiesStorage: PlayersInCommunitiesStorage

    let communityName: String
    @State private var maybeSelectedPlayerName: String?

    @Binding var isAddingPlayerInCommunity: Bool

    @State private var playersRemoteData: RemoteData<[String]> = .loading

    private func loadData(communityName: String) {
        Network.shared.apollo.fetch(query: GetPlayersQuery(communityName: communityName)) { result in
            var loadedPlayers: [String] = []
            switch result {
                case .success(let graphQLResult):
                    for player in graphQLResult.data!.players {
                        loadedPlayers.append(player.name)
                    }

                    playersRemoteData = .loaded(loadedPlayers)
                    print("Success! Result: \(String(describing: loadedPlayers))")
                case .failure(let error):
                    print("Failure! Error: \(error)")
            }
        }
    }

    private func getColor(playerName: String) -> Color {
        if playerName == maybeSelectedPlayerName {
            return Color.red
        }
        return Color.white
    }

    private func addPlayerToLocalStorage() {
        if let selectedPlayerName = maybeSelectedPlayerName {
            playersInCommunitiesStorage.items.append(
                PlayerInCommunity(
                    communityName: self.communityName,
                    playerName: selectedPlayerName,
                    id: UUID()))
        }
    }

    var body: some View {
        VStack {
            switch playersRemoteData {
                case .loading:
                    Text("Loading...")
                case .loaded(let playerNames):
                    Text("Choose player in \(communityName)!")
                    List(playerNames) {playerName in
                        Button("Player '\(playerName)'", action: { maybeSelectedPlayerName = playerName })
                            .background(getColor(playerName: playerName))
                    }
                    Button("Done", action: {
                        addPlayerToLocalStorage()
                        isAddingPlayerInCommunity = false
                    })
                    .disabled(maybeSelectedPlayerName == nil)
                case .error(_):
                    Text("Error")
            }
        }
        .onAppear {
            loadData(communityName: communityName)
        }
    }
}

struct ChoosePlayer_Previews: PreviewProvider {
    static var previews: some View {
        ChoosePlayer(communityName: "TestCommunity", isAddingPlayerInCommunity: .constant(false))
    }
}
