import SwiftUI

struct OpponentsInCommunity: View {
    let communityName: String
    let playerName: String
    let opponentList: [String]

    var body: some View {
        VStack {
            Text("Opponents in \(communityName)")

            List(opponentList) { opponentName in
                Text(opponentName)
            }
        }
    }
}

struct OpponentsInCommunity_Previews: PreviewProvider {
    static var previews: some View {
        OpponentsInCommunity(communityName: "Test", playerName: "Player1", opponentList: ["Player2", "Player3"])
    }
}
