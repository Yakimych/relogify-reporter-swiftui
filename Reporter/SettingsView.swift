import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var playersInCommunitiesStorage: PlayersInCommunitiesStorage
    @State private var isAddingPlayerInCommunity: Bool = false

    private let maxNumberOfPlayersInCommunities = 3

    init() {
        UITableView.appearance().backgroundColor = .clear
    }

    private func canAddPlayerInCommunity() -> Bool {
        return playersInCommunitiesStorage.items.count < maxNumberOfPlayersInCommunities
    }

    var body: some View {
        let listContents =
            ForEach(playersInCommunitiesStorage.items) {
                communityWithPlayer in
                Text("\(communityWithPlayer.communityName) (\(communityWithPlayer.playerName))")
            }

        NavigationView {
            ZStack {
                RelogifyColors.relogifyLight

                VStack {
                    Text("Your communities")
                        .font(.title)
                        .padding()

                    List {
                        listContents
                            .onDelete(perform: {
                                indexSet in playersInCommunitiesStorage.items.remove(atOffsets: indexSet)
                            })
                            .listRowBackground(RelogifyColors.relogifyLight)
                    }
                    .listStyle(PlainListStyle())

                    NavigationLink(
                        destination: ChooseCommunity(isAddingPlayerInCommunity: $isAddingPlayerInCommunity),
                        isActive: $isAddingPlayerInCommunity
                    ) {
                        withIconButtonStyle(Image(systemName: "plus.circle.fill"), color: RelogifyColors.relogifyBlue)
                    }
                    .isDetailLink(false)
                    .disabled(!canAddPlayerInCommunity())

                    if !canAddPlayerInCommunity() {
                        HStack {
                            Image(systemName: "info.circle")
                                .resizable()
                                .foregroundColor(RelogifyColors.relogifyBlue)
                                .frame(
                                    minWidth: 10,
                                    idealWidth: 30,
                                    maxWidth: 30,
                                    minHeight: 10,
                                    idealHeight: 30,
                                    maxHeight: 30,
                                    alignment: .center)
                                .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fill)

                            Text("You can add \(maxNumberOfPlayersInCommunities) communities at most")
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarColor(UIColor(RelogifyColors.relogifyBlue))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(PlayersInCommunitiesStorage())
    }
}
