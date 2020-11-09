import SwiftUI

struct Player: Identifiable {
    var id = UUID()
    var name: String
}

struct PlayerRow: View {
    var player: Player
    
    var body: some View {
        NavigationLink(
            destination: AddResult(communityName: "Test", playerName: player.name),
            label: {
                Text("\(player.name)")
            })
    }
}

struct PlayerRow_Previews: PreviewProvider {
    static var previews: some View {
        PlayerRow(player: Player(name: "TestPlayer"))
    }
}
