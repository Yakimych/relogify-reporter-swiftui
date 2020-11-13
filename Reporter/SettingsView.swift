import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var playersInCommunitiesStorage: PlayersInCommunitiesStorage
    @State private var isAddingPlayerInCommunity: Bool = false

    var body: some View {
        let listContents =
            ForEach(playersInCommunitiesStorage.items) {
                communityWithPlayer in
                Text("\(communityWithPlayer.communityName) (\(communityWithPlayer.playerName))")
            }

        NavigationView {
            VStack {
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
