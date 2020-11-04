import SwiftUI

struct AddResult: View {
    @State var communityName: String
    @State var playerName: String

    var body: some View {
        VStack {
            NavigationLink(
                destination: Timer(extraTime: false),
                label: {
                    Text("Timer")
                })
            Text("Add Result against \(playerName) in \(communityName)")
        }
        .navigationBarTitle("\(playerName) in \(communityName)")
        .navigationBarItems(trailing: NavigationLink("Timer", destination: Timer(extraTime: false)))
        // TODO: https://stackoverflow.com/questions/57130866/how-to-show-navigationlink-as-a-button-in-swiftui/57837007#57837007
        // TODO: https://developer.apple.com/forums/thread/124757
    }
}

struct AddResult_Previews: PreviewProvider {
    static var previews: some View {
        AddResult(communityName: "TestCommunity", playerName: "TestPlayer")
    }
}
