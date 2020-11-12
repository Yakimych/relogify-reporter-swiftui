import Foundation
import Apollo

struct Settings: Decodable {
    let apiUrl: String
}

class Network {
    static let shared = Network()

    private lazy var apiUrl: () -> String = {
        let url = Bundle.main.url(forResource: "Settings", withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        let result = try! PropertyListDecoder().decode(Settings.self, from: data)
        return result.apiUrl
    }

    private(set) lazy var apollo = ApolloClient(url: URL(string: apiUrl())!)
}

enum RemoteData<T> {
    case loading
    case loaded(T)
    case error
}

enum ApiCallState {
    case notCalled
    case calling
    case success
    case error
}
