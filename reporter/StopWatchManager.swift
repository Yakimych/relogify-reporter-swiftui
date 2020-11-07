import SwiftUI
import SwiftySound

enum stopWatchMode {
    case stopped
    case running
    case paused
}

class StopWatchManager: ObservableObject {
    @Published var millisecondsElapsed = 0
    @Published var mode: stopWatchMode = .stopped
    
    let totalMilliseconds = 5 * 60 * 1000
    let expirationWarningMilliseconds = 30 * 1000

//    let totalMilliseconds = 5 * 1000
//    let expirationWarningMilliseconds = 2 * 1000
    
    let tickFrequencyMs = 200
    
    var isPastHalfTime = false
    var isPastExpirationWarning = false
    var timer = Timer()
    var funcToRunOnExpired: () -> Void = {}
    
    func onExpired(funcToRun: @escaping () -> Void) -> Void {
        self.funcToRunOnExpired = funcToRun
    }
    
    func start() {
        isPastHalfTime = false
        isPastExpirationWarning = false
        timer = Timer.scheduledTimer(withTimeInterval: Double(tickFrequencyMs) / 1000, repeats: true) {
            timer in self.millisecondsElapsed += self.tickFrequencyMs
            if (self.millisecondsElapsed > self.totalMilliseconds / 2 && !self.isPastHalfTime) {
                self.isPastHalfTime = true
                Sound.play(file: "half_time_beep.mp3")
            }
            
            if (self.millisecondsElapsed > self.totalMilliseconds - self.expirationWarningMilliseconds && !self.isPastExpirationWarning) {
                self.isPastExpirationWarning = true
                Sound.play(file: "expiration_warning.mp3")
            }
            
            if self.millisecondsElapsed > self.totalMilliseconds {
                self.reset()
                Sound.play(file: "final_siren.mp3")
            }
        }
        //Sound.play(file: "expiration_warning.mp3")
        mode = .running
    }
    
    func pause() {
        timer.invalidate()
        mode = .paused
    }
    
    func reset() {
        timer.invalidate()
        self.millisecondsElapsed = 0
        mode = .stopped
    }
}
