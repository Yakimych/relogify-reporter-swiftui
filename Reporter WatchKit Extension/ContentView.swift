import SwiftUI
import WatchConnectivity

class TestWatchWrapper2: NSObject, WCSessionDelegate {
    private let session: WCSession
    private var something: [String: String] = [:]

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let valueFromContext = applicationContext[PlayersInCommunitiesStorage.storageKey] {
            something = valueFromContext as! [String: String]
        }
    }

    func activateSession() {
        if WCSession.isSupported() {
            session.activate()

            if let valueFromContext = session.receivedApplicationContext[PlayersInCommunitiesStorage.storageKey] {
                something = valueFromContext as! [String: String]
            }
        }
    }

    func getActivationState() -> WCSessionActivationState {
        return session.activationState
    }

    func getSomething() -> [String: String] {
        return something
    }
}

struct ContentView: View {
    //@EnvironmentObject private var playersInCommunitiesStorage: PlayersInCommunitiesStorage

    var testWatchWrapper2 = TestWatchWrapper2()
    @State var activationState: WCSessionActivationState = .notActivated
    @State var valueFromPhone: [String: String] = [:]

      var body: some View {
        //let communities = playersInCommunitiesStorage.items

        VStack {
            Button("Activate Session") {
                testWatchWrapper2.activateSession()
            }

            Button("Update State") {
                activationState = testWatchWrapper2.getActivationState()
                valueFromPhone = testWatchWrapper2.getSomething()
            }

            Text("Count: \(valueFromPhone.count)")

            switch (self.activationState) {
                case WCSessionActivationState.notActivated:
                    Text("Not Activated")
                case WCSessionActivationState.activated:
                    Text("Activated")
                case WCSessionActivationState.inactive:
                    Text("Inactive")
                @unknown default:
                    Text("Unknown")
            }
//
//            VStack {
//                Text("Communities: \(playersInCommunitiesStorage.items.count)")
//                List(communities) { community in
//                    Text(community.communityName)
//                }
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
