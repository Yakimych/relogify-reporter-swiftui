import SwiftUI
import Combine

struct AddResult: View {
    @Environment(\.presentationMode) var presentationMode

    let communityName: String
    let ownName: String
    let opponentName: String

    @State private var ownPoints: Int = 0
    @State private var opponentPoints: Int = 0
    @State private var extraTime: Bool = false

    @State var addResultApiCallState: ApiCallState = .notCalled

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
                player1Goals: ownPoints,
                player2Goals: opponentPoints,
                extraTime: extraTime)

        Network.shared.apollo.perform(mutation: addResultMutation) { result in
            switch result {
                case .success:
                    withAnimation {
                        addResultApiCallState = .success
                    }
                case .failure:
                    addResultApiCallState = .error
            }
        }
    }

    private let maxSelectablePoints = 100

    var body: some View {
        switch addResultApiCallState {
            case .calling:
                ProgressView()
            case .notCalled:
                VStack(alignment: .center) {
                    HStack {
                        Picker(ownName, selection: $ownPoints) {
                            ForEach(0...maxSelectablePoints, id: \.self) { currentNumber in
                                Text(String(currentNumber))
                            }
                        }

                        Picker(opponentName, selection: $opponentPoints) {
                            ForEach(0...maxSelectablePoints, id: \.self) { currentNumber in
                                Text(String(currentNumber))
                            }
                        }
                    }

                    Toggle(isOn: $extraTime, label: { Text("Extra Time").frame(maxWidth: .infinity, alignment: .trailing) })
                        .frame(width: 150, height: 30, alignment: .center)
                        .padding()

                    Button(action: { addResult() }) { Text("Add") }
                }
            case .success:
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                }

            case .error:
                VStack {
                    Text("The result has not been added, please check your internet connection and try again")
                    Button("Retry") { addResultApiCallState = .notCalled }
                }
        }
    }
}

struct AddResult_Previews: PreviewProvider {
    static var previews: some View {
        AddResult(communityName: "TestCommunity", ownName: "TestPlayer", opponentName: "TestOpponent")
    }
}
