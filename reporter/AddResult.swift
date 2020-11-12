import SwiftUI

struct AddResult: View {
    @Environment(\.presentationMode) var presentationMode

    let communityName: String
    let ownName: String
    let opponentName: String

    @Binding var addResultSucceeded: Bool
    @State private var timerIsOpen: Bool = false
    @State private var isAddingResult: Bool = false
    @State private var errorAddingResult: Bool = false

    // TODO: Int as backing field?
    @State private var ownPoints: String = "0"
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
        self.ownPoints = newValue
    }

    private func addResult() {
        withAnimation {
            isAddingResult = true
        }

//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//
//        let addResultMutation =
//            AddResultMutation(
//                communityName: communityName,
//                player1Name: ownName,
//                player2Name: opponentName,
//                date: dateFormatter.string(from: Date()),
//                player1Goals: Int(ownPoints) ?? 0,
//                player2Goals: Int(opponentPoints) ?? 0,
//                extraTime: extraTime)

// TODO: Remove after handling the error
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            errorAddingResult = true
            isAddingResult = false
            //presentationMode.wrappedValue.dismiss()
        }

//        Network.shared.apollo.perform(mutation: addResultMutation) { result in
//            print("Added result. Response: \(result).")
//
//            switch result {
//                case .success:
//                    addResultSucceeded = true
//                    presentationMode.wrappedValue.dismiss()
//                case .failure:
//                    // TODO: Handle error
//                    isAddingResult = false
//            }
//        }
    }

    var body: some View {
        if isAddingResult {
            VStack {
                Text("Adding Result: \(ownName) \(ownPoints):\(opponentPoints) \(opponentName)")
                ProgressView()
            }
        }
        else {
            VStack(alignment: .center) {
                HStack {
                    VStack {
                        Text("Player points: \(ownPoints)")
                        TextField("Player", text: $ownPoints).keyboardType(.numberPad)
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(0..<maxSelectablePoints) { currentNumber in
                                    Button(String(currentNumber), action: { self.ownPoints = String(currentNumber) })
                                        .foregroundColor(.blue)
                                        .frame(width: 100, height: 50)
                                        .background(getColor(self.ownPoints, currentNumber))
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
                Toggle(isOn: $extraTime, label: { Text("Extra Time") })
                Button(action: { addResult() }) { Text("Add Result") }
            }
            .navigationBarTitle("\(ownName) vs \(opponentName) in \(communityName)")
            .navigationBarItems(trailing: Button(action: { self.timerIsOpen.toggle() }) { Text("Timer") }
                                    .sheet(isPresented: $timerIsOpen) { GameTimer(extraTime: false) }
            )
            .alert(isPresented: $errorAddingResult) {
                Alert(title: Text("Error"), message: Text("The result has not been added, please check your internet connection and try again"))
            }
        }
    }
}

struct AddResult_Previews: PreviewProvider {
    static var previews: some View {
        AddResult(
            communityName: "TestCommunity",
            ownName: "TestPlayer",
            opponentName: "TestOpponent",
            addResultSucceeded: .constant(false))
    }
}
