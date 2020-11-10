import SwiftUI

struct ChooseCommunity: View {
    @EnvironmentObject private var playersInCommunitiesStorage: PlayersInCommunitiesStorage

    @State private var communityName: String = ""
    @State private var isChoosingPlayer = false

    var body: some View {
        VStack {
            Text("Existing communities:")
            List(playersInCommunitiesStorage.items) { communityWithPlayer in
                Button("\(communityWithPlayer.playerName) (\(communityWithPlayer.communityName))", action: { })
            }

            // TODO: Split this into a separate view, rename isChoosingPlayer to something that indicates that both player and community are being chosen

            Text("Enter community name:")
            TextField("Community", text: $communityName).padding().autocapitalization(.none)
            NavigationLink(
                destination: ChoosePlayer(communityName: communityName, isOpen: $isChoosingPlayer),
                isActive: $isChoosingPlayer,
                label: { Text("Next") }
            )
        }
    }
}

struct ChooseCommunity_Previews: PreviewProvider {
    static var previews: some View {
        ChooseCommunity()
    }
}
