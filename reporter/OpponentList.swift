import SwiftUI

struct OpponentList: View {
    @EnvironmentObject var communitiesWithPlayers: CommunitiesWithPlayers
    
    var body: some View {
        let player1 = Player(name: "player1")
        let player2 = Player(name: "player2")
        let players = [player1, player2]
        
        NavigationView {
            VStack(alignment: .leading, content: {
                HStack {
                    ForEach(communitiesWithPlayers.communitiesWithPlayers) {
                        communityWithPlayer in
                        Button(communityWithPlayer.communityName, action: {})
                    }
                }
                List(players) {player in PlayerRow(player: player)}
            })
            .navigationBarTitle("Opponent list", displayMode: .inline)
        }
    }
}

struct OpponentList_Previews: PreviewProvider {
    static var previews: some View {
        OpponentList()
    }
}
