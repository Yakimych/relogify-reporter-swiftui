import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Setting view")
                ChooseCommunity()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
