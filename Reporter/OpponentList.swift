import SwiftUI

struct OpponentList: View {
    let playersInCommunitiesStorage: PlayersInCommunitiesStorage

    @State private var selectedPlayerInCommunity: PlayerInCommunity
    @State private var communitiesWithPlayersRemoteData: RemoteData<Dictionary<String, [PlayerInCommunity]>> = .loading

    @State private var addResultApiCallState: ApiCallState = ApiCallState.notCalled

    private var resultAddedSuccesfully: Binding<Bool> {
        Binding (
            get: {
                switch self.addResultApiCallState {
                    case .success:
                        return true
                    default:
                        return false
                }
            },
            set: { _ in }
        )}

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
                case .failure:
                    self.communitiesWithPlayersRemoteData = .error
            }
        }
    }

    private func getCommunityTabColors(communityName: String) -> (Color, Color) {
        return communityName == selectedPlayerInCommunity.communityName
            ? (RelogifyColors.relogifyDark, Color.white)
            : (Color(UIColor.lightGray), RelogifyColors.relogifyDark)
    }

    private func getCommunityTabFontWeight(communityName: String) -> Font.Weight {
        return communityName == selectedPlayerInCommunity.communityName ? .bold : .light
    }

    var body: some View {
        let headerButtonCornerRadius = CGFloat(10.0)

        NavigationView {
            ZStack {
                RelogifyColors.relogifyLight

                switch communitiesWithPlayersRemoteData {
                    case .loading:
                        ProgressView()
                            .navigationBarTitle("Loading player list...", displayMode: .inline)
                            .background(NavigationConfigurator { nc in
                                nc.navigationBar.barTintColor = UIColor(RelogifyColors.relogifyBlue)
                                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                            })
                    case .loaded(let communitiesWithOpponents):
                        let selectedCommunityWithPlayers = communitiesWithOpponents[selectedPlayerInCommunity.communityName] ?? []
                        let numberOfCommunityTabs = communitiesWithOpponents.count

                        GeometryReader { metrics in
                            VStack(alignment: .leading, content: {
                                if numberOfCommunityTabs > 1 {
                                    HStack {
                                        ForEach(playersInCommunitiesStorage.items) {
                                            communityWithPlayer in

                                            let (backgroundColor, foregroundColor) = getCommunityTabColors(communityName: communityWithPlayer.communityName)
                                            Button(action: { selectedPlayerInCommunity = communityWithPlayer }) {
                                                Text(communityWithPlayer.communityName)
                                                    .fontWeight(getCommunityTabFontWeight(communityName: communityWithPlayer.communityName))
                                                    .padding()
                                                    .frame(width: metrics.size.width / CGFloat(numberOfCommunityTabs + 1), height: 40)
                                                    .background(backgroundColor)
                                                    .foregroundColor(foregroundColor)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: headerButtonCornerRadius)
                                                            .stroke(RelogifyColors.relogifyDark, lineWidth: 2)
                                                    )
                                                    .cornerRadius(headerButtonCornerRadius)
                                            }
                                        }
                                    }
                                    .padding(.top)
                                    .padding(.leading)
                                }

                                List {
                                    ForEach(selectedCommunityWithPlayers
                                                .filter({ $0.playerName != selectedPlayerInCommunity.playerName })
                                                .map({ $0.playerName })) { opponentName in
                                        NavigationLink(
                                            destination: AddResult(
                                                communityName: selectedPlayerInCommunity.communityName,
                                                ownName: selectedPlayerInCommunity.playerName,
                                                opponentName: opponentName,
                                                addResultApiCallState: $addResultApiCallState),
                                            label: { Text("\(opponentName)") })
                                    }
                                    .listRowBackground(RelogifyColors.relogifyLight)
                                }
                                .listStyle(PlainListStyle())
                            })
                            .navigationBarTitle("Opponent list", displayMode: .inline)
                            .background(NavigationConfigurator { nc in
                                nc.navigationBar.barTintColor = UIColor(RelogifyColors.relogifyBlue)
                                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                            })
                        }
                    case .error:
                        Text("Failed to fetch opponent list, please check your internet connection and try again")
                }
            }
            .onAppear {
                if !playersInCommunitiesStorage.items.isEmpty {
                    selectedPlayerInCommunity = playersInCommunitiesStorage.items[0]
                    loadData(communityNames: playersInCommunitiesStorage.items.map({ $0.communityName }))
                }
            }
            .alert(isPresented: resultAddedSuccesfully) {
                Alert(title: Text("Success"), message: Text("The result has been added!"))
            }
        }
    }
}

struct OpponentList_Previews: PreviewProvider {
    static var previews: some View {
        OpponentList(playersInCommunitiesStorage: PlayersInCommunitiesStorage())
    }
}
