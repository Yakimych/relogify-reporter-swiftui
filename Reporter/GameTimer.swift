import SwiftUI
import Combine
import SwiftySound

struct GameTimer: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var extraTime: Bool
    private var extraTimeBinding: Binding<Bool> {
        Binding (
            get: { return self.extraTime },
            set: setExtraTimeIfAllowed
        )}

    @State private var millisecondsLeft: Double = 0
    @State var mode: stopWatchMode = .notStarted

    private func expirationWarningMilliseconds() -> Double
    {
        //return 30 * 1000
        return 2 * 1000
    }

    private func totalMilliseconds() -> Double {
        if extraTime {
            return 5_000
            //return 2 * 60_000
        }
        return 10_000
        //return 5 * 60_000
    }

    private let timerState: TimerState = TimerState()

    let timer = Timer.publish(every: TimerUtils.tickFrequencyMs / 1000, on: .main, in: .common).autoconnect()

    private let halfTimeSound: Sound = Sound(url: Bundle.main.url(forResource: "half_time_beep", withExtension: "mp3")!)!
    private let expirationWarningSound: Sound = Sound(url: Bundle.main.url(forResource: "expiration_warning", withExtension: "mp3")!)!
    private let finalSirenSound: Sound = Sound(url: Bundle.main.url(forResource: "final_siren", withExtension: "mp3")!)!

    private func start(timeOfStart: Date) {
        switch mode {
            case .notStarted:
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
        mode = .notStarted
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
                        withAnimation {
                            self.mode = .expired
                        }
                        DispatchQueue.global(qos: .background).async {
                            finalSirenSound.play() { completed in
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }
            default:
                break
        }
    }

    private func isAllowedToToggleExtraTime() -> Bool {
        switch self.mode {
            case .notStarted, .paused:
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

    private func getTimerButtonText(text: String, backgroundColor: Color, textColor: Color) -> some View {
        let buttonCornerRadius = CGFloat(10.0)

        return Text(text)
            .fontWeight(.bold)
            .font(.title3)
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .overlay(
                RoundedRectangle(cornerRadius: buttonCornerRadius)
                    .stroke(RelogifyColors.relogifyLight, lineWidth: 5)
            )
            .cornerRadius(buttonCornerRadius)
    }

    var body: some View {
        ZStack {
            Color.black

            if case .expired = mode {
                Text("Game over!")
                    .font(.system(size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(RelogifyColors.relogifyLight)
            }
            else {
                VStack {
                    Spacer()

                    Text(TimerUtils.getFormattedTimeLeft(numberOfMilliseconds: Int(millisecondsLeft)))
                        .font(.system(size: 72))
                        .foregroundColor(RelogifyColors.relogifyLight)

                    Toggle(isOn: extraTimeBinding, label: { Text("Extra Time") })
                        .frame(width: 150, height: 30, alignment: .center)
                        .foregroundColor(RelogifyColors.relogifyLight)
                        .disabled(!isAllowedToToggleExtraTime())
                        .toggleStyle(SwitchToggleStyle(tint: .orange))

                    if case .notStarted = mode {
                        Button(action: { start(timeOfStart: Date()) }) {
                            getTimerButtonText(text: "Start", backgroundColor: RelogifyColors.darkGreen, textColor: Color.yellow)
                        }
                        .padding(.top)
                    }

                    if case .paused = mode {
                        Button(action: { unpause(timeOfStart: Date()) } ) {
                            getTimerButtonText(text: "Start", backgroundColor: RelogifyColors.darkGreen, textColor: Color.yellow)
                        }
                        .padding(.top)
                    }

                    if case .running = mode {
                        Button(action: { pause(timeOfPause: Date()) } ) {
                            getTimerButtonText(text: "Pause", backgroundColor: Color(UIColor.lightGray), textColor: RelogifyColors.relogifyDark)
                        }
                        .padding(.top)
                    }

                    Button(action: reset) {
                        getTimerButtonText(text: "Reset", backgroundColor: Color.red, textColor: RelogifyColors.relogifyDark)
                    }
                    .padding(.top)

                    Spacer()
                }
                .padding()
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
    }
}

struct GameTimer_Previews: PreviewProvider {
    static var previews: some View {
        GameTimer(extraTime: .constant(false))
    }
}
