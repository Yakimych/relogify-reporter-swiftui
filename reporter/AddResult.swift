import SwiftUI

struct AddResult: View {
    @State var communityName: String
    @State var playerName: String

    @State private var timerIsOpen: Bool = false
    @State private var playerPoints: String = "0"
    @State private var opponentPoints: String = "0"
    @State private var extraTime: Bool = false

    private let maxSelectablePoints = 20

    private func getColor(_ playerPointsString: String, _ currentNumber: Int) -> Color {
        if Int(playerPointsString) == currentNumber {
            return Color.green
        }
        return Color.yellow
    }

    private func setPlayerPoints(newValue: String) -> Void {
        self.playerPoints = newValue
    }

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                VStack {
                    Text("Player points: \(playerPoints)")
                    TextField("Player", text: $playerPoints).keyboardType(.numberPad)
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(0..<maxSelectablePoints) { currentNumber in
                                Button(String(currentNumber), action: { self.playerPoints = String(currentNumber) })
                                    .foregroundColor(.blue)
                                    .frame(width: 100, height: 50)
                                    .background(getColor(self.playerPoints, currentNumber))
                            }
                        }
                    }
                }
                VStack{
                    Text("Opponent points: \(opponentPoints)")
                    TextField("Opponent", text: $opponentPoints).keyboardType(.numberPad)
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(0..<maxSelectablePoints) { currentNumber in
                                Button(String(currentNumber), action: { self.opponentPoints = String(currentNumber) })
                                    .foregroundColor(.blue)
                                    .frame(width: 100, height: 50)
                                    .background(getColor(self.opponentPoints, currentNumber))
                            }
                        }
                    }
                }
            }
            Toggle(isOn: $extraTime, label: {
                Text("Extra Time")
            })
            Button(action: {
                print("TODO: Add result against \(playerName): \(playerPoints):\(opponentPoints) with extraTime: \(extraTime).")
            }) {
                Text("Add Result")
            }
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
