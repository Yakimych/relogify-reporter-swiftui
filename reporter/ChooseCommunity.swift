import SwiftUI

struct ChooseCommunity: View {
    @State var communityName: String = ""
    
    var body: some View {
        VStack {
            Text("Enter community name:")
            TextField("Community", text: $communityName).padding()
            NavigationLink(
                destination: ChoosePlayer(communityName: communityName),
                label: { Text("Next") })
        }
    }
}

struct ChooseCommunity_Previews: PreviewProvider {
    static var previews: some View {
        ChooseCommunity()
    }
}
