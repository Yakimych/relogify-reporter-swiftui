import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var playersInCommunitiesStorage: PlayersInCommunitiesStorage
    @State private var isAddingPlayerInCommunity: Bool = false

    var body: some View {
        let listContents =
            ForEach(playersInCommunitiesStorage.items) {
                communityWithPlayer in
                Text("\(communityWithPlayer.playerName) (\(communityWithPlayer.communityName))")
            }

        NavigationView {
            VStack {
                Text("Setting View")

                // TODO: Sections
                Text("Existing communities:")

                if playersInCommunitiesStorage.items.count <= 1 {
                    List { listContents }
                }
                else {
                    List { listContents.onDelete(perform: { indexSet in
                        playersInCommunitiesStorage.items.remove(atOffsets: indexSet)
                    }) }
                }

                NavigationLink(
                    destination: ChooseCommunity(isAddingPlayerInCommunity: $isAddingPlayerInCommunity),
                    isActive: $isAddingPlayerInCommunity,
                    label: { Text("Add") }
                )
                .isDetailLink(false)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
