import SwiftUI

enum stopWatchMode {
    case stopped
    case running
    case paused
}

class StopWatchManager: ObservableObject {
    @Published var millisecondsElapsed = 0
    @Published var mode: stopWatchMode = .stopped
    
    var timer = Timer()
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {
            timer in self.millisecondsElapsed += 100
        }
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
