import Foundation

enum stopWatchMode {
    case notStarted
    case running(Date)
    case paused
    case expired
}

public class TimerUtils {
    public static let tickFrequencyMs = 200.0

    public static func getFormattedTimeLeft(numberOfMilliseconds: Int) -> String {
        let totalSecondsLeft = ceil(Double(numberOfMilliseconds) / 1000.0)
        let minutesLeft = Int(totalSecondsLeft / 60.0)
        let secondsLeftInCurrentMinute = Int(totalSecondsLeft.truncatingRemainder(dividingBy: 60))

        return "\(String(format: "%02d", minutesLeft)):\(String(format: "%02d", secondsLeftInCurrentMinute))"
    }
}

class TimerState {
    var isPastHalfTime = false
    var isPastExpirationWarning = false
}
