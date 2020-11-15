import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var playersInCommunitiesStorage: PlayersInCommunitiesStorage
    @State private var isAddingPlayerInCommunity: Bool = false

    private let maxNumberOfPlayersInCommunities = 3

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
            VStack {
                Text("Your communities")
                    .font(.title)
                    .padding()

                List {
                    listContents.onDelete(perform: {
                        indexSet in playersInCommunitiesStorage.items.remove(atOffsets: indexSet)
                    })
                }
                .listStyle(PlainListStyle())

                NavigationLink(
                    destination: ChooseCommunity(isAddingPlayerInCommunity: $isAddingPlayerInCommunity),
                    isActive: $isAddingPlayerInCommunity
                ) {
                    withIconButtonStyle(Image(systemName: "plus.circle.fill"))
                }
                .isDetailLink(false)
                .disabled(!canAddPlayerInCommunity())

                if !canAddPlayerInCommunity() {
                    HStack {
                        Image(systemName: "info.circle")
                            .resizable()
                            .foregroundColor(Color.blue)
                            .frame(
                                minWidth: 10,
                                idealWidth: 30,
                                maxWidth: 30,
                                minHeight: 10,
                                idealHeight: 30,
                                maxHeight: 30,
                                alignment: .center)

                        Text("You can add \(maxNumberOfPlayersInCommunities) communities at most")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(PlayersInCommunitiesStorage())
    }
}
