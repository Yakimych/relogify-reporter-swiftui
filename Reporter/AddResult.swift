import SwiftUI
import Combine

struct AddResult: View {
    @Environment(\.presentationMode) var presentationMode

    let communityName: String
    let ownName: String
    let opponentName: String

    @Binding var addResultApiCallState: ApiCallState

    private var errorAddingResult: Binding<Bool> {
        Binding (
            get: {
                switch self.addResultApiCallState {
                    case .error:
                        return true
                    default:
                        return false
                }
            },
            set: { _ in }
        )}

    @State private var timerIsOpen: Bool = false

    @State private var ownPoints: String = "0"
    @State private var opponentPoints: String = "0"
    @State private var extraTime: Bool = false

    private let maxSelectablePoints = 20

    private func addResultPending() -> Bool {
        switch self.addResultApiCallState {
            case .calling:
                return true
            default:
                return false
        }
    }

    private func getScoreButtonColor(_ playerPointsString: String, _ currentNumber: Int) -> Color {
        if Int(playerPointsString) == currentNumber {
            return Color.green
        }
        return Color.yellow
    }

    private func addResult() {
        withAnimation {
            addResultApiCallState = .calling
        }

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        let addResultMutation =
            AddResultMutation(
                communityName: communityName,
                player1Name: ownName,
                player2Name: opponentName,
                date: dateFormatter.string(from: Date()),
                player1Goals: Int(ownPoints) ?? 0,
                player2Goals: Int(opponentPoints) ?? 0,
                extraTime: extraTime)

        Network.shared.apollo.perform(mutation: addResultMutation) { result in
            switch result {
                case .success:
                    addResultApiCallState = .success
                    presentationMode.wrappedValue.dismiss()
                case .failure:
                    addResultApiCallState = .error
            }
        }
    }

    private func toNumericString(stringValue: String) -> String {
        if let numericValue = Int(stringValue) {
            return String(numericValue)
        }
        else {
            return "0"
        }
    }

    private func getScoreButtonText(scoreNumber: Int, backgroundColor: Color) -> some View {
        let buttonCornerRadius = CGFloat(15.0)

        return Text(String(scoreNumber))
            .fontWeight(.bold)
            .font(.title2)
            .frame(width: 100, height: 50)
            .background(backgroundColor)
            .foregroundColor(RelogifyColors.relogifyDark)
            .overlay(
                RoundedRectangle(cornerRadius: buttonCornerRadius)
                    .stroke(RelogifyColors.relogifyDark, lineWidth: 5)
            )
            .cornerRadius(buttonCornerRadius)
    }

    var body: some View {
        ZStack {
            RelogifyColors.relogifyLight

            if addResultPending() {
                VStack {
                    Text("Adding Result: \(ownName) \(ownPoints):\(opponentPoints) \(opponentName)")
                    ProgressView()
                }
            }
            else {
                VStack(alignment: .center) {
                    HStack {
                        VStack {
                            Text(ownName)
                            TextField("Player", text: $ownPoints)
                                .keyboardType(.numberPad)
                                .onReceive(Just(ownPoints), perform: { self.ownPoints = toNumericString(stringValue: $0) })
                            ScrollView {
                                VStack(spacing: 10) {
                                    ForEach(0..<maxSelectablePoints) { currentNumber in
                                        Button(action: { self.ownPoints = String(currentNumber) }) {
                                            getScoreButtonText(scoreNumber: currentNumber, backgroundColor: getScoreButtonColor(self.ownPoints, currentNumber))
                                        }
                                    }
                                }
                            }
                        }

                        VStack {
                            Text(opponentName)
                            TextField("Opponent", text: $opponentPoints)
                                .keyboardType(.numberPad)
                                .onReceive(Just(opponentPoints), perform: { self.opponentPoints = toNumericString(stringValue: $0) })
                            ScrollView {
                                VStack(spacing: 10) {
                                    ForEach(0..<maxSelectablePoints) { currentNumber in
                                        Button(action: { self.opponentPoints = String(currentNumber) }) {
                                            getScoreButtonText(scoreNumber: currentNumber, backgroundColor: getScoreButtonColor(self.opponentPoints, currentNumber))
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Toggle(isOn: $extraTime, label: { Text("Extra Time").frame(maxWidth: .infinity, alignment: .trailing) })
                        .frame(width: 150, height: 30, alignment: .center)
                        .padding()

                    Button(action: { addResult() }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .foregroundColor(RelogifyColors.relogifyRed)
                            .frame(width: 100, height: 100)
                        }
                }
                .navigationBarTitle("Game in \(communityName)")
                .navigationBarItems(trailing: Button(action: { self.timerIsOpen.toggle() }) { Text("Timer") }
                                        .sheet(isPresented: $timerIsOpen) { GameTimer(extraTime: $extraTime) }
                )
                .alert(isPresented: errorAddingResult) {
                    Alert(title: Text("Error"), message: Text("The result has not been added, please check your internet connection and try again"))
                }
                .padding()
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
            addResultApiCallState: .constant(.notCalled))
    }
}
