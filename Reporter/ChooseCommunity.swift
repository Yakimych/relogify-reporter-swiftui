import SwiftUI

struct ChooseCommunity: View {
    @State private var communityName: String = ""
    @Binding var isAddingPlayerInCommunity: Bool

    private func canProceed() -> Bool {
        return communityName != ""
    }

    private func getNextButtonColor() -> Color {
        if canProceed() {
            return Color.blue
        }
        return Color(UIColor.lightGray)
    }

    var body: some View {
        VStack {
            TextField("Community", text: $communityName).padding().autocapitalization(.none)

            // TODO: Add information as to how to find the community name

            NavigationLink(
                destination: ChoosePlayer(communityName: communityName, isAddingPlayerInCommunity: $isAddingPlayerInCommunity)
            ) {
                withIconButtonStyle(Image(systemName: "arrow.right.circle"))
                    .foregroundColor(getNextButtonColor())
            }
            .isDetailLink(false)
            .disabled(!canProceed())
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
