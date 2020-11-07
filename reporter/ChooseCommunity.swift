import SwiftUI

struct ChooseCommunity: View {
    @EnvironmentObject var communitiesWithPlayers: CommunitiesWithPlayers
    @State var communityName: String = ""
    @State var isChoosingPlayer = false
    
    var body: some View {
        VStack {
            Text("Existing communities:")
            List(communitiesWithPlayers.communitiesWithPlayers) { communityWithPlayer in
                Button("\(communityWithPlayer.playerName) (\(communityWithPlayer.communityName))", action: { })
            }
            
            // TODO: Split this into a separate view, rename isChoosingPlayer to something that indicates that both player and community are being chosen
            
            Text("Enter community name:")
            TextField("Community", text: $communityName).padding()
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
