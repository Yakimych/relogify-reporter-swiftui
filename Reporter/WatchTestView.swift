import SwiftUI
import WatchConnectivity

class TestWatchWrapper: NSObject, WCSessionDelegate {
    private let session: WCSession

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }

    func sessionDidBecomeInactive(_ session: WCSession) {

    }

    func sessionDidDeactivate(_ session: WCSession) {

    }

    func activateSession() {
        if WCSession.isSupported() {
//            let session = WCSession.default
//            session.delegate = self
            session.activate()
        }
    }

    func getActivationState() -> WCSessionActivationState {
        return session.activationState
    }

    func getIsReachable() -> Bool {
        return session.isReachable
    }

    func encodeAndSend(items: [PlayerInCommunity]) {
        if let encoded = try? PropertyListEncoder().encode(items) {
            try! session.updateApplicationContext([PlayersInCommunitiesStorage.storageKey: encoded])
        }
    }
}

struct WatchTestView: View {
    var testWatchWrapper = TestWatchWrapper()

    @State var activationState: WCSessionActivationState = .notActivated
    @State var watchIsReachable: Bool = false

    var body: some View {
        VStack {
            Button("Activate Session") {
                testWatchWrapper.activateSession()
            }

            Button("Update activation state") {
                activationState = testWatchWrapper.getActivationState()
            }

            Button("Update isReachable") {
                watchIsReachable = testWatchWrapper.getIsReachable()
            }

            Button("Send") {
                testWatchWrapper.encodeAndSend(items: [PlayerInCommunity(communityName: "manualtest", playerName: "testplayer", id: UUID())])
            }

            Text("Watch is reachable: \(watchIsReachable ? "YES!" : "NO")")

            switch (self.activationState) {
                case WCSessionActivationState.notActivated:
                    Text("ActivationState: Not Activated")
                case WCSessionActivationState.activated:
                    Text("ActivationState: Activated")
                case WCSessionActivationState.inactive:
                    Text("ActivationState: Inactive")
                @unknown default:
                    Text("ActivationState: Unknown")
            }
        }
    }
}
