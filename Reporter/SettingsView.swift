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
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(
                            minWidth: 20,
                            idealWidth: 50,
                            maxWidth: 100,
                            minHeight: 20,
                            idealHeight: 100,
                            maxHeight: 100,
                            alignment: .center)
                        .padding()
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
