import SwiftUI

struct ChooseCommunity: View {
    @State private var communityName: String = ""
    @Binding var isAddingPlayerInCommunity: Bool

    var body: some View {
        VStack {
            TextField("Community", text: $communityName).padding().autocapitalization(.none)
            NavigationLink(
                destination: ChoosePlayer(communityName: communityName, isAddingPlayerInCommunity: $isAddingPlayerInCommunity),
                label: { Text("Next") }
            )
            .isDetailLink(false)
        }
        .navigationTitle("Choose community")
    }
}

struct ChooseCommunity_Previews: PreviewProvider {
    static var previews: some View {
        ChooseCommunity(isAddingPlayerInCommunity: .constant(true))
    }
}
