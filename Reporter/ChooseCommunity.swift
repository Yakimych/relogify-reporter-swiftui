import SwiftUI

struct ChooseCommunity: View {
    @State private var communityName: String = ""
    @Binding var isAddingPlayerInCommunity: Bool

    var body: some View {
        VStack {
            TextField("Community", text: $communityName).padding().autocapitalization(.none)

            // TODO: Add information as to how to find the community name

            // TODO: Disable if community name is empty
            NavigationLink(
                destination: ChoosePlayer(communityName: communityName, isAddingPlayerInCommunity: $isAddingPlayerInCommunity)
            ) {
                withIconButtonStyle(Image(systemName: "arrow.right.circle"))
            }
            .isDetailLink(false)
        }
        .navigationTitle("Choose community")
    }
}

struct ChooseCommunity_Previews: PreviewProvider {
    static var previews: some View {
        ChooseCommunity(isAddingPlayerInCommunity: .constant(true))
            .environmentObject(PlayersInCommunitiesStorage())
    }
}
