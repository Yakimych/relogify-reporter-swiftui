import Foundation

enum stopWatchMode {
    case stopped
    case running(Date)
    case paused // TODO: TimeRemaining?
}

class TimerState {
    public static let tickFrequencyMs = 200.0
    var isPastHalfTime = false
    var isPastExpirationWarning = false
}
