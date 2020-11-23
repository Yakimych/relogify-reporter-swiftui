import SwiftUI
import WatchConnectivity

struct PlayerInCommunity: Identifiable, Codable {
    let communityName: String
    let playerName: String
    let id: UUID
}

class PlayersInCommunitiesStorage: NSObject, ObservableObject, WCSessionDelegate {
    static public let storageKey = "PlayersInCommunities"

    @Published var items = [PlayerInCommunity]() {
        didSet {
            if let encoded = try? PropertyListEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: PlayersInCommunitiesStorage.storageKey)

                #if os(iOS)
                if WCSession.isSupported() && session.isWatchAppInstalled {
                    try! session.updateApplicationContext([PlayersInCommunitiesStorage.storageKey: encoded])
                }
                #endif
            }
        }
    }

    private static func getFromStorage() -> [PlayerInCommunity] {
        if let data = UserDefaults.standard.data(forKey: PlayersInCommunitiesStorage.storageKey) {
            return (try? PropertyListDecoder().decode([PlayerInCommunity].self, from: data)) ?? []
        }
        return []
    }


    private let session: WCSession

    init(session: WCSession = .default) {
        items = PlayersInCommunitiesStorage.getFromStorage()

        self.session = session
        super.init()
        self.session.delegate = self

        self.session.activate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }

    #if os(watchOS)
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let valueFromContext = applicationContext[PlayersInCommunitiesStorage.storageKey] {
            let receivedCommunityData = valueFromContext as! Data

            let decodedPlayersInCommunities = (try? PropertyListDecoder().decode([PlayerInCommunity].self, from: receivedCommunityData)) ?? []

            DispatchQueue.main.async {
                self.items = decodedPlayersInCommunities
            }
        }
    }
    #endif

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
    }
    #endif
}
