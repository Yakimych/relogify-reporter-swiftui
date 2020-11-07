import SwiftUI

struct ChoosePlayer: View {
    var communityName: String
    @State var selectedPlayer: Player?
    
    func getColor(player: Player) -> Color {
        if player.name == selectedPlayer?.name {
            return Color.red
        }
        return Color.white
    }
    
    var body: some View {
        let player1 = Player(name: "player1")
        let player2 = Player(name: "player2")
        let players = [player1, player2]
        
        VStack{
            Text("Choose player in \(communityName)!")
            List(players) {player in
                Button("Player '\(player.name)'", action: { selectedPlayer = player })
                    .background(getColor(player: player))
            }
            Button("Done", action: {})
        }
    }
}

struct ChoosePlayer_Previews: PreviewProvider {
    static var previews: some View {
        ChoosePlayer(communityName: "TestCommunity", selectedPlayer: Player(name: "player1"))
    }
}
