import SwiftUI

struct ChoosePlayer: View {
    @EnvironmentObject var communitiesWithPlayers: CommunitiesWithPlayersStorage
    
    var communityName: String
    @State var maybeSelectedPlayer: Player?
    @Binding var isOpen: Bool
    
    func getColor(player: Player) -> Color {
        if player.name == maybeSelectedPlayer?.name {
            return Color.red
        }
        return Color.white
    }
    
    func addPlayerToLocalStorage() {
        if let selectedPlayer = maybeSelectedPlayer {
            communitiesWithPlayers.items.append(
                CommunityWithPlayer(
                    communityName: self.communityName,
                    playerName: selectedPlayer.name,
                    id: UUID()))
        }
    }
    
    var body: some View {
        let player1 = Player(name: "player1")
        let player2 = Player(name: "player2")
        let player3 = Player(name: "player3")
        let players = [player1, player2, player3]
        
        VStack{
            Text("Choose player in \(communityName)!")
            List(players) {player in
                Button("Player '\(player.name)'", action: { maybeSelectedPlayer = player })
                    .background(getColor(player: player))
            }
            Button("Done", action: {
                addPlayerToLocalStorage()
                isOpen = false
            })
                .disabled(maybeSelectedPlayer == nil)
        }
    }
}

struct ChoosePlayer_Previews: PreviewProvider {
    static var previews: some View {
        ChoosePlayer(communityName: "TestCommunity", maybeSelectedPlayer: Player(name: "player1"), isOpen: .constant(true))
    }
}
