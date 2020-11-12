import Foundation
import Apollo

class Network {
    static let shared = Network()

    private(set) lazy var apollo = ApolloClient(url: URL(string: "[TODO: Move to configuration (Plist? file]")!)
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
