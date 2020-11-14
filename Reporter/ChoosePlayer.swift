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
                case .failure:
                    playersRemoteData = .error
            }
        }
    }

    private func getListItemColor(playerName: String) -> Color {
        if playerName == maybeSelectedPlayerName {
            return Color.red
        }
        return Color.white
    }

    private func canAddPlayer() -> Bool {
        return maybeSelectedPlayerName != nil
    }

    private func getConfirmationButtonColor() -> Color {
        if canAddPlayer() {
            return Color.green
        }
        return Color(UIColor.lightGray)
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

    private func playerNotAlreadyAdded(playerToAdd: String) -> Bool {
        let addedPlayersInCurrentCommunity =
            playersInCommunitiesStorage.items
                .filter({ $0.communityName == self.communityName })
                .map({$0.playerName})

        return !addedPlayersInCurrentCommunity.contains(playerToAdd)
    }

    var body: some View {
        VStack {
            switch playersRemoteData {
                case .loading:
                    ProgressView()
                case .loaded(let playerNames):
                    List(playerNames.filter(playerNotAlreadyAdded)) { playerName in
                        Button(playerName, action: { maybeSelectedPlayerName = playerName })
                            .background(getListItemColor(playerName: playerName))
                    }
                    .listStyle(PlainListStyle())

                    Button(action: {
                        addPlayerToLocalStorage()
                        isAddingPlayerInCommunity = false
                    }) {
                        withIconButtonStyle(Image(systemName: "checkmark.circle"))
                            .foregroundColor(getConfirmationButtonColor())
                    }
                    .disabled(!canAddPlayer())
                case .error:
                    Text("Failed to fetch players, please check your internet connection and try again")
            }
        }
        .navigationTitle("Choose player in '\(communityName)'")
        .onAppear {
            loadData(communityName: communityName)
        }
    }
}

struct ChoosePlayer_Previews: PreviewProvider {
    static var previews: some View {
        ChoosePlayer(communityName: "TestCommunity", isAddingPlayerInCommunity: .constant(true))
            .environmentObject(PlayersInCommunitiesStorage())
    }
}
