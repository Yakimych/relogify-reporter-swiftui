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
                        .frame(minWidth: 10, idealWidth: 50, maxWidth: 100, minHeight: 50, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
