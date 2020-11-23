import SwiftUI
import WatchConnectivity

class TestWatchWrapper2: NSObject, WCSessionDelegate {
    private let session: WCSession
    private var playersInCommunitiesStorage: PlayersInCommunitiesStorage

    init(session: WCSession = .default, playersInCommunitiesStorage: PlayersInCommunitiesStorage) {
        self.playersInCommunitiesStorage = playersInCommunitiesStorage
        self.session = session
        super.init()
        self.session.delegate = self
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let valueFromContext = applicationContext[PlayersInCommunitiesStorage.storageKey] {
            let receivedCommunityData = valueFromContext as! Data

            let decodedPlayersInCommunities = (try? PropertyListDecoder().decode([PlayerInCommunity].self, from: receivedCommunityData)) ?? []

            DispatchQueue.main.async {
                self.playersInCommunitiesStorage.items = decodedPlayersInCommunities
            }
        }
    }

    func activateSession() {
        if WCSession.isSupported() {
            session.activate()

            // TODO: Can this be removed?
//            if let valueFromContext = session.receivedApplicationContext[PlayersInCommunitiesStorage.storageKey] {
//                something = valueFromContext as! [String: String]
//            }
        }
    }

    func getActivationState() -> WCSessionActivationState {
        return session.activationState
    }

    func getSomething() -> [PlayerInCommunity] {
        return playersInCommunitiesStorage.items
    }
}

struct ContentView: View {
    var playersInCommunitiesStorage: PlayersInCommunitiesStorage

    var testWatchWrapper2: TestWatchWrapper2
    @State var activationState: WCSessionActivationState = .notActivated

    init(storage: PlayersInCommunitiesStorage) {
        playersInCommunitiesStorage = storage
        testWatchWrapper2 = TestWatchWrapper2(playersInCommunitiesStorage: storage)
    }

    func getActivateButtonText() -> String {
        switch (self.activationState) {
            case WCSessionActivationState.notActivated:
                return "Not Activated"
            case WCSessionActivationState.activated:
                return "Activated"
            case WCSessionActivationState.inactive:
                return "Inactive"
            @unknown default:
                return "Unknown"
        }
    }

      var body: some View {
        let communities = playersInCommunitiesStorage.items
            VStack {
                Button(getActivateButtonText()) {
                    testWatchWrapper2.activateSession()
                }

                Button("Update State") {
                    activationState = testWatchWrapper2.getActivationState()
                }

                Text("Count: \(communities.count)")
                List {
                    ForEach(communities) { community in
                        Text("\(community.communityName) (\(community.playerName))")
                    }
                }

            }
    }
}
