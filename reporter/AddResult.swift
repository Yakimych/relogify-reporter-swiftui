import SwiftUI

struct AddResult: View {
    @State var communityName: String
    @State var playerName: String
    @State var timerIsOpen: Bool = false
    
    var body: some View {
        VStack {
            Text("Add Result against \(playerName) in \(communityName)")
        }
        .navigationBarTitle("\(playerName) in \(communityName)")
        .navigationBarItems(trailing:
                                Button(action: { self.timerIsOpen.toggle() })
                                    { Text("Timer") }
            .sheet(isPresented: $timerIsOpen) {
                GameTimer(isOpen: $timerIsOpen, extraTime: false)
            }
        )
    }
}

struct AddResult_Previews: PreviewProvider {
    static var previews: some View {
        AddResult(communityName: "TestCommunity", playerName: "TestPlayer")
    }
}
