import SwiftUI
import Combine
import SwiftySound

struct GameTimer: View {
    @Environment(\.presentationMode) var presentationMode

    @State var extraTime: Bool
    private var extraTimeBinding: Binding<Bool> {
        Binding (
            get: { return self.extraTime },
            set: setExtraTimeIfAllowed
        )}

    @State private var millisecondsLeft: Double = 0
    @State var mode: stopWatchMode = .stopped

    private func expirationWarningMilliseconds() -> Double
    {
        return 30 * 1000
    }

    private func totalMilliseconds() -> Double {
        if extraTime {
            return 2 * 60_000
        }
        return 5 * 60_000
    }

    private let timerState: TimerState = TimerState()

    let timer = Timer.publish(every: TimerState.tickFrequencyMs / 1000, on: .main, in: .common).autoconnect()

    private let halfTimeSound: Sound = Sound(url: Bundle.main.url(forResource: "half_time_beep", withExtension: "mp3")!)!
    private let expirationWarningSound: Sound = Sound(url: Bundle.main.url(forResource: "expiration_warning", withExtension: "mp3")!)!
    private let finalSirenSound: Sound = Sound(url: Bundle.main.url(forResource: "final_siren", withExtension: "mp3")!)!

    private func start(timeOfStart: Date) {
        switch mode {
            case .stopped:
                reset()
                mode = .running(timeOfStart)
            default:
                break
        }
    }

    private func unpause(timeOfStart: Date) {
        switch mode {
            case .paused:
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
        millisecondsLeft = totalMilliseconds()

        timerState.isPastHalfTime = false
        timerState.isPastExpirationWarning = false
    }

    private func tick(timeOfTick: Date) {
        switch mode {
            case .running(let lastTickAt):
                if self.millisecondsLeft > 0 {
                    self.mode = .running(timeOfTick)
                    let millisecondsElapsedSinceLastTick = timeOfTick.timeIntervalSince(lastTickAt) * 1000

                    if (self.millisecondsLeft > millisecondsElapsedSinceLastTick) {
                        self.millisecondsLeft -= millisecondsElapsedSinceLastTick

                        if (self.millisecondsLeft < expirationWarningMilliseconds() && !timerState.isPastExpirationWarning) {
                            timerState.isPastExpirationWarning = true
                            DispatchQueue.global(qos: .background).async { expirationWarningSound.play() }
                        }

                        if (self.millisecondsLeft < totalMilliseconds() / 2 && !timerState.isPastHalfTime) {
                            timerState.isPastHalfTime = true
                            DispatchQueue.global(qos: .background).async { halfTimeSound.play() }
                        }
                    }
                    else {
                        self.millisecondsLeft = 0
                        self.mode = .stopped
                        DispatchQueue.global(qos: .background).async { finalSirenSound.play() }
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            default:
                break
        }
    }

    private func isAllowedToToggleExtraTime() -> Bool {
        switch self.mode {
            case .stopped, .paused:
                return true
            default:
                return false
        }
    }

    private func setExtraTimeIfAllowed(_ newValue: Bool) {
        if isAllowedToToggleExtraTime() {
            extraTime = newValue
            reset()
        }
    }

    var body: some View {
        VStack {
            Text("Milliseconds left: \(millisecondsLeft)")
            Button(action: {
                start(timeOfStart: Date())
            }) {
                Text("Start")
            }.buttonStyle(TimerButtonStyle())

            Button(action: {
                unpause(timeOfStart: Date()) }
            ) {
                Text("Unpause")
            }.buttonStyle(TimerButtonStyle())

            Button(action: { pause(timeOfPause: Date()) } ) {
                Text("Pause")
            }.buttonStyle(TimerButtonStyle())

            Button(action: reset ) {
                Text("Reset")
            }.buttonStyle(TimerButtonStyle())

            Toggle(isOn: extraTimeBinding, label: { Text("Extra Time") })
                .disabled(!isAllowedToToggleExtraTime())
        }
        .navigationBarTitle("Timer")
        .onReceive(timer) { time in tick(timeOfTick: time) }
        .onAppear {
            millisecondsLeft = totalMilliseconds()
            DispatchQueue.global(qos: .background).async {
                halfTimeSound.prepare()
                expirationWarningSound.prepare()
                finalSirenSound.prepare()
            }
        }
    }
}

struct GameTimer_Previews: PreviewProvider {
    static var previews: some View {
        GameTimer(extraTime: false)
    }
}
