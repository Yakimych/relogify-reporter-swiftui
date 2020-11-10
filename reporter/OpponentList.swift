import SwiftUI

extension String: Identifiable {
    public var id: String { self }
}

struct OpponentList: View {
    @EnvironmentObject var communitiesWithPlayers: CommunitiesWithPlayersStorage
    @ObservedObject private var communitiesWithPlayersListData: CommunitiesWithPlayersListData = CommunitiesWithPlayersListData()
    
    // TODO: Make everything that can be private private
    @State var selectedCommunityName: String = ""
    
    func getCommunityTabColor(communityName: String) -> Color {
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
                case .loaded(let playerNames):
                    let players = playerNames.map({ Player(name: $0) })

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

// TODO: Make generic
enum LoadingState1 {
    case loading
    case loaded([String]) // TODO: Return "Player"-objects instead
    case error(String)
}

class CommunitiesWithPlayersListData: ObservableObject {
    @Published var loadingState1: LoadingState1
    
    init() {
        self.loadingState1 = .loading
    }
    
    func loadData(communityNames: [String]) {
        // TODO: Group by community
        
        Network.shared.apollo.fetch(query: GetPlayersForCommunitiesQuery(communityNames: communityNames)) { result in
            var loadedPlayers: [String] = []
            switch result {
            case .success(let graphQLResult):
                for player in graphQLResult.data!.players {
                    loadedPlayers.append(player.name)
                }
                
                self.loadingState1 = .loaded(loadedPlayers)
                print("Success! Result: \(String(describing: loadedPlayers))")
            case .failure(let error):
                print("Failure! Error: \(error)")
            }
        }
    }
}
