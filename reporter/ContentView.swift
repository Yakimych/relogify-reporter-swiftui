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
                Text("Player '\(player.name)'")
            })
    }
}

struct ContentView: View {
    @State var selectedView = 0
    @State var isFirstRun = false
    
    var body: some View {
        let player1 = Player(name: "player1")
        let player2 = Player(name: "player2")
        let players = [player1, player2]
        
        if isFirstRun {
            VStack(content: {
                Text("First run!")
            })
        }
        else {
            TabView(selection: $selectedView) {
                NavigationView {
                    VStack(alignment: .leading, content: {
                        List(players) {player in PlayerRow(player: player)}
                    })
                    .navigationBarTitle("Opponent list", displayMode: .inline)
                }
                .tag(0)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Opponents")
                }

                Text("Settings")
                    .tag(1)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                Text("About")
                    .tag(2)
                    .tabItem {
                        Image(systemName: "info.circle")
                        Text("About")
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedView: 0, isFirstRun: false)
    }
}
