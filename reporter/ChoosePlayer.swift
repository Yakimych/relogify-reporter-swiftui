import SwiftUI

struct ChoosePlayer: View {
    @EnvironmentObject private var communitiesWithPlayers: CommunitiesWithPlayersStorage
    @ObservedObject private var playerListData = PlayerListData()

    let communityName: String
    @State var maybeSelectedPlayerName: String?
    @Binding var isOpen: Bool

    private func getColor(playerName: String) -> Color {
        if playerName == maybeSelectedPlayerName {
            return Color.red
        }
        return Color.white
    }

    private func addPlayerToLocalStorage() {
        if let selectedPlayerName = maybeSelectedPlayerName {
            communitiesWithPlayers.items.append(
                CommunityWithPlayer(
                    communityName: self.communityName,
                    playerName: selectedPlayerName,
                    id: UUID()))
        }
    }

    var body: some View {
        VStack {
            switch playerListData.loadingState2 {
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
                    isOpen = false
                })
                .disabled(maybeSelectedPlayerName == nil)
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
        ChoosePlayer(communityName: "TestCommunity", maybeSelectedPlayerName: "player1", isOpen: .constant(true))
    }
}

// TODO: Make generic
enum LoadingState2 {
    case loading
    case loaded([String])
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

