import SwiftUI
import SwiftySound

// TODO: Wrap timer-related fields into a class and add unit tests (keep the timer outside)
enum stopWatchMode {
    case stopped
    case running(Date)
    case paused // TODO: TimeRemaining?
}

struct GameTimer: View {
    @Environment(\.presentationMode) var presentationMode

    @State var extraTime: Bool
    @State private var millisecondsLeft: Double = 10000.0
    @State var mode: stopWatchMode = .stopped

    // TODO: This will depend on extraTime value
    private let totalMilliseconds: Double = 10 * 1000
    private let expirationWarningMilliseconds: Double = 2 * 1000

    private static let tickFrequencyMs = 200

    // TODO: is there a concept similar to "ref" in SwiftUI?
    @State private var isPastHalfTime = false
    @State private var isPastExpirationWarning = false

    // TODO: 200 -> contant
    let timer = Timer.publish(every: 200.0 / 1000, on: .main, in: .common).autoconnect()

    private func start(timeOfStart: Date) {
        switch mode {
            case .stopped, .paused:
                mode = .running(timeOfStart)
            default:
                break
        }
    }

    private func pause(timeOfPause: Date) {
        tick(timeOfTick: timeOfPause)
        switch mode {
            case .running:
                mode = .paused
            default:
                break
        }
    }

    private func reset() {
        mode = .stopped
        millisecondsLeft = totalMilliseconds

        isPastHalfTime = false
        isPastExpirationWarning = false
    }

    private func tick(timeOfTick: Date) {
        switch mode {
            case .running(let lastTickAt):
                if self.millisecondsLeft > 0 {
                    self.mode = .running(timeOfTick)
                    let millisecondsElapsedSinceLastTick = timeOfTick.timeIntervalSince(lastTickAt) * 1000

                    if (self.millisecondsLeft > millisecondsElapsedSinceLastTick) {
                        self.millisecondsLeft -= millisecondsElapsedSinceLastTick

                        if (self.millisecondsLeft < self.expirationWarningMilliseconds && !self.isPastExpirationWarning) {
                            self.isPastExpirationWarning = true
                            DispatchQueue.global(qos: .background).async { Sound.play(file: "expiration_warning.mp3") }
                        }

                        if (self.millisecondsLeft < self.totalMilliseconds / 2 && !self.isPastHalfTime) {
                            self.isPastHalfTime = true
                            DispatchQueue.global(qos: .background).async { Sound.play(file: "half_time_beep.mp3") }
                        }
                    }
                    else {
                        self.millisecondsLeft = 0
                        self.mode = .stopped
                        DispatchQueue.global(qos: .background).async { Sound.play(file: "final_siren.mp3") }
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            default:
                break
        }
    }

    var body: some View {
        VStack {
            Text("Milliseconds left: \(millisecondsLeft)")
            Button(action: { start(timeOfStart: Date()) }) {
                Text("Start")
            }.buttonStyle(TimerButtonStyle())
            Button(action: { pause(timeOfPause: Date()) } ) {
                Text("Pause")
            }.buttonStyle(TimerButtonStyle())
            Button(action: reset ) {
                Text("Reset")
            }.buttonStyle(TimerButtonStyle())
        }
        .navigationBarTitle("Timer")
        .onReceive(timer) { time in
            tick(timeOfTick: time)
        }
    }
}

struct GameTimer_Previews: PreviewProvider {
    static var previews: some View {
        GameTimer(extraTime: false)
    }
}
