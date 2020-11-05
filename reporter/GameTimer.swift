import SwiftUI

struct TimerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
    }
}

struct GameTimer: View {
    @State var extraTime: Bool
    @State var secondsLeft: Int = 60
    
    @ObservedObject var stopWatchManager = StopWatchManager()
    
    var body: some View {
        VStack {
            Text("Milliseconds elapsed: \(stopWatchManager.millisecondsElapsed)")
            if stopWatchManager.mode != stopWatchMode.running {
                Button(action: {self.stopWatchManager.start()}) {
                    Text("Start")
                }.buttonStyle(TimerButtonStyle())
            }
            if stopWatchManager.mode == stopWatchMode.running {
                Button(action: {self.stopWatchManager.pause()}) {
                    Text("Pause")
                }.buttonStyle(TimerButtonStyle())
            }
            if stopWatchManager.mode != stopWatchMode.stopped {
                Button(action: {self.stopWatchManager.reset()}) {
                    Text("Reset")
                }.buttonStyle(TimerButtonStyle())
            }
        }
        .navigationBarTitle("Timer")
    }
}

struct GameTimer_Previews: PreviewProvider {
    static var previews: some View {
        GameTimer(extraTime: false)
    }
}
